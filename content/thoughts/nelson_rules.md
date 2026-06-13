+++
title = "Nelson rules: applied Statistical Process Control"
date = 2026-06-09
description = "building knowledge and useful alerts from scratch (and telemetry)"
+++

> When you came, you said to me as follows: “I will give Gimil-Sin (when he comes) fine quality copper ingots.” You left then but you did not do what you promised me. You put ingots which were not good before my messenger (Sit-Sin) and said: “If you want to take them, take them; if you do not want to take them, go away!”
(Nanni, to Ea nasir following systemic QA failures)

The cybersecurity landscape is a high VUCA environment.

How do I deal with that in information systems?

- telemetry
- statistics

What about new systems you deploy?
What about existing systems you didn't know about?

Enter Statistical Process Control (SPC), from the world of quality assurance it comes very handy in cybersecurity because it gives us fuzzy, evolving tools that require less maintenance than absolute, hard alerting limits.

When setting up the initial alerting around a system I always keep the same core: the Nelson Rules. First a disclaimer: the following assumes that individual systems behave consistently over periods of time.

The Nelson rules are statistics-based alerting rules you can set up around your metrics so you can tell when the underlying asset has started behaving unpredictably. Their value proposition is clear: you will know something's off before it catches on fire.

They don't need much in terms of care and feeding:

- a time series
- ability to compute the mean
- ability to compute standard deviations

What they give you alerts on:

- outliers: if something is outside of your 99.7 window, you definitely want to know why
- bias: if suddenly something takes consistently more time (or less!) than it used to, there is something in your system environment that changed
- oscillations: too little of them (values clustered at 1 standard deviation of the means), or too large (everything falling within the 68 - 95 band) tell you there are changes in your pipeline you should account for

And the most important:

- trends:  upward or downward trends allow you to extract decision and action deadlines, exactly what you need to feed your program management processes.
