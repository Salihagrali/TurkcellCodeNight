class UserStateModel {
  final String userId;
  final String name;
  int totalPoints;
  int watchMinutesToday; 
  final int watchMinutes7d;
  final int watchStreakDays;

  UserStateModel({
    required this.userId,
    required this.name,
    required this.totalPoints,
    required this.watchMinutesToday,
    required this.watchMinutes7d,
    required this.watchStreakDays,
  });
}