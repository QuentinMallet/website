+++
title = "Agent communication through formal specifications"
date = 2026-04-21
description = "using formal specs helps when keeping agents on track"
+++

> Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.
(St Exupery, for real)

Integrating coding agents in my development and professional practice took quite a bit of reflection.
Security oriented development is a peculiar beast. Thoroughness is a hard requirement and when you
use coding agents terseness is one of the best heuristics.

This brought me to a reflection around intent. How do I concisely and unambiguously communicate my intent for the system in a form a LLM can actually check its decisions against?
For that I turned to formal methods, TLA+ formal specifications to be precise.

What you get is a set of equations that doesn't take much space and describes unambiguously what you want your system to do, and you have
complete assurance that what you wrote is internally coherent at the level of abstraction you chose.

Even better: you can build refinements that describe in a more concrete way the inner workings of your system and can be checked against the higher level formal spec.

Next, when you start your coding agent you can tell it that every feature implementation should be checked against the spec and that the suite should verify the formal specification invariants and properties!

Terseness without ambiguity => money saved on tokens, mathematical clarity => money saved in time spent

Obviously it's on you to verify that the testing harness actually exercises your invariants and temporal requirements. HITL doesn't stand for "human at the beach"
