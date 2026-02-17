class AwardModel {
  final String? awardId;
  final String? challengeName;
  final String? awardType;
  final int? pointsAwarded;
  final DateTime? completedAt;
  final String? description;

  AwardModel({
    this.awardId,
    this.challengeName,
    this.awardType,
    this.pointsAwarded,
    this.completedAt,
    this.description,
  });

  factory AwardModel.fromJson(Map<String, dynamic> json) {
    return AwardModel(
      awardId: json['awardId'] ?? json['id'],
      challengeName: json['challengeName'] ?? json['name'] ?? json['title'],
      awardType: json['awardType'] ?? json['type'],
      pointsAwarded: json['pointsAwarded'] ?? json['points'] ?? json['rewardPoints'],
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt'])
          : json['awardedAt'] != null
              ? DateTime.tryParse(json['awardedAt'])
              : null,
      description: json['description'] ?? json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'awardId': awardId,
      'challengeName': challengeName,
      'awardType': awardType,
      'pointsAwarded': pointsAwarded,
      'completedAt': completedAt?.toIso8601String(),
      'description': description,
    };
  }

  // Helper to get emoji based on challenge type
  String get emoji {
    if (challengeName == null) return '🎯';
    final name = challengeName!.toLowerCase();
    if (name.contains('günlük') || name.contains('daily')) return '📅';
    if (name.contains('haftalık') || name.contains('weekly')) return '📆';
    if (name.contains('maraton') || name.contains('marathon')) return '🏃';
    if (name.contains('keşif') || name.contains('explorer')) return '🔍';
    if (name.contains('seri') || name.contains('streak')) return '🔥';
    if (name.contains('parti') || name.contains('party')) return '🎉';
    return '🎯';
  }
}