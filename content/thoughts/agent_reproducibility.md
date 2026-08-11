+++
title = "(Somewhat) Reproducible agent sessions: is the forest a sum of trees?"
date = 2026-08-11
description = "Maximizing traceability in agent sessions: an initial ontology and attempts at a metaphor"
+++




Let's continue our trek through agentic devsecops practices. Last week we discussed the agentic playground and the access control it brought as a substrate for leveraging partially trusted users: LLMs. Today we'll dive into the nuts and bolts. 


First, let's bound the solution space properly with some requirements, the final setup must be:


- Provider agnostic => I might be using Claude today, but my next engagement only has locally run LLMs for compliance reasons. The infrastructure is portable but keep in mind that switching model will change things dramatically.
- Fully traceable => When a human sends me a PR that breaks the WTF-per-minute meter I can reach out to them so they can explain their reasoning. When a LLM sends me a PR I should be able to git blame my way to the commit, extract the spanId then lookup the exact prompt and internal reasoning (if available) that led to each line in the diff.
- As deterministic as possible => LLMs are stochastic, their environment isn't: AGENTS.md, skills all of those are text files that can be hashed, diffed and tracked (see the previous post for a refresher on whole-world cryptographic attestation). A while back, when talking about SBOMs and SPIFFE I explained how I get provenance for code. Here the same principle applies to a different artifact, the agent's harness.


But what about prompts? Agentic development has an enormously protean character in that it blends flow of thought and conversation with engineering. For that I developed a dedicated ontology.


Agentic sessions are forests we walk through without being able to walk back.




- to grow a forest needs rich soil: a substrate that is not too thin (so not bounded by the context window) and rich enough to allow growth (how stretchy can this metaphor be?)
- each user turn is its own tree: a user turn (sending a message) leads to "thoughts" on the part of the LLM (branches) that terminate into actions (tool uses, the leaves)
- the path is one way => clearing and compaction (the bounded context) mean we can't reproduce the exact same outputs with the same inputs.


next, one way to walk all that talk

