import 'package:flutter/material.dart';
import '../models/user_state.dart';
import '../models/show_model.dart';
import '../models/dashboard_response_model.dart';
import '../services/data_service.dart';

class DashboardPage extends StatefulWidget {
  final UserStateModel user; 
  final Function(int) onTabRequest;

  const DashboardPage({super.key, required this.user, required this.onTabRequest});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DataService _dataService = DataService();
  late Future<DashboardResponse> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _dashboardFuture = _dataService.getFullDashboard(widget.user.userId);
    });
  }

  void _watchEpisode(EpisodeModel episode) async {
    bool success = await _dataService.reportWatchActivity(widget.user.userId, episode.episodeId);
    if (success) {
      await Future.delayed(const Duration(milliseconds: 800)); 
      _refreshData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${episode.showName} izlendi!"), 
            backgroundColor: Colors.green
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("TV+ Gamification"),
        backgroundColor: const Color(0xFF0038A8),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DashboardResponse>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Hata: ${snapshot.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text("Tekrar Dene"),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Veri yok."));
          }
          
          final dashboard = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBadgeInfo(dashboard.user.name, dashboard.user.totalPoints),
                  const SizedBox(height: 25),
                  const Text(
                    "Rozetlerim", 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF0038A8)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildBadgeList(dashboard.badges),
                  const SizedBox(height: 25),
                  const Text(
                    "Katalog", 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF0038A8)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildDynamicCatalog(),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _statCard(
                        "Bugün", 
                        "${dashboard.state.watchMinutesToday} dk", 
                        Icons.access_time, 
                        Colors.blue
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        "Seri", 
                        "${dashboard.state.watchStreakDays} Gün", 
                        Icons.local_fire_department, 
                        Colors.orange
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => widget.onTabRequest(2), 
                    icon: const Icon(Icons.emoji_events),
                    label: const Text("Tüm Ödülleri Gör"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildDynamicCatalog() {
    return FutureBuilder<List<ShowModel>>(
      future: _dataService.getCatalog(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LinearProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Katalog yüklenemedi: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Katalogda gösterilecek içerik yok."));
        }
        
        final shows = snapshot.data!;
        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index];
              final hasEpisodes = show.episodes.isNotEmpty;
              
              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: InkWell(
                    onTap: hasEpisodes 
                      ? () => _watchEpisode(show.episodes.first) 
                      : null,
                    borderRadius: BorderRadius.circular(15),
                    child: Opacity(
                      opacity: hasEpisodes ? 1.0 : 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasEpisodes ? Icons.movie : Icons.lock,
                            color: const Color(0xFF0038A8), 
                            size: 40
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              show.showName, // Using showName property
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 12
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!hasEpisodes) ...[
                            const SizedBox(height: 4),
                            const Text(
                              "Yakında",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _statCard(String label, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              val, 
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18
              )
            ),
            Text(
              label, 
              style: const TextStyle(
                color: Colors.grey, 
                fontSize: 12
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeList(List<BadgeModel> badges) {
    if (badges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Henüz rozet yok. İçerik izlemeye başlayın!",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 25,
                  child: Text(
                    badge.badgeEmoji ?? '🏆',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  badge.badgeName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgeInfo(String name, int points) {
    final progress = (points % 1000) / 1000;
    final nextMilestone = ((points ~/ 1000) + 1) * 1000;
    final pointsToNext = nextMilestone - points;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.stars, color: Colors.amber, size: 40),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              color: const Color(0xFF0038A8),
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Toplam Puan: $points",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "$pointsToNext puana daha",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}