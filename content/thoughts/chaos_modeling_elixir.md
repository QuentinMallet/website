+++
title = "Chaos Modeling with elixir and snabbkaffe"
date = 2026-06-23
description = "Using the OTP paradigm to model production systems and attacks"
+++


As I learn elixir and apply it to more and more project ideas I found an interesting niche. Today we'll talk about Snabbkaffe, a tracing-based testing library that supports fault injection.


Example for a complex case to simulate (especially if you are sharing the test env with a dev team): what happens if the db gets slow, you get more user input and someone crashes your cache server right at that moment.


Enter elixir. Its runtime is a natural chaos engineering substrate because supervision trees, process isolation, and fault injection are built-in. Those map to your systemd/k8s restart policies and high availability/failover configurations (conceptually they are the same, just expressed differently and on the BEAM vm). You can also simulate a distributed infrastructure easily with BEAM processes and then test out situations and attacks as you go. You don't need the full implementation, just a useful abstraction. This enables complete control to simulate feasibility of very specific events.


Quick example:


An attacker finds a flaw that lets them exfiltrate files from your blob storage as long as the query against them results in a cache-miss caused by cache unavailability. That one can be stumbled on if you mess up the input validation check and your redis instance can be accessed from the internet.


Scenario:

- attacker goes through rent-a-bot to put your redis instance under enough DDoS traffic to make it unusably slow or even completely unresponsive. Your app continues working and considers all those timeouts through a cache-miss path. Too bad you also have an injection vulnerability that allows the cache-miss path to request another file than the one that was initially queried from the cache!


Modeling

- Snabbkaffe injection point on the cache genserver functions
- periodic_crash so you can test out at what level of cache service degradation the attack becomes reliable
- some statistics to model exactly where your detection ceiling is (see my post on SPC for security event detections)

Why bother with this? because a smart attacker wouldn't just nuke your redis instance from orbit, grab what they can and run. they'd want the ability to extract as much data as possible without you noticing, hence  aiming for that sweet spot where your team can get lulled into a "eh, that's just a capacity planning issue, not a real attack" state. To do that they need to find the stealth-band: degraded enough to extract data at an operationally acceptable speed (attackers have budgets too don't you know!) while maximizing the dwelling time.

The better funded the attacker, the bigger weight they can put on the "dwelling time" side of the scales. Something to keep in mind when the data you're protecting is state-actor bait instead of carder chum, and a good way to justify the marginal cost of reducing the "stealth-band" by investing into your detection capabilities.

