# Scenario allocation summary

Rework the scenario allocation summary.

Show the ongoing total, the allocated percentage, the number of causes, a segmented progress bar, per-cause color
indicators, and an annual perpetuity estimate. Add a one-time `ADD-ON` section showing each gift's percentage of the
one-time total.

Implement the required model calculations and focused tests. Preserve existing allocation behavior and the existing
Rails application conventions.

## Acceptance criteria

- Ongoing allocations expose the annual perpetuity amount using the application's stated payout rate.
- One-time allocations expose their percentage of the one-time total.
- The summary presents ongoing and one-time allocations separately and remains correct for empty or zero totals.
- Existing allocation and scenario tests continue to pass.
