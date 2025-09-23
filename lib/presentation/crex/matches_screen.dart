import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/crex/logic/match_providers.dart';
import 'widgets/match_card.dart';
import 'widgets/chip_bar.dart';

class CrexMatchesScreen extends StatefulWidget {
  const CrexMatchesScreen({Key? key}) : super(key: key);

  @override
  State<CrexMatchesScreen> createState() => _CrexMatchesScreenState();
}

class _CrexMatchesScreenState extends State<CrexMatchesScreen> {
  int _selectedTab = 0;
  final List<String> _matchTypes = ['All', 'Test', 'ODI', 'T20', 'IPL'];

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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Matches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: Consumer<MatchProviders>(
        builder: (context, matchProvider, child) {
          return Column(
            children: [
              // Filter Chips
              Padding(
                padding: const EdgeInsets.all(16),
                child: ChipBar(
                  items: _matchTypes,
                  selectedIndex: _selectedTab,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                    if (index > 0) {
                      matchProvider.fetchMatchesByFormat(_matchTypes[index]);
                    }
                  },
                ),
              ),

              // Tab Content
              Expanded(
                child: _buildTabContent(matchProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(MatchProviders matchProvider) {
    switch (_selectedTab) {
      case 0: // All
        return _buildAllMatchesTab(matchProvider);
      case 1: // Test
      case 2: // ODI
      case 3: // T20
      case 4: // IPL
        return _buildFormatMatchesTab(matchProvider);
      default:
        return _buildAllMatchesTab(matchProvider);
    }
  }

  Widget _buildAllMatchesTab(MatchProviders matchProvider) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF0EA5E9),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF0EA5E9),
            tabs: [
              Tab(text: 'Live'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Recent'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMatchesList(
                  matches: matchProvider.liveMatches,
                  isLoading: matchProvider.isLoadingLiveMatches,
                  error: matchProvider.liveMatchesError,
                  emptyMessage: 'No live matches',
                ),
                _buildMatchesList(
                  matches: matchProvider.upcomingMatches,
                  isLoading: matchProvider.isLoadingUpcomingMatches,
                  error: matchProvider.upcomingMatchesError,
                  emptyMessage: 'No upcoming matches',
                ),
                _buildMatchesList(
                  matches: matchProvider.recentMatches,
                  isLoading: matchProvider.isLoadingRecentMatches,
                  error: matchProvider.recentMatchesError,
                  emptyMessage: 'No recent matches',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatMatchesTab(MatchProviders matchProvider) {
    return FutureBuilder(
      future: matchProvider.fetchMatchesByFormat(_matchTypes[_selectedTab]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0EA5E9)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final matches = snapshot.data as List<dynamic>? ?? [];
        if (matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_cricket, color: Colors.grey, size: 48),
                const SizedBox(height: 16),
                Text(
                  'No ${_matchTypes[_selectedTab]} matches found',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchCard(
                match: match,
                isLive: match.isLive,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMatchesList({
    required List<dynamic> matches,
    required bool isLoading,
    required String? error,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0EA5E9)),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_cricket, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MatchCard(
            match: match,
            isLive: match.isLive,
          ),
        );
      },
    );
  }
}
