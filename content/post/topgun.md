+++
title = "The applications of Top Gun to software engineering"
draft = true
date = "2017-03-26T21:35:50+01:00"

tags = ["top gun", "software engineering"]
author = "Laurie Clark-Michalek"

+++

The Merriam-Webster dictionary defines Top Gun as 'a 1986 American romantic
military action drama film directed by Tony Scott'. This definition might serve
us well at the local pub quiz, but there is much more to learn about this film.
During a recent viewing, I realised that there were a large number of useful
parallels and not so parallels between the disciplines of piloting fighter
aircraft in 80's action films and developing robust software.

Needless to say, this post contains **significant Top Gun spoilers.**

## Parallels

The crises that the Top Gun staff face are superficially different from the
crises that a software development team faces, but a deeper inspection yields
some hard to ignore parallels. A few key scenes show that these worlds are
similar on a deep and meaningful level.

### On failed deployments

> *Viper*: The simple fact is you feel responsible for Goose and you have a confidence problem. Now I'm not gonna sit here and blow sunshine up your ass, Lieutenant. A good pilot is compelled to always evaluate what's happened, so he can apply what he's learned.

Blameless postmortems have become an accepted part of the software industry,
which is a great thing. They're practised to various degrees of quality and
every company has a different process, but generally aim to figure out what went
wrong and what can be improved, without assuming bad faith from any member of
the team.

The military tribunal that Maverick had to appear before was not designed to be
blameless, but he emerged with his record clean. Yet he still feels guilty,
given his friend just died, and actions he took could have influenced that.

In software development, when an action such as a deployment or a database
migration causes an issue we do our postmortem. We identify root causes, and
we fix the issues with technology and process that contributed to the issue (the
social and structural issues we sweep under the rug and blame management for).
However, after all that, an engineer can still feel scared to perform that
action. This is the worst state to be in.

Being scared to do something means either there are issues that were not
addressed in the postmortem, or that you have a confidence problem. Having a
confidence problem is a big issue. How did Viper attempt to fix Maverick's
confidence problem?

> *Viper*: Get him up flying, soon.

After a deployment goes bad, after a migration goes bad, make sure that you make
that change again. Find a typo to fix, an error to check, a column to add,
basically anything. The most important time to deploy is as soon as possible
after an incident.

Without confidence, you stop deploying frequently. Your bugs build up. You have
more changes per release. You have more failures. Your confidence gets worse.
When something goes wrong in your team, make sure that your plans include checking
people's confidence in the aftermath, and taking remedial actions if necessary.

### On teamwork

> *Iceman*: Maverick, it's not your flying, it's your attitude. The enemy's dangerous, but right now, you're worse than the enemy. You're dangerous and foolish. You may not like the guy's you're flying with you, they may not like you. But who's side are you on?

Iceman is often portrayed as the antagonist in Top Gun, but he provides Maverick
with a lot of salient points, if presented in a less than constructive manner.
Iceman understands better than Maverick that he doesn't operate in a vaccum, and
that he needs to work with his teammates when he's in the sky.

Maverick and, to a lesser extent, his collegues treats the sky like a null sum
game, and this causes problems again and again. Now, this is mostly because they
take the competition to be 'the best of the best' way too seriously, but it is
still inexcusable. Software must be written with the future reader in mind, with
most everything else playing second fiddle.

> *Iceman*: You're everyone's problem. That's because every time you go up in the air, you're unsafe. I don't like you because you're dangerous.

Someone being called Maverick is probably a bad sign. Being unorthodox has a
price, and it's better not to have unorthodox be such a common state that
Maverick becomes your call sign. That's not to say you can't justify being
unorthodox, but you do have to justify it. Orthodox code is better than
unorthodox code, all things being equal.

Iceman does have a large issue with tone however. Someone being dangerous
shouldn't be a cause to dislike anyone. Someone being dangerous is a reason to
look at the process that is causing them to be dangerous and the systems that
incentivise that danger. Being blameless shoudn't stop after the postmortem is
over.

## Not so parallels

Of course, some of the differences are not so superficial, but that does not
mean they are not useful. By looking at some of the limitations that Top Gun
pilots have that software developers do not have, we can start to think about
how we can take full advantage of our capabilities.

### On the consequences of a crisis

*Note*: There are jobs where this doesn't apply. Most jobs, it does. But if you
work somewhere where your software is critical to people's lives, then I don't
know how much value this will provide.

> *Goose*: The defense department regrets to inform you that your sons are dead because they were stupid.

I work for a firm that helps other firms sell things. When our systems go down,
nobody dies. This is a super weapon. Every time there's an incident, I already
know the upper bound. Nobody will die. This gives me the space to stop panicing.
I can think before taking an action. I can inform others, I can document what
I'm doing, I can take the time to be careful and deliberate.

Humans have a tendency to panic, and an incident is not a situation where panic
is constructive. 'No one dies' is my mantra to keep panic from being a factor in
my incidents.

Of course, someone dying is still an incredibly high ceiling. Discovering what
the worst case scenario is for a system is not obvious, and working out the
'incident impact' distribution is takes time. When you join a team, you don't
have any context on what something breaking means. Getting involved in incidents
from day one helps give you that context, as well as building up a mental
runbook (obviously, having runbooks written down is better, but both is best).

### On time sensitivity

> *Maverick*: You don't have time to think up there. If you think, you're dead.

And there's no clearer difference between the two roles to me. I've had
incidents in the past that I could have fixed immediately, but where I instead
took 5 minutes to fetch a coworker, and show them the process of debugging and
fixing the issue. We have that luxury in computing. An incident will usually
take at least 15 minutes to handle, so we can always take the few seconds to
grab a pair, to document our process, and to double check our thinking.

> *Officer*: It'll take ten minutes.
> *Stinger*: Bullshit ten minutes! This thing will be over in two minutes! Get on it!

Most of my services don't serve a crazy amount of traffic. They do enough that
looking at the logs isn't a viable monitoring strategy, but not enough that any
change instantly shows up in my metrics. When I look at my Grafana dashboards, I
don't look at the point representing 'now' on any of the plots. Because my
quantities are't Google high, there's a decent chance that there's significant
variance on the points (even more so during an incident), and 9 times out of 10
a value that suggests something interesting happening will quickly regress to
the mean.

There are plenty of systems where two minutes and less is critical, but we often
have the ability to design systems where that isn't true. We use queues to defer
processing, we use redundancy to tolerate failure, we use a whole host of
techniques to help us avoid the question 'why is this pager ruining my life'.

### On competiton

> *Iceman*: The plaque for alternates is down in the ladies room

The Top Gun academy is set up to be based around a competition. Each pair that
comes in earns points as they fly sorties against the instructors, and those
points add up to determine their ranking at the end of the course. This is a
horrible way to run a software engineering team.

The idea of a null sum game is easy to induce in people. Top Gun does it by
stating that 'there are no prizes for second place'. This causes the trainees to
fly like asses, producing suboptimal results. The two most notable examples of
this are 1) when Maverick abandons his wingman, Iceman, to persue a target
alone. They both fail to achive their goals. And 2) when Iceman refuses to move
to give Maverick a shot, which indirectly causes an accident, and Goose's death.
These incidents are a fault not in the characters, but in the design of Top
Gun's incentive system.


