+++
title = "The applications of Top Gun to software engineering"
draft = true
date = "2017-03-26T21:35:50+01:00"

tags = ["top gun", "software engineering"]
author = "Laurie Clark-Michalek"

+++

Top Gun has a lot to teach us about software development. Through a recent
viewing, I noticed a number of useful parallels and perpendicular. **Significant
spoilers ahead**

## Parallels

Th crises that the Top Gun staff face are different from the crises that a
software developer faces. However, we can still learn from their approaches to
failure and learning.

### On failed deployments

> *Viper*: The simple fact is you feel responsible for Goose and you have a confidence problem. Now I'm not gonna sit here and blow sunshine up your ass, Lieutenant. A good pilot is compelled to always evaluate what's happened, so he can apply what he's learned.

Blameless postmortems have become an accepted part of the software industry,
which is a great thing. They're practised to various degrees of quality around
the place, but generally aim to figure out what went wrong and what can be
improved, without assuming bad faith on any member of the team.

The military tribunal that Maverick had to appear before was not designed to be
blameless, but he emerged with his record clean. Yet he still feels guilty,
given his friend just died, and actions he took could have influenced that.

In software development, when an action, such as a deployment, or a database
migration, causes an issue, we do our postmortem. We identify root causes, and
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

Without confidence, you stop deploying frequently. Your bugs build up. You get
bigger releases. You have more failures. Your confidence gets worse. When
something goes wrong in your team, make sure that your plans include checking
people's confidence in the aftermath, and taking remidatial actions if
neccesary.

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
