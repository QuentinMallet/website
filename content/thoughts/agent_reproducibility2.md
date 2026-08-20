+++
title = (Somewhat) Reproducible agent sessions: branch, KB, and spans
date = 2026-08-17
description = "knowledge bases, orphan branches and keeping things tidy and traceable"
+++



so, last week I was metaphorizing with forests, trees and agentic workflow reproducibility.

Being bounded by a context window means being limited in our learning. Every interaction that produces data retained in the context reduces the runway before the next compaction. Every compaction loses details.

now, a possible implementation I standardized across several projects:

- one dedicated agentic branch per git repo. This is an orphan branch, it is only used by the agent as a versioned workspace. Checklists, worktrees, everything go in there => no agent scaffolding in the actual code
- one self-developed agentic knowledge base (see [here](https://github.com/QuentinMallet/agentic-kb), heavily inspired by the excellent [beads rust](https://github.com/Dicklesworthstone/beads_rust) project) that gets updated before each compaction/clear event with findings, knowledge about the project and is indexed as well as semantically searchable through a stdio MCP server.

Each entry in the KB is either permanent or tied to a code state with hash-enforced citations (this knowledge bit was verified at bytes XXX-YYY of file ZZZ at $HEAD, checked by hash when retrieving an entry from the kb). Permanent entries cover universal things, preferences for property-based testing frameworks, skills I don't use often, project-specific conventions. 

User turns themselves are tracked as well in some settings using separate tooling. When I use a local agent to assist me during an engagement I need complete visibility into its actions. The concept of spanIds from opentelemetry felt like the right tool for this.
Direct actions following a user turn get logged with a span ID under the parent turn's trace, making it traceable. Implementation was through an MCP and action delegation: no ability to interact directly (sandboxed in a microvm with a read-only copy of the source code), instead use that mcp to forward action requests with context and have the mcp use an otel pipeline to correlate tool calls with conversations and turns.

All of this introduces next week's post: the pre prompt process. How to create the right context efficiently and economically.
