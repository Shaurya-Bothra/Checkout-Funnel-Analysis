# Experiment Proposals: Improving Checkout for New Users

## Context
New users convert at 0.43% vs 1.75% for returning users (site average 0.79%).
Among new users who begin checkout, only 48.4% add payment info (returning users: 83.4%).
If new users converted at the site average, that would be worth roughly 313 extra orders per month
(an upper-end estimate from a holiday-heavy period).

## Power analysis (shared by both proposals)
- Baseline: 48.4% checkout to add payment info (new users)
- Minimum detectable effect: 10% relative lift (48.4% to 53.2%)
- Alpha 0.05 (two-sided), power 0.80
- Sample size: 837 sessions per group (1,674 total)
- New-user sessions reaching checkout: 3,183 over 13 weeks (about 245 per week)
- Duration: about 7 weeks with a 50/50 split

## Proposal 1: Guest checkout
- **Hypothesis:** If new users can check out as guests without creating an account, then checkout to add-payment conversion will increase, because account creation adds friction at the step where new users drop out.
- **Primary metric:** checkout to add_payment_info rate
- **Guardrail metrics:** average order value, overall session conversion, payment errors and refunds
- **Target users:** new users who begin checkout
- **Sample size:** 837 per group
- **Duration:** about 7 weeks at current traffic
- **Decision rule:** ship if the primary metric improves significantly and no guardrail worsens

## Proposal 2: Trust signals at the payment step
- **Hypothesis:** If new users see security and reassurance cues at the payment step (security badge, accepted payment-method logos, a short returns and refund note), then checkout to add-payment conversion will increase, because new users have no prior experience with the store, while returning users (83.4% reach payment vs 48.4% for new users) already trust it.
- **Change:** Add a security badge, accepted-payment logos, and a one-line returns policy beside the payment fields. No other change to the form.
- **Primary metric:** checkout to add_payment_info rate
- **Guardrail metrics:** average order value, overall session conversion, payment page load time (extra elements could slow the page)
- **Target users:** new users who begin checkout
- **Sample size:** 837 per group
- **Duration:** about 7 weeks at current traffic
- **Decision rule:** ship if the primary metric improves significantly and no guardrail worsens
- **Interaction note:** run this after Proposal 1, or on a separate user split, so the two changes don't overlap and blur each other's effect

## Limitations
- Data covers a holiday-heavy period (Nov 2020 to Jan 2021)
- The 313 orders per month figure assumes new users can reach the site average, which is optimistic
- Returning users are a self-selected group, so the gap may not be fully closable
- The data shows where new users leave, not why, so both proposals are hypotheses to be tested