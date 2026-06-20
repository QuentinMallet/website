+++
title = "Formal specs in cybersecurity"
date = 2026-05-26
description = "Formal specs are already accepted in the SE industry, here's why they are useful in cyber, both technical and GRC"
+++

> “When I use a temporal property,” Humpty Dumpty said in rather a scornful tone, “it means just what I choose it to mean, neither more nor less.”
(Lewis Carroll, 25% confidence)

What does an ISO27001 compliant clearance management process, an autopilot to avionics link and a dynamic VPN credential manager have in common?

Those are process with many different inputs, interesting time-bound failure conditions and complexities that can create safety-destroying system states.

In all those cases if you got it wrong you won't know immediately and by the time you know you will likely be in a very very bad place. 

One of my favourite tools for all kind of process from compliance to development is formal methods. TLA+ formal specifications
to be precise.

What you do:
- write out your system state machine
- write out your safety requirements (things that should never happen given your state machine)
- write out temporal properties (the system should eventually reach such a state, the system should always have such and such characteristics)

Then you use a model checker that actually tests your state machine safety and properties, that way you know you haven't handwaved anything.
If you are feeling fancy you can even write a formal proof of your safety or temporal properties you can then check using a theorem prover.

What you get:
- A rigorously proven specification you can build against
- invariants and temporal assertions you can build a property-based testing suite around
- extensibility: if you need to zoom in on a specific implementation, you can add a specification layer and check that this new layer is still coherent with the whole


Now, the real fun bit. I read an article a couple of years ago that blew my mind. Credit where credit's due, I didn't get this idea first but I have used it pretty much on every job where I've written specs. It's [modeling the adversaries](https://www.hillelwayne.com/post/adversaries/). Threat models are always useful for risk management. Threat specification allows you to rigorously describe your threats as you specify your system and countermeasures. you can materialize the killchains you come up with as state transitions and validate whether they are at all doable and how to break them. It's a great way to evaluate your remediations and avoid overspending on the wrong ones
