import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/crex/logic/match_providers.dart' show MatchProviders;
import 'widgets/match_card.dart';
import 'widgets/chip_bar.dart';
import 'widgets/live_dot.dart';

class CrexHomeScreen extends StatefulWidget {
  const CrexHomeScreen({Key? key}) : super(key: key);

  @override
  State<CrexHomeScreen> createState() => _CrexHomeScreenState();
}

class _CrexHomeScreenState extends State<CrexHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MatchProviders>(context, listen: false);
      provider.fetchLiveMatches();
      provider.fetchUpcomingMatches();
      provider.fetchRecentMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProviders>(
      builder: (context, matchProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            title: const Text(
              'CREX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // TODO: Implement search
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // TODO: Implement notifications
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => matchProvider.refreshAllMatches(),
            color: const Color(0xFF0EA5E9),
            backgroundColor: const Color(0xFF1E293B),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Matches Section
                  _buildSectionHeader('Live Matches', 'See all'),
                  if (matchProvider.isLoadingLiveMatches)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0EA5E9))),
                    )
                  else if (matchProvider.liveMatchesError != null)
                    _buildErrorWidget(matchProvider.liveMatchesError!)
                  else if (matchProvider.liveMatches.isEmpty)
                    _buildEmptyWidget('No live matches')
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: matchProvider.liveMatches.length,
                        itemBuilder: (context, index) {
                          final match = matchProvider.liveMatches[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MatchCard(match: match, isLive: true),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Upcoming Matches Section
                  _buildSectionHeader('Upcoming Matches', 'See all'),
                  if (matchProvider.isLoadingUpcomingMatches)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0EA5E9))),
                    )
                  else if (matchProvider.upcomingMatchesError != null)
                    _buildErrorWidget(matchProvider.upcomingMatchesError!)
                  else if (matchProvider.upcomingMatches.isEmpty)
                    _buildEmptyWidget('No upcoming matches')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matchProvider.upcomingMatches.length,
                      itemBuilder: (context, index) {
                        final match = matchProvider.upcomingMatches[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MatchCard(match: match, isLive: false),
                        );
                      },
                    ),

                  const SizedBox(height: 24),

                  // Recent Matches Section
                  _buildSectionHeader('Recent Matches', 'See all'),
                  if (matchProvider.isLoadingRecentMatches)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0EA5E9))),
                    )
                  else if (matchProvider.recentMatchesError != null)
                    _buildErrorWidget(matchProvider.recentMatchesError!)
                  else if (matchProvider.recentMatches.isEmpty)
                    _buildEmptyWidget('No recent matches')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matchProvider.recentMatches.length,
                      itemBuilder: (context, index) {
                        final match = matchProvider.recentMatches[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MatchCard(match: match, isLive: false),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Navigate to see all
            },
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF0EA5E9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.sports_cricket, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
