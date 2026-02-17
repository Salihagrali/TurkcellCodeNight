class LeaderboardUser {
  final String userId;
  final String name;
  final int totalPoints;
  final int rank;
  final String? city;
  final String? segment;
  final String? avatarUrl;

  LeaderboardUser({
    required this.userId,
    required this.name,
    required this.totalPoints,
    required this.rank,
    this.city,
    this.segment,
    this.avatarUrl,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'İsimsiz',
      totalPoints: json['totalPoints'] ?? 0,
      rank: json['rank'] ?? 0,
      city: json['city'],
      segment: json['segment'],
      avatarUrl: json['avatarUrl'] ?? json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'totalPoints': totalPoints,
      'rank': rank,
      'city': city,
      'segment': segment,
      'avatarUrl': avatarUrl,
    };
  }

  // ============================================
  // HELPER GETTERS
  // ============================================

  // Get medal emoji based on rank
  String get medalEmoji {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  // Check if user is in top 3
  bool get isTopThree => rank <= 3;

  // Check if user is in top 10
  bool get isTopTen => rank <= 10;

  // Check if user is premium
  bool get isPremium => segment?.toLowerCase() == 'premium';

  // Get rank color
  String get rankColor {
    if (rank == 1) return '#FFD700'; // Gold
    if (rank == 2) return '#C0C0C0'; // Silver
    if (rank == 3) return '#CD7F32'; // Bronze
    return '#0038A8'; // Default blue
  }

  // Get rank text (for display)
  String get rankText {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }

  // Get formatted points (e.g., "1.2K" for 1200)
  String get formattedPoints {
    if (totalPoints >= 1000000) {
      return '${(totalPoints / 1000000).toStringAsFixed(1)}M';
    } else if (totalPoints >= 1000) {
      return '${(totalPoints / 1000).toStringAsFixed(1)}K';
    }
    return totalPoints.toString();
  }

  // Get user initials (for avatar placeholder)
  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  // Get display name (shortened if too long)
  String get displayName {
    if (name.length > 20) {
      return '${name.substring(0, 17)}...';
    }
    return name;
  }

  // Get city display (with fallback)
  String get cityDisplay => city ?? 'Bilinmiyor';

  // Get segment display (with fallback)
  String get segmentDisplay => segment ?? 'Standart';

  // Check if user has avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  // Get rank badge text (just the number or 99+ for high ranks)
  String get rankBadgeText => rank <= 99 ? rank.toString() : '99+';

  // Check if this is a new user (low points)
  bool get isNewUser => totalPoints < 100;

  // Get progress to next rank (assuming 100 points per rank improvement)
  double get progressToNextRank {
    // This is a simplified example - adjust based on your actual ranking system
    final pointsForCurrentRank = (rank - 1) * 100;
    final pointsForNextRank = rank * 100;
    final progress = (totalPoints - pointsForCurrentRank) / (pointsForNextRank - pointsForCurrentRank);
    return progress.clamp(0.0, 1.0);
  }

  // Get achievement level
  String get achievementLevel {
    if (totalPoints >= 10000) return 'Efsane';
    if (totalPoints >= 5000) return 'Uzman';
    if (totalPoints >= 2000) return 'İleri';
    if (totalPoints >= 1000) return 'Orta';
    if (totalPoints >= 500) return 'Başlangıç';
    return 'Yeni';
  }

  // Get achievement emoji
  String get achievementEmoji {
    if (totalPoints >= 10000) return '👑';
    if (totalPoints >= 5000) return '💎';
    if (totalPoints >= 2000) return '⭐';
    if (totalPoints >= 1000) return '🌟';
    if (totalPoints >= 500) return '✨';
    return '🆕';
  }
}