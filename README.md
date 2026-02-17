#  Turkcell TV+ Gamification Engine (Watch & Win)

A robust, event-driven gamification backend built specifically for the **Turkcell TV+ Watch & Win Tournament** case study. This system tracks user watch activities, calculates dynamic metrics (daily, 7-day, and streaks), evaluates rule-based challenges, resolves reward conflicts, and awards points and badges through a highly secure, immutable ledger system.

##  Key Features

* **Dynamic State Calculation:** Automatically tracks and calculates **Today**, **7-Day**, and **Streak** metrics in real-time based on incoming user watch events.
* **Challenge Rules Engine:** Dynamically evaluates text-based string conditions (e.g., `watch_minutes_today >= 60`) directly against the user's current state.
* **Conflict Resolution (Tek Ödül Kuralı):** When a user triggers multiple challenges simultaneously, the engine applies a strict Priority Rule (where the lowest priority number wins). It successfully rewards the winner while logging the remaining challenges as `suppressed`.
* **Immutable Points Ledger:** All point additions and deductions are recorded in a financial-style ledger, ensuring 100% traceability and auditability for the leaderboard's total scores.
* **Automated Badge System:** Users are seamlessly and automatically awarded tiered badges (Bronz, Gümüş, Altın, Efsane) the moment their cumulative points cross defined leveling thresholds.

##  System Architecture Notes

* **Priority Rule Implementation:** Core conflict resolution is handled seamlessly within the `ChallengeEvaluatorService`. Triggered challenges are grouped into a `List`, sorted in ascending order via `Comparator.comparingInt(Challenge::getPriority)`, and the index `[0]` is selected as the sole winner.
* **Data Consistency:** The `PointsLedger` entity strictly utilizes Hibernate's `@CreationTimestamp` and `@Column(updatable = false)` annotations. This guarantees financial-level audit compliance, preventing any historical gamification points from being accidentally or maliciously overwritten.
* **Time Travel Testing:** The API architecture is designed to allow the passing of explicit `LocalDate` parameters directly through the DTOs. This enables rapid simulation and reliable testing of rolling 7-day windows and multi-day streaks without needing to wait actual calendar days.
