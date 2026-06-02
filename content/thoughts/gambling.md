+++
title = "gambling"
date = 2026-06-02
description = "risk management is a discipline built around probabilities, so is gambling. Why not reuse some tools?"
+++

> "Yeah, well, I'm gonna go build my own security program. With blackjack and audits!" 
(Bender, Futurama)

Today I'd like to talk about a mental model I find interesting when dealing with risk-based policy making.

Today we're gonna talk about gambling.

We're all gambling. Some gamble as a governance tool (Robin Hanson has interesting things to say about it), most gamble because it is mandatory! Car insurance is gambling. You bet your monthly premium that you will have an accident creating a payout greater than the accumulated premiums. The insurer bets that you won't before he's turned a profit from those repeated bets.

Sounds familiar? that's how to approach risk based security. The business tells you the size of the bet (how many customers will churn if X happens? how much are we going to lose?) and you are the bookie quoting the odds.

Our job is dual: on the one end we quote initial odds, take actions to modify them then let the business decide whether the updated odds (residual risk) is acceptable.

If we think about it as gambling, suddenly some gambler tools become immediately useful:

- Expected Value: the average outcome of a single bet. Take it once, what do you expect to walk away with?
- the Kelly Criterion: given odds and a bankroll you bet repeatedly, what fraction should you stake each time to maximize long-run growth without going broke?

Quick example:

- a coin that you know has 60% chances of coming up heads when thrown, if you guess correctly which way it will come up you win your stake (even money bet)

if you bet all your money on heads every throw you will end up broke even though the EV is positive. Kelly tells you to bet your edge: 0.6 - 0.4 = 20% of your bankroll per throw.

How do you use that?

- Expected value: that's the easy one. if the expected loss exceeds the cost of preventing it, prevent. Otherwise, accept.. Sometimes a risk can be +EV to accept but ethically  unacceptable. An example would be a financial misconduct that is hard to prove and very rarely prosecuted yet profitable. 
- Kelly Criterion: replace the coin with estimated probabilities of success for your risk mitigation endeavors or other budget commitments

 That's a well known problem: Kelly criterion on simultaneous bets (used in trading and portfolio management). This gives you a transparent, falsifiable reasoning structure when the board asks why you spent X on Y instead of Z.

This is one lense through which you can see risk mitigation but also opportunities for better efficiency. Integrating a new tool isn't free: you pay in licenses and ramp time whether or not it works. The bet is that you get more back in recovered capacity than you staked. Same structure: stake, odds, payoff.
