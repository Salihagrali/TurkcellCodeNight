class UserStateModel {
  final String userId;
  final String name;
  final String city;    // Yeni alan
  final String segment; // Yeni alan
  int totalPoints;
  int watchMinutesToday;
  int watchMinutes7d;
  int watchStreakDays;

  UserStateModel({
    required this.userId,
    required this.name,
    required this.city,
    required this.segment,
    required this.totalPoints,
    this.watchMinutesToday = 0, // Java'dan gelmediği için varsayılan 0
    this.watchMinutes7d = 0,
    this.watchStreakDays = 0,
  });

  factory UserStateModel.fromJson(Map<String, dynamic> json) {
    return UserStateModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'İsimsiz',
      city: json['city'] ?? '',
      segment: json['segment'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      // Diğer alanlar henüz API'da yoksa varsayılan 0 kalır
    );
  }
}