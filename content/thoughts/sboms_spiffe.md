+++
title = "SBOMS all the way from commit to runtime"
date = 2026-07-07
description = "SBOMs are hard, but the tools to make them easy are already here, free and open source"
+++

SBOMs all the way from commit hash to runtime environments


In recent devsecops engagements I have had the opportunity to discuss at length what makes a good SBOM. Exhaustiveness, parsable by machine, easily plugged into a vulnerability management program.

Sounds heavy, costly and not very agile, right? Doesn't have to be.

You can move fast and still reap those benefits.

I love tinkering at home on the weekend, I feel building systems from scratch for personal use is the best way to familiarize oneself with their failure modes and I think direct hands on knowledge greatly helps with credibility when advising a particular solution to a customer.

Let's go!

I use Nix for packaging software. Mine, other people's, any software. Need to build a docker image? I use nix to have a reproducible, from scratch image with only the required dependencies. Need to define a complete standardized deployment? Nixos has me covered.

Nix pins everything cryptographically. Down to the driver version I can prove provenance for each bit of the systems I run. Nix-audit then lets me automatically list vulnerabilities for every component.

Now that's fine and everything, but how do I know that the workload I run actually matches what I have on file?

I've started playing with SPIFFE (Secure Production Identity Framework for Everyone) at home and I think I found the missing link I was looking for.


Basically, you use an agent to authenticate the workload (run as x user, from y bin) and ensure that what's running on your hardware is really what you want and not someone else's code hiding (eg: an xmrig instance masquerading as some java app). Together with nix, the bin called is from an immutable filesystem with a path generated based on the hash of its components. If you build your agent configuration on a trusted machine then you know beforehand that if the agent authenticates x workload then it matches what got built.

Once it's deployed it lives in a read only volume (the nix store).

And the best part is, plugging into my home IDP (zitadel) was easy as pie: federate with the SPIRE server, create identity mappings and voila! one single place where I can associate workloads with policies without having to play three cards monte with approle and wrapped response every time I reboot my server (which is at least weekly depending on kernel patch drops).

So, when I want to deploy some code I wrote I just need to add the nixos module, update my agent configuration file with the final hash of the components (automatically computed by nix) and I get the full trust chain.

