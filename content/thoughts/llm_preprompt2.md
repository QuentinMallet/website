+++
title = "LLM prompting groundwork: 2"
date = 2026-09-01
description = "everything else that wasn't covered last week"
+++

Last week I enumerated what "make no mistakes" actually encodes: a formal spec, an architectural baseline, a TDD seed, a bughunting protocol and a pile of per-language preferences. All of it real, none of it fitting in a context window.

Especially not with a bunch of footguns laying around.

eg: My main host is named pi for emotional reasons, it's the fourth generation of a server that started life on a Raspberry Pi running rancherOS and now runs in a bigger form factor with 32GB of RAM and handles my personal CI/CD.

That's the kind of gotcha that has to live somewhere the agent can find it.

Two weeks ago I talked about the agentic-kb tool I built for this, along with the harness, skills and hooks that are versioned and can be tied cryptographically to any output (thanks to the NixOS substrate).

So here's how it's all put together:

- Nix overlays on official oh-my-claudecode, oh-my-openagent and anthropic skills to have them use the KB for semantic search before going through complete code-files, and have them update the kb on cache-misses
- Hooks to inject traceability through hierarchical span trees
- Opentelemetry pipeline and archiving
- a KB seeded with my universal practices, language-specific preferences for libraries, coding styles, tdd practices
- checklists versioned in the agentic orphan branch to ensure all gates are passed and they are not just "forgotten" by a lazy agent
- I review code and send it prod-bound by merging it

This means that I have a big skills library (70+ at the time of writing, with some project-specific ones), but most of it is never loaded at the same time: I have about 10 hot skills I use very often, all the others are caught by a small router skill that pulls them on-demand from the knowledge-base, saving time and tokens (caveat: if the project is small then it is very likely that going through the whole thing will result in a net loss). Although this changed since the time of writing as the hot/cold distinction has been made moot by most of the harnesses I use.

And sometimes, all those cold skills, a knowledge base and an issue tracker aren't enough. Sometimes the holes in the swiss cheese line up. Luckily those same layers also provide me with a toolbox that turn "It broke. Fix plz" into actual systems engineering.

