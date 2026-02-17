class ShowModel {
  final String showId;
  final String showName;
  final String genre;
  final List<EpisodeModel> episodes;

  ShowModel({
    required this.showId,
    required this.showName,
    required this.genre,
    required this.episodes,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      showId: json['showId'] ?? '',
      showName: json['showName'] ?? '',
      genre: json['genre'] ?? '',
      episodes: (json['episodes'] as List?)
          ?.map((e) => EpisodeModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showId': showId,
      'showName': showName,
      'genre': genre,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================
  // HELPER GETTERS
  // ============================================

  // Check if show has episodes
  bool get hasEpisodes => episodes.isNotEmpty;

  // Get total episode count
  int get episodeCount => episodes.length;

  // Get total duration in minutes
  int get totalDurationMin {
    return episodes.fold(0, (sum, episode) => sum + episode.durationMin);
  }

  // Get formatted total duration (e.g., "2s 30dk")
  String get formattedTotalDuration {
    if (totalDurationMin == 0) return '0 dk';
    final hours = totalDurationMin ~/ 60;
    final minutes = totalDurationMin % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}s ${minutes}dk';
    } else if (hours > 0) {
      return '${hours}s';
    } else {
      return '${minutes}dk';
    }
  }

  // Get first episode (for quick watch)
  EpisodeModel? get firstEpisode => episodes.isNotEmpty ? episodes.first : null;

  // Get latest episode
  EpisodeModel? get latestEpisode => episodes.isNotEmpty ? episodes.last : null;

  // Get display name (shortened if too long)
  String get displayName {
    if (showName.length > 25) {
      return '${showName.substring(0, 22)}...';
    }
    return showName;
  }

  // Get genre emoji
  String get genreEmoji {
    switch (genre.toLowerCase()) {
      case 'comedy':
      case 'komedi':
        return '😂';
      case 'drama':
      case 'dram':
        return '🎭';
      case 'action':
      case 'aksiyon':
        return '💥';
      case 'horror':
      case 'korku':
        return '😱';
      case 'crime':
      case 'suç':
        return '🔪';
      case 'mystery':
      case 'gizem':
        return '🔍';
      case 'sci-fi':
      case 'bilim kurgu':
        return '🚀';
      case 'romance':
      case 'romantik':
      case 'aşk':
        return '❤️';
      case 'thriller':
        return '😰';
      case 'documentary':
      case 'belgesel':
        return '📹';
      default:
        return '🎬';
    }
  }

  // Get status text
  String get statusText => hasEpisodes ? '$episodeCount bölüm' : 'Yakında';

  // Get season count
  int get seasonCount {
    if (episodes.isEmpty) return 0;
    return episodes.map((e) => e.season).toSet().length;
  }

  // Get episodes by season
  List<EpisodeModel> episodesBySeason(int season) {
    return episodes.where((e) => e.season == season).toList();
  }

  // Get all season numbers
  List<int> get seasonNumbers {
    return episodes.map((e) => e.season).toSet().toList()..sort();
  }

  // Check if show is binge-worthy (5+ episodes)
  bool get isBingeWorthy => episodeCount >= 5;

  // Get average episode duration
  double get averageEpisodeDuration {
    if (episodes.isEmpty) return 0;
    return totalDurationMin / episodes.length;
  }

  // Get show info summary
  String get infoSummary {
    if (!hasEpisodes) return '$genre • Yakında';
    final seasons = seasonCount > 1 ? '$seasonCount sezon' : '1 sezon';
    return '$genre • $seasons • $episodeCount bölüm';
  }
}

class EpisodeModel {
  final String episodeId;
  final String showId;
  final String showName;
  final int season;
  final int episodeNo;
  final int durationMin;

  EpisodeModel({
    required this.episodeId,
    required this.showId,
    required this.showName,
    required this.season,
    required this.episodeNo,
    required this.durationMin,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      episodeId: json['episodeId'] ?? '',
      showId: json['showId'] ?? '',
      showName: json['showName'] ?? '',
      season: json['season'] ?? 1,
      episodeNo: json['episodeNo'] ?? 1,
      durationMin: json['durationMin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episodeId': episodeId,
      'showId': showId,
      'showName': showName,
      'season': season,
      'episodeNo': episodeNo,
      'durationMin': durationMin,
    };
  }

  // ============================================
  // HELPER GETTERS
  // ============================================

  // Get episode code (e.g., "S1E1")
  String get episodeTitle => 'S${season}E${episodeNo}';

  // Get full title with show name
  String get fullTitle => '$showName - $episodeTitle';

  // Get formatted duration
  String get formattedDuration {
    if (durationMin == 0) return '0 dk';
    final hours = durationMin ~/ 60;
    final minutes = durationMin % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}s ${minutes}dk';
    } else if (hours > 0) {
      return '${hours}s';
    } else {
      return '${minutes}dk';
    }
  }

  // Get short duration (just number + unit)
  String get shortDuration => '${durationMin}dk';

  // Check if episode is long (60+ minutes)
  bool get isLongEpisode => durationMin >= 60;

  // Check if episode is short (<30 minutes)
  bool get isShortEpisode => durationMin < 30;

  // Get episode type
  String get episodeType {
    if (durationMin >= 60) return 'Film uzunluğu';
    if (durationMin >= 45) return 'Standart';
    if (durationMin >= 30) return 'Orta';
    return 'Kısa';
  }

  // Get display text for list
  String get displayText => '$episodeTitle • $formattedDuration';
}