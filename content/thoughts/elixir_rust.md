+++
title = "Elixir and rust for a fun new stack"
date = 2026-06-18
description = "elixir and rust combined for speed, concurrency and fault tolerance"
+++


> It's alive, it's moving, it's alive, it's alive, it's alive, it's alive, IT'S ALIVE!
...
Wait, why is it setting up shop in the prod environment?
(Frankenstein, 1931 - somewhat apocryphal )



On every team I have been, from analyst to CISO, one of the parts of the job I enjoyed best was toolmaking. Each IS is different and where toolmaking shines
is when you find the right business domain data to contextualize and prioritize your security alerts.

Tools are fun to make, but they have a way to escape you while being still prototypes and end up running in production before you have finished sewing them up.

What's one to do then?

- docker + python combos? nice, but grows fat and you need manage the image lifecycle
- docker image from scratch and rust/python executables? nicer, leaner, meaner, not as many issues with lifecycle management and in most shops
with a basic cloud provider subscription, as long as the compute remains stateless you can get pretty good reliability.


Then you encounter a shop where everything runs on-prem. There's a couple datacenters on opposite ends of the city. We're good for small-sized meteoric impacts, my risk register says so!

On the toolmaking front though, all you can hope for is one small bare-metal in each.

You negotiate and get a VPS somewhere because luckily you're not the first one to tell them about split-brain scenarios.

OK, so, now I need:

- an image registry
- container static analysis
- lifecycle management
- CD
- HA DB
- HA Cache

Most likely if I try to sell that to the board I'll be asked to cut into my audit budget if I'm listened to at all.

My solution:

For the last months I have been playing with a new techstack that has delighted me:

- NixOs Base -> fully auditable, reproducible stack with free SBOM thrown in
- Elixir BEAM application running with Horde -> HA out of the box, fault tolerance and supervision built in 
  - (D)ETS for runtime ephemeral node-local data
  - Mnesia for cluster-wide data until you need SQL capabilities (with a big caveat: split-brain scenarios MUST be thought through in advance)
- Garage -> S3 compatible blob storage with by-design regionalization, resilience and restoration for any and all artifacts
- SOPS for secret management
- Dex for static user management (if appropriate)

Quick to setup, easy to maintain and clear improvement paths:
- Openbao/another KMS to replace SOPS so you get proper secret management capabilities
- a real IdP for user management => you can just connect Dex to it, no need to change your current code
- rqlite then/or yugabytedb instead of Mnesia if you start needing dedicated database capabilities 
- turn it into a container with a one-line change in your nixos output
- add Rust ports if you need extra oomph in the hot path

