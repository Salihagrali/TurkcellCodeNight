 Turkcell TV+ Gamification Engine (Watch & Win)
A robust, event-driven gamification backend built for the Turkcell TV+ Watch & Win Tournament case study. This system tracks user watch activities, calculates dynamic metrics (daily, 7-day, and streaks), evaluates rule-based challenges, resolves reward conflicts, and awards points and badges through an immutable ledger system.

 Key Features
Dynamic State Calculation: Automatically tracks and calculates Today, 7-Day, and Streak metrics based on incoming watch events.

Challenge Rules Engine: Evaluates dynamic text-based conditions (e.g., watch_minutes_today >= 60) against the user's state.

Conflict Resolution (Tek Ödül Kuralı): When a user triggers multiple challenges simultaneously, the engine applies a Priority Rule (lowest priority number wins), rewards the winner, and logs the rest as suppressed.

Immutable Points Ledger: All point changes are recorded in a financial-style ledger, ensuring 100% traceability for total scores.

Automated Badge System: Users are automatically awarded tiered badges (Bronze, Silver, Gold, Legend) as their cumulative points cross defined thresholds.

System Architecture Notes:
Priority Rule Implementation: Handled in ChallengeEvaluatorService. Triggered challenges are collected into a List, sorted via Comparator.comparingInt(Challenge::getPriority), and the index [0] is selected as the winner.

Data Consistency: The PointsLedger entity utilizes @CreationTimestamp and @Column(updatable = false) to ensure financial-level audit compliance for gamification points.

Time Travel Testing: The architecture allows passing explicit LocalDate parameters through the DTOs, enabling the simulation and testing of 7-day windows and streaks without waiting actual days.