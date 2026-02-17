import 'award_model.dart';
import 'notification_model.dart';

class DashboardResponse {
  final List<BadgeModel> badges;
  final List<AwardModel> challengeHistory; 
  final List<NotificationModel> notifications;
  final UserStateData state;
  final UserInfo user;

  DashboardResponse({
    required this.badges,
    required this.challengeHistory,
    required this.notifications,
    required this.state,
    required this.user,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      badges: (json['badges'] as List?)
          ?.map((i) => BadgeModel.fromJson(i))
          .toList() ?? [],
      challengeHistory: (json['challengeHistory'] as List?)
          ?.map((i) => AwardModel.fromJson(i))
          .toList() ?? [],
      notifications: (json['notifications'] as List?)
          ?.map((i) => NotificationModel.fromJson(i))
          .toList() ?? [],
      state: UserStateData.fromJson(json['state'] ?? {}),
      user: UserInfo.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badges': badges.map((b) => b.toJson()).toList(),
      'challengeHistory': challengeHistory.map((c) => c.toJson()).toList(),
      'notifications': notifications.map((n) => n.toJson()).toList(),
      'state': state.toJson(),
      'user': user.toJson(),
    };
  }

  // ============================================
  // DASHBOARD-LEVEL HELPER GETTERS
  // ============================================

  // Get total badge count
  int get badgeCount => badges.length;

  // Get unread notification count
  int get unreadNotificationCount {
    return notifications.where((n) => n.isRead == false).length;
  }

  // Get recent notifications (last 5)
  List<NotificationModel> get recentNotifications {
    return notifications.take(5).toList();
  }

  // Check if user has any badges
  bool get hasBadges => badges.isNotEmpty;

  // Check if user has completed challenges
  bool get hasChallengeHistory => challengeHistory.isNotEmpty;

  // Check if user has notifications
  bool get hasNotifications => notifications.isNotEmpty;

  // Get latest badge
  BadgeModel? get latestBadge => badges.isNotEmpty ? badges.first : null;

  // Get highest level badge
  BadgeModel? get highestLevelBadge {
    if (badges.isEmpty) return null;
    return badges.reduce((a, b) => 
      (a.level ?? 0) > (b.level ?? 0) ? a : b
    );
  }

  // Get genre badges
  List<BadgeModel> get genreBadges {
    return badges.where((b) => b.isGenreBadge).toList();
  }

  // Get tier badges
  List<BadgeModel> get tierBadges {
    return badges.where((b) => b.isTierBadge).toList();
  }

  // Get dashboard summary text
  String get dashboardSummary {
    return '${badgeCount} rozet, ${state.watchStreakDays} gün seri';
  }

  // Check if user is active today
  bool get isActiveToday => state.hasWatchedToday;

  // Get overall activity score (0-100)
  int get activityScore {
    int score = 0;
    
    // Badges (max 30 points)
    score += (badgeCount * 3).clamp(0, 30);
    
    // Watch streak (max 25 points)
    score += (state.watchStreakDays).clamp(0, 25);
    
    // State engagement (max 25 points)
    score += (state.engagementScore / 4).round();
    
    // Total points (max 20 points)
    score += (user.totalPoints ~/ 100).clamp(0, 20);
    
    return score.clamp(0, 100);
  }

  // Get activity level
  String get activityLevel {
    final score = activityScore;
    if (score >= 80) return 'Muhteşem!';
    if (score >= 60) return 'Harika!';
    if (score >= 40) return 'İyi!';
    if (score >= 20) return 'Normal';
    return 'Yeni başlıyor';
  }
}

class BadgeModel {
  final String badgeName;
  final String? badgeId;
  final String? conditionRule;
  final int? level;
  final String? badgeEmoji;

  BadgeModel({
    required this.badgeName,
    this.badgeId,
    this.conditionRule,
    this.level,
    this.badgeEmoji,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    final badgeData = json['badge'] ?? json;
    
    return BadgeModel(
      badgeName: badgeData['badgeName'] ?? 'Rozet',
      badgeId: badgeData['badgeId'],
      conditionRule: badgeData['conditionRule'],
      level: badgeData['level'],
      badgeEmoji: _getBadgeEmoji(badgeData['badgeName'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badgeName': badgeName,
      'badgeId': badgeId,
      'conditionRule': conditionRule,
      'level': level,
    };
  }

  static String _getBadgeEmoji(String badgeName) {
    final name = badgeName.toLowerCase();
    if (name.contains('bronz')) return '🥉';
    if (name.contains('gümüş') || name.contains('silver')) return '🥈';
    if (name.contains('altın') || name.contains('gold')) return '🥇';
    if (name.contains('komedi')) return '😂';
    if (name.contains('dram')) return '🎭';
    if (name.contains('aksiyon')) return '💥';
    if (name.contains('korku')) return '😱';
    if (name.contains('bilim')) return '🚀';
    if (name.contains('aşk') || name.contains('romantik')) return '❤️';
    return '🏆';
  }

  // Getters
  String get emoji => badgeEmoji ?? '🏆';
  String get displayName => badgeName.length > 20 ? '${badgeName.substring(0, 17)}...' : badgeName;
  String get levelDisplay => level != null ? 'Seviye $level' : '';
  bool get hasLevel => level != null;
  
  String get rarity {
    if (level == null) return 'Ortak';
    if (level! >= 5) return 'Efsanevi';
    if (level! >= 3) return 'Nadir';
    if (level! >= 2) return 'Seyrek';
    return 'Ortak';
  }
  
  String get rarityColor {
    switch (rarity) {
      case 'Efsanevi': return '#FF6B35';
      case 'Nadir': return '#6B35FF';
      case 'Seyrek': return '#3596FF';
      default: return '#808080';
    }
  }
  
  String get badgeType {
    final name = badgeName.toLowerCase();
    if (name.contains('izleyici')) return 'İzleyici';
    if (name.contains('sever')) return 'Tür';
    if (name.contains('maraton')) return 'Maraton';
    if (name.contains('keşif')) return 'Keşifçi';
    if (name.contains('seri')) return 'Seri';
    if (name.contains('sosyal')) return 'Sosyal';
    if (name.contains('uzman')) return 'Uzman';
    return 'Genel';
  }
  
  bool get isTierBadge {
    final name = badgeName.toLowerCase();
    return name.contains('bronz') || name.contains('gümüş') || 
           name.contains('silver') || name.contains('altın') || name.contains('gold');
  }
  
  bool get isGenreBadge => badgeName.toLowerCase().contains('sever');
  
  int get tier {
    final name = badgeName.toLowerCase();
    if (name.contains('altın') || name.contains('gold')) return 3;
    if (name.contains('gümüş') || name.contains('silver')) return 2;
    if (name.contains('bronz') || name.contains('bronze')) return 1;
    return 0;
  }
  
  String get fullDisplayText => hasLevel ? '$badgeName - Seviye $level' : badgeName;
}

class UserStateData {
  final int watchMinutesToday;
  final int watchStreakDays;
  final int? episodesCompletedToday;
  final int? uniqueGenresToday;
  final int? watchPartyMinutesToday;
  final int? ratingsToday;
  final int? watchMinutes7d;
  final int? episodesCompleted7d;
  final int? ratings7d;

  UserStateData({
    required this.watchMinutesToday,
    required this.watchStreakDays,
    this.episodesCompletedToday,
    this.uniqueGenresToday,
    this.watchPartyMinutesToday,
    this.ratingsToday,
    this.watchMinutes7d,
    this.episodesCompleted7d,
    this.ratings7d,
  });

  factory UserStateData.fromJson(Map<String, dynamic> json) {
    return UserStateData(
      watchMinutesToday: json['watchMinutesToday'] ?? 0,
      watchStreakDays: json['watchStreakDays'] ?? 0,
      episodesCompletedToday: json['episodesCompletedToday'],
      uniqueGenresToday: json['uniqueGenresToday'],
      watchPartyMinutesToday: json['watchPartyMinutesToday'],
      ratingsToday: json['ratingsToday'],
      watchMinutes7d: json['watchMinutes7d'],
      episodesCompleted7d: json['episodesCompleted7d'],
      ratings7d: json['ratings7d'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watchMinutesToday': watchMinutesToday,
      'watchStreakDays': watchStreakDays,
      'episodesCompletedToday': episodesCompletedToday,
      'uniqueGenresToday': uniqueGenresToday,
      'watchPartyMinutesToday': watchPartyMinutesToday,
      'ratingsToday': ratingsToday,
      'watchMinutes7d': watchMinutes7d,
      'episodesCompleted7d': episodesCompleted7d,
      'ratings7d': ratings7d,
    };
  }

  // Getters
  String get formattedWatchTimeToday {
    if (watchMinutesToday == 0) return '0 dk';
    final hours = watchMinutesToday ~/ 60;
    final minutes = watchMinutesToday % 60;
    if (hours > 0 && minutes > 0) return '${hours}s ${minutes}dk';
    if (hours > 0) return '${hours}s';
    return '${minutes}dk';
  }
  
  String get formattedWatchTime7d {
    final minutes = watchMinutes7d ?? 0;
    if (minutes == 0) return '0 dk';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) return '${hours}s ${mins}dk';
    if (hours > 0) return '${hours}s';
    return '${mins}dk';
  }
  
  bool get hasWatchedToday => watchMinutesToday > 0;
  bool get hasActiveStreak => watchStreakDays > 0;
  
  String get streakEmoji {
    if (watchStreakDays >= 30) return '🔥🔥🔥';
    if (watchStreakDays >= 14) return '🔥🔥';
    if (watchStreakDays >= 7) return '🔥';
    if (watchStreakDays > 0) return '⚡';
    return '💤';
  }
  
  String get streakStatus {
    if (watchStreakDays >= 30) return 'Muhteşem seri!';
    if (watchStreakDays >= 14) return 'Harika gidiyorsun!';
    if (watchStreakDays >= 7) return 'İyi bir seri!';
    if (watchStreakDays > 0) return 'Seride!';
    return 'Seri başlat!';
  }
  
  bool get hasCompletedEpisodesToday => (episodesCompletedToday ?? 0) > 0;
  
  double get averageWatchTimePerDay {
    if (watchMinutes7d == null || watchMinutes7d == 0) return 0;
    return watchMinutes7d! / 7;
  }
  
  bool get isDailyWatcher => averageWatchTimePerDay >= 30;
  bool get exploredGenresToday => (uniqueGenresToday ?? 0) > 1;
  bool get joinedWatchPartyToday => (watchPartyMinutesToday ?? 0) > 0;
  bool get ratedContentToday => (ratingsToday ?? 0) > 0;
  
  int get engagementScore {
    int score = 0;
    score += (watchMinutesToday ~/ 10).clamp(0, 30);
    score += ((episodesCompletedToday ?? 0) * 5).clamp(0, 20);
    score += ((uniqueGenresToday ?? 0) * 5).clamp(0, 15);
    if (watchPartyMinutesToday != null && watchPartyMinutesToday! > 0) score += 15;
    score += ((ratingsToday ?? 0) * 5).clamp(0, 10);
    score += (watchStreakDays ~/ 3).clamp(0, 10);
    return score.clamp(0, 100);
  }
  
  String get engagementLevel {
    final score = engagementScore;
    if (score >= 80) return 'Süper aktif!';
    if (score >= 60) return 'Çok aktif';
    if (score >= 40) return 'Aktif';
    if (score >= 20) return 'Orta';
    return 'Düşük';
  }
  
  bool get achievedDailyGoal => watchMinutesToday >= 30;
  double get dailyGoalProgress => (watchMinutesToday / 60).clamp(0.0, 1.0);
}

class UserInfo {
  final String userId;
  final String name;
  final int totalPoints;
  final String? city;
  final String? segment;

  UserInfo({
    required this.userId,
    required this.name,
    required this.totalPoints,
    this.city,
    this.segment,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      city: json['city'],
      segment: json['segment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'totalPoints': totalPoints,
      'city': city,
      'segment': segment,
    };
  }

  // Getters
  String get formattedPoints {
    if (totalPoints >= 1000000) return '${(totalPoints / 1000000).toStringAsFixed(1)}M';
    if (totalPoints >= 1000) return '${(totalPoints / 1000).toStringAsFixed(1)}K';
    return totalPoints.toString();
  }
  
  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
  
  String get displayName => name.length > 25 ? '${name.substring(0, 22)}...' : name;
  String get firstName => name.split(' ').first;
  bool get isPremium => segment?.toLowerCase() == 'premium';
  bool get isStandard => segment?.toLowerCase() == 'standart' || segment?.toLowerCase() == 'standard';
  String get segmentDisplay => segment ?? 'Standart';
  String get segmentEmoji => isPremium ? '👑' : '👤';
  String get cityDisplay => city ?? 'Belirtilmemiş';
  bool get hasCityInfo => city != null && city!.isNotEmpty;
  
  int get pointsToNextMilestone {
    final nextMilestone = ((totalPoints ~/ 1000) + 1) * 1000;
    return nextMilestone - totalPoints;
  }
  
  int get level => (totalPoints ~/ 1000) + 1;
  
  String get levelName {
    if (totalPoints >= 10000) return 'Efsane';
    if (totalPoints >= 5000) return 'Uzman';
    if (totalPoints >= 2000) return 'İleri';
    if (totalPoints >= 1000) return 'Orta';
    if (totalPoints >= 500) return 'Başlangıç';
    return 'Yeni Başlayan';
  }
  
  String get levelEmoji {
    if (totalPoints >= 10000) return '👑';
    if (totalPoints >= 5000) return '💎';
    if (totalPoints >= 2000) return '⭐';
    if (totalPoints >= 1000) return '🌟';
    if (totalPoints >= 500) return '✨';
    return '🆕';
  }
  
  double get progressToNextLevel {
    final currentLevelPoints = (level - 1) * 1000;
    final nextLevelPoints = level * 1000;
    final progress = (totalPoints - currentLevelPoints) / (nextLevelPoints - currentLevelPoints);
    return progress.clamp(0.0, 1.0);
  }
  
  bool get isNewUser => totalPoints < 100;
  bool get isActiveUser => totalPoints >= 500;
  bool get isPowerUser => totalPoints >= 5000;
  
  String get greeting {
    if (totalPoints >= 10000) return 'Merhaba Efsane $firstName!';
    if (totalPoints >= 5000) return 'Hoş geldin Uzman $firstName!';
    if (totalPoints >= 2000) return 'Selam $firstName!';
    if (totalPoints >= 500) return 'Hey $firstName!';
    return 'Merhaba $firstName!';
  }
}