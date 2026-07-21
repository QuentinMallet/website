+++
title = "Min stack for a secure playground"
date = 2026-07-21
description = "creating a safe substrate to standardize in-house poweruser coding practices"
+++

> If Moscow rules meant watch your back, London rules meant cover your arse.
Slow Horses

Mini stack for a secure playground

Following up on my post regarding power users and PATs. As discussed then, we can assume the following: Power users will automate. You only get to choose whether they do so within your security posture or against it.

I choose the former because there are more of them than there are of me and they've been hired exactly for that kind of mindset. Hence: they need something safe to automate against and somewhere safe to build. Here's the substrate I've been building:

- No in-app secret management => everything in a secret manager
- No in-app identity management => everything in an IDP
- least privilege and attribution through app processes => user triggered actions use `act`  in the JWT for attribution and biscuit tokens for access attenuation
- No in-app authorization wiring => everything through OPA
- standardized opentelemetry abstraction for easy on-ramp

Why?
Because that way I can focus dev efforts on the functional value add and more easily update authorization logic without having to do a full redeploy. Traceability, non repudiation and easy contextualization when digging through the opentelemetry data to pinpoint issues.

How?
one Nix flake that defines a standard QEMU VM to program against with:
- alloy collector for opentelemetry data
- grafana, prometheus, tempo and loki
- Spire server => the SPIRE agents use the input addressed store path to attest the app initially so it can log into the IDP (with one stop at the openbao instance)
- Zitadel (app machine user, user management)
- secret manager + secret management abstraction lib built to allow rotations without app reboots
- OPA server for managing in-app authorization
- biscuit tokens for managing in-app high-granularity privileges


Output:
- apps that are deterministically built
- easy to deploy on the substrate of the client's choosing (docker containers are just a one line flake output away)
- easy to integrate while remaining compliant with frameworks like ISO27001 => BYOK is built in, so is policy customization
- easy IR playbook integration => all secrets are in one place, so are accesses

And of course it's very fun to play with and run fire drills against!
