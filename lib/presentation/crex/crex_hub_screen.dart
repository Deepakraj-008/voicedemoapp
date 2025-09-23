import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/crex/logic/match_providers.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'fixtures_screen.dart';
import 'series_hub_screen.dart';
import 'videos_screen.dart';

class CrexHubScreen extends StatefulWidget {
  const CrexHubScreen({Key? key}) : super(key: key);

  @override
  State<CrexHubScreen> createState() => _CrexHubScreenState();
}

class _CrexHubScreenState extends State<CrexHubScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CrexHomeScreen(),
    const CrexMatchesScreen(),
    const CrexFixturesScreen(),
    const CrexSeriesHubScreen(),
    const CrexVideosScreen(),
  ];

  final List<String> _screenTitles = [
    'Home',
    'Matches',
    'Fixtures',
    'Series',
    'Videos',
  ];

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
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border(
            top: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0EA5E9),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Fixtures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Series',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.videocam),
              label: 'Videos',
            ),
          ],
        ),
      ),
    );
  }
}
