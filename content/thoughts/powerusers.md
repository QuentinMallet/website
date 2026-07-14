+++
title = "Plea for the powerusers"
date = 2026-07-14
description = "Power users will power use things, repression doesn't beat shadow IT, ease of use does."
+++

> 'Automating' comes from the roots 'auto-' meaning 'self-', and 'mating', meaning 'screwing'.
XKCD


Every IT org I've seen has the same flaw. Absolutely no support for non-IT power users beyond a stake and complimentary kindling for firestarting.

Who are those power users? Basically people with one standard ask:

- they want to automate things they'd otherwise do themselves
- they don't ask for more privileges
- they just want to make their own tooling


Today's hot take: with agentic AI this category of users is about to explode in numbers. If it hasn't already. Yes the power users are in the room with us right now.


How to deal with them?
Here's my decision framework:

- do you believe automatization and standardization are business enablers?
- do you trust your identity management platform?
- do you trust your telemetry infra (not just logs but traces and metrics)?

If you said no to any of these you have better things to do than read this post.
If you said yes: start making PATs (personal access tokens) available to your powerusers with a sane self-serve process:


- what subset of their privileges they want to delegate
- how long (no long-lived PAT) => no minting on weekends, special review for validity beyond COB
- purpose of the PAT


You just made all those pesky shadow IT selenium scripts that prop up your infra completely uneconomical. You now have indicators for all those bespoke services.

Now you will know when to promote them from "Joe's tuesday ETL batch" to "recurring infra job".
