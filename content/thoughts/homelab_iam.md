+++
title = "Homelab IAM"
date = 2026-06-30
description = "Secret and user management in homelab"
+++

> Making your yak shed is easier than shaving it, especially if it's big enough that you can't shave as fast as it grows fur.
(Me)

I recently started a major migration in my homelab. I am a big believer in practicing what I preach and over the years I have gotten into the habit of first testing out hardening and monitoring techniques in my personal prod environment
before rolling them out to customers. Today I'm extending it to the best practices I've been implementing for secret management and IAM.


The problem:
My personal fleet is made of about a dozen linux machines and many projects. Forks from popular open source project, bespoke personal web applications and daemons.

Not having too much time to tinker with them (and wanting to keep the other users of my services happy, they know where I live) I chose NixOS to easily manage deployments, rollbacks and have a measure of IaC.

The other day I went to add yet another service to my stack and, as I went through my checklist, it hit me in the face: my manual certificate creation/user seeding/secret deployment was unsustainable for the long term.

So instead of spending 5 minutes setting up the service I spent two days integrating new subsystems:

- an OpenBao instance for secret management
- a Zitadel instance for IAM

This was a conscious choice: reimplementing user management over and over again meant I had many versions at various level of maturity (this infra is more than 12 years old now, old enough to run around screeching with delight before hitting furniture and otherwise making creative messes), creating a big pile of ssh encrypted age secrets in my reference IaC repo meant my cattle was still a bit pet-like: new machine meant re-encrypting all the secrets.

Now it's cleaner, and I just have the one "easy" task: retrofit SSO on my other workloads.

Next? SPIFFE for Secret zero, because manual wrapped responses for openbao secretIds don't feel too clean when cat-induced power outages happen.
