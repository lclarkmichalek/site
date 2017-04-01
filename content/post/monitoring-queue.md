+++
date = "2017-04-01T21:13:56+01:00"
title = "A worked example of monitoring a queue based application"
draft = true

tags = ["software engineering", "monitoring", "prometheus"]
author = "Laurie Clark-Michalek"
+++

# Stash Deferred

At Qubit, we have a service named 'Stash Deferred'. It reads from a database,
[GCP's Cloud Bigtable](https://cloud.google.com/bigtable/), and writes to
[AWS's Kinesis](https://aws.amazon.com/kinesis/streams/). Recently it underwent
a bit of a renovation by the team that I am on, and a colleague commented that
the end result had quite good monitoring, potentially worth of being a case
study. Anyway, so here's that.

Stash Deferred is a system for deferring message writes. A user sends, via a
HTTP call, a message, and an expiry timestamp. When the expiry time is reached,
the message is put onto the Kinesis queue. There is no guarentee of ordering
given.

Bigtable is a key value store that supports 'get', 'set', 'delete' and 'scan'.
Scan allows you to request values between two keys, in lexographical
(alphabetical) order. This is the operation that Stash Deferred uses to fetch
messages that should be sent. Every interval we send a request for all of the
values with keys between 'deferred:' and 'deferred:<current unix timestamp>'.
These are the messages have 'expired', and should be put onto the kinesis queue.

So, fairly simple. We read rows from Bigtable, publish their contents to
Kinesis, then delete them from Bigtable. This look something like this:

![Simple arch diagram](/imgs/stash-deferred/simple.png)

The internal arrows here are unbuffered Go channels. We use them as we perform
the operations at different rates; scans happen in large batches, publishes are
unbatched, and deletes use small batches.

# Basic Monitoring

There are three main operations here that we want to monitor; scan, publish, and
delete. For each of these operations (and basically any operation in any
application) there are two properties we can easily instrument: duration and
count. I'll use the Kinesis publisher as my example for this. We define two
metrics:

```
var (
	kinesisWriteCount = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "stashdef_kinesis_message_write_total",
			Help: "count of kinesis messages written, tagged by result",
		},
		[]string{"result"},
	)
	kinesisWriteDuration = prometheus.NewHistogram(
		prometheus.HistogramOpts{
			Name:    "stashdef_kinesis_message_write_duration_seconds",
			Help:    "duration of kinesis write operations",
			Buckets: prometheus.ExponentialBuckets(0.1, 3, 6),
		},
	)
)
```

If you've never seen Prometheus metrics before, then I'll give you a brief
explanation of what I'm declaring here.

The first metric is the variable `kinesisWriteCount`, which is registered as
`stashdef_kinesis_message_write_total` on the Prometheus server. This might seem
like a crazy long name, but there is a certain logic to it. Prometheus metrics
follow the naming convention of `<namespace>_<metric name>_<units>`. In this
case, our namespace is the abbreviated name of our program, `stashdef`. The name
of the metric is always a little contentious, but `kinesis_message_write` is an
understandable description of the operation we're monitoring. The unit is even
less clear, using `total`. There is debate wether `total` or `count` is clearer
to use when you're counting something, but I use `total`, as `count` is often
used by the default Prometheus libraries, and my use is not always compatible
with their use.

The other thing to note about this metric is that we have a label on it.
Prometheus allows you to add labels to your metrics, adding additional
dimentions. In Qubit, we have a convention of having a label called result,
which has two values: `success` and `failure`.

The second metric is the variable `kinesisWriteDuration`, registered as
`stashdef_kinesis_message_write_duration_seconds`. Much the same as the above,
the key differences are that this is a histogram. A histogram is made up of a
number of counters, each representing a different bucket. Here I set up a set of
exponetially distributed buckets, with 0.1 being my starting bucket, 3 being my
exponent, and 6 being the number of buckets. This results in buckets counting
requests [0,0.1), [0.1,0.3), [0.3,0.9), etc etc.

The other change is in the name of the metric, where we exchange `total` for
`duration_seconds`. Adding the unit to the metric name makes life easier for
everyone involved, and seconds is preferred for durations, given its SI status.
All Prometheus metrics are 64 bit floating point numbers, so the number of cases
where using seconds as a unit could cause issues is neglible.

With our metric set up, we can now instrument our publishing code.

```
func (k *KinesisWriter) Write(ctx context.Context, messageChan <-chan Message, delchan chan<- string) error {
	for {
		var msg Message
		select {
		case <-ctx.Done():
			return ctx.Err()
		case msg = <-messageChan:
		}

		started := time.Now()
		err := k.publish(msg)
		if err != nil {
			log.Warningf("could not publish message: %v", err)
			kinesisWriteCount.WithLabelValues("failure").Inc()
		} else {
			kinesisWriteCount.WithLabelValues("success").Inc()
		}
		kinesisWriteDuration.Observe(float64(time.Since(started)) / float64(time.Second))

		select {
		case <-ctx.Done():
			return ctx.Err()
		case delchan <- msg.AckId:
		}
	}
}
```

Gripping stuff. I've omitted some code that handles retries and suchlike. With
this, we get some incredibly useful metrics. Let's play with them.

The first thing I'd like to see is the throughput of my system. This is the rate
of increase of the write count metric:

```
rate(stashdef_kinesis_message_write_total[1m])
```

As our metric is not a continuous function, we can't simply differentiate it, so
we need to specify over what period we want our rate to be calculated. This is
the period in the square brackets. 1m is a convention within Qubit, along with
30m for when you want a calmer view. In general, the smaller the window, the
less data required, the faster the result.

When we graph this in the Prometheus UI, we get

![kinesis message write rate](/imgs/stash-deferred/rate-kinesis-write-total.png)

What we see here is that Prometheus has calculated the rate for each set of
labels we have sent. In the graph's legend, we can see the set of labels that
Prometheus has associated with our metrics. Many of them are generated by
Prometheus based on the metadata attached to our application's deployment, but
on the far right we can see the `result` metric. If we had more that one
instance of the application running, we would end up with more than 2 lines. To
merge those lines together, we need to specify an aggregation method. In this
case, as we are interested in the throughput of the system, we probably want to
sum all the lines together, to get the number of messages we are handling per
second:

```
sum(rate(stashdef_kinesis_message_write_total[1m]))
```

![sum_kinesis message write rate](/imgs/stash-deferred/sum-rate-kinesis-write-total.png)

Realistically, the information we want on our Grafana dashboard is probably the
overall success and error rates. We can do this by summing over a specific
label. This is similar to the `GROUP BY` statement in SQL:

```
sum(rate(stashdef_kinesis_message_write_total[1m])) by (result)
```

Putting that on our dashboard, we get

![sum-rate-kinesis-write-result](/imgs/stash-deferred/sum-rate-kinesis-write-result.png)

Beautiful. Let's take a look at our duration metrics next.
