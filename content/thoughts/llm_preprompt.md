+++
title = "LLM prompting groundwork"
date = 2026-08-25
description = "what happens before I start prompting"
+++

Last week I described the reproducibility substrate. Today, what fills it: prompting. Since the first day of LLM GA a lot of virtual ink has been spilt over this. So much that it's now part of the memescape ("Make me rich, make no mistakes").

While working on the devsecops aspects of AI-assisted development and systems administration, I used one of the most useful things formal specs taught me: assumption enumerations.

A prompt encodes intent (I wrote about this in the TLA-spec as context post a while back), but any dev knows that being onboarded in a project is a lot of "that's how we do things here, no one wrote it down but you should follow it"

For clarity's sake, when I code manually here's the most involved version of my process (so for the more gnarly problems, not for writing a quick firefox extension to help find games on colonist.io):

- Think about what I am working on => write a TLA+ formal spec
- Think up an architecture for implementing it => usually the tla+ formal spec gave me the blueprint for the form that is the least dangerous to build and handle. The four externalizations from the playground post (AuthN, AuthZ, secrets, correlated telemetry) are the architectural baseline. The agent inherits them, even a Dex sidecar suffices for AuthN.
- TDD: it's way easier when you have a test "seed". The TLA spec gives me that, I have an easy happy-path testsuite already pre-written and a bunch of invariants I can compose with it. Furthermore property-based testing frameworks like proptest in rust make it easier and faster to create tests from a TLA spec

This means that when things break:

- make the bug reproducible, first end to end then down at the lowest possible test suite level (best case is reproducibility with a single unit test) => that way I can understand it fully
- git bisect to identify precisely when and where it appeared (git bisect + test script was in the superpower realm even before LLMs became a thing)
- update the test suite with a formally identified regression ID based on the commit that introduced it (if it appears again I already have somewhere to start searching for clues) => proptest gives you easy ways to version in specific cases so you are sure they always run
- check the TLA spec: was the bug outside of the conceptual space covered? => add new invariants or temporal rules, refine and update the spec until TLC stops slapping me

On top of that there are per-language specifics and preferences: eg avoid using NIFS when doing Elixir work, write hot-loop code in Rust, use proptest or Streamdata for my property-based testing, wallaby when doing end to end browser tests...

So when I tell the LLM "make no mistakes", what I actually mean is all the previous.

Problem is, I can hardly fit it all into the context window. Next week: where all of that lives so the agent can find it.

