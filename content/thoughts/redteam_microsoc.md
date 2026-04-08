+++
title = "Red Team Microsocs"
date = 2026-04-07
description = "Red teams need observability too, leaving it out means leaving value on the table"
+++

> Every happy red team is the same, every unhappy red team is unhappy in its own way
(Leo Tolstoy, probably)

A happy red team doesn't need much:
- resilient infrastructure that withstands blocklisting and takedowns
- automated processes: spinning up a new redirector for the next phishing campaign shouldn't take any human bandwidth
- expertise: we only have to get it right once to win, but finding the right chink in the armor is the first step. Prying it open is what takes resources, experience, ingenuity and some luck.

All of that generates data, most of that data is discarded. What isn't ends up in the report package the customer gets. Everything else? tribal knowledge, which walks away when a member leaves.

To avoid that, I like the micro-SOC approach: use blue team observability techniques (opentelemetry aggregators, logs and metrics collections around all your red team automation), so you can actually leverage it post-engagement.

Even if the initial leverage is just feeding a RAG pipeline to help with writing reports, that's time saved that can be used on the engagement itself.


And having a red team stack that could get ISO27001 certified as a standalone perimeter is pretty rad too!
(you still have to write out your processes and policies though)
