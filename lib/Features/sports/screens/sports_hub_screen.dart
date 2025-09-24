import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// removed unused provider import
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/sports_3d_card.dart';
import '../providers/sports_providers.dart';
import '../models/sports_match_model.dart';

// Placeholder screens used by navigation. If you have real screens elsewhere,
// you can remove these placeholders.
class SportsMatchDetailScreen extends StatelessWidget {
  final SportsMatch match;
  const SportsMatchDetailScreen({Key? key, required this.match})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match.matchTitle)),
      body: Center(child: Text('Match details for ${match.matchTitle}')),
    );
  }
}

class SportsLiveScreen extends StatelessWidget {
  const SportsLiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Stream')),
      body: const Center(child: Text('Live streaming coming soon')),
    );
  }
}

/// Main sports hub screen with 3D animations and comprehensive sports features
/// Replaces the old crex functionality with enhanced multi-sport support
class SportsHubScreen extends ConsumerStatefulWidget {
  const SportsHubScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SportsHubScreen> createState() => _SportsHubScreenState();
}

class _SportsHubScreenState extends ConsumerState<SportsHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late AnimationController _3dAnimationController;
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  int _selectedTab = 0;
  String _selectedSport = 'all';
  String _selectedFormat = 'all';
  String _selectedPriority = 'all';
  bool _isSearching = false;
  String _searchQuery = '';
  bool _showFilters = false;

  // 3D animation parameters
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _scale = 1.0;
  Offset _lastPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _3dAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scrollController = ScrollController();
    _searchController = TextEditingController(text: _searchQuery);

    // Initialize sports data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });

    // Start animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _3dAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final sportsNotifier = ref.read(sportsProvider.notifier);
    await sportsNotifier.loadLiveMatches();
    await sportsNotifier.loadUpcomingMatches();
    await sportsNotifier.loadRecentMatches();
    await sportsNotifier.loadSportsCategories();
  }

  void _handleSportSelection(String sport) {
    setState(() {
      _selectedSport = sport;
    });
    ref.read(sportsProvider.notifier).filterMatches(
          sport: sport,
          format: _selectedFormat,
          priority: _selectedPriority,
        );
  }

  void _handleFormatSelection(String format) {
    setState(() {
      _selectedFormat = format;
    });
    ref.read(sportsProvider.notifier).filterMatches(
          sport: _selectedSport,
          format: format,
          priority: _selectedPriority,
        );
  }

  void _handlePrioritySelection(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
    ref.read(sportsProvider.notifier).filterMatches(
          sport: _selectedSport,
          format: _selectedFormat,
          priority: priority,
        );
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
    ref.read(sportsProvider.notifier).searchMatches(query);
  }

  void _navigateToMatchDetail(SportsMatch match) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SportsMatchDetailScreen(match: match),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offset = Tween<Offset>(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut));
          return SlideTransition(
            position: offset,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _handleTabChange(int index) {
    setState(() {
      _selectedTab = index;
    });
    _tabController.animateTo(index);
  }

  // 3D touch interaction handlers
  void _handlePointerMove(PointerMoveEvent event) {
    setState(() {
      final delta = event.position - _lastPosition;
      _rotationY += delta.dx * 0.01;
      _rotationX -= delta.dy * 0.01;
      _lastPosition = event.position;
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _lastPosition = event.position;
      _scale = 0.95;
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sportsState = ref.watch(sportsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildAppBar(),
              _buildTabBar(),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildLiveMatchesTab(sportsState),
              _buildUpcomingMatchesTab(sportsState),
              _buildRecentMatchesTab(sportsState),
              _buildSportsNewsTab(sportsState),
              _buildStandingsTab(sportsState),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1A1A1A),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 16,
          bottom: 16,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (_animationController.value * 0.2),
                  child: child,
                );
              },
              child: _isSearching
                  ? SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search matches...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    )
                  : const Text(
                      'SPORTS ARENA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Live • Schedule • Scores • News',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            if (_showFilters) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedSport == 'all',
                    onSelected: (_) => _handleSportSelection('all'),
                  ),
                  ChoiceChip(
                    label: const Text('Cricket'),
                    selected: _selectedSport == 'cricket',
                    onSelected: (_) => _handleSportSelection('cricket'),
                  ),
                  ChoiceChip(
                    label: const Text('Football'),
                    selected: _selectedSport == 'football',
                    onSelected: (_) => _handleSportSelection('football'),
                  ),
                  ChoiceChip(
                    label: const Text('T20'),
                    selected: _selectedFormat == 'T20',
                    onSelected: (_) => _handleFormatSelection('T20'),
                  ),
                  DropdownButton<String>(
                    value: _selectedPriority,
                    dropdownColor: Colors.black,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                    ],
                    onChanged: (v) {
                      if (v != null) _handlePrioritySelection(v);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF2A2A2A),
                Colors.blue.shade900,
                Colors.purple.shade900,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated background particles
              AnimatedBuilder(
                animation: _3dAnimationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticlePainter(
                      animation: _3dAnimationController.value,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    size: Size.infinite,
                  );
                },
              ),
              // 3D sports icons
              Center(
                child: AnimatedBuilder(
                  animation: _3dAnimationController,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(
                            _rotationX + (_3dAnimationController.value * 0.1))
                        ..rotateY(
                            _rotationY + (_3dAnimationController.value * 0.15))
                        ..scale(_scale),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _build3DSportIcon(Icons.sports_cricket, Colors.white),
                      const SizedBox(width: 20),
                      _build3DSportIcon(Icons.sports_soccer, Colors.white),
                      const SizedBox(width: 20),
                      _build3DSportIcon(Icons.sports_basketball, Colors.white),
                      const SizedBox(width: 20),
                      _build3DSportIcon(Icons.sports_tennis, Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _build3DSportIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.purple.shade600],
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'LIVE'),
            Tab(text: 'UPCOMING'),
            Tab(text: 'RECENT'),
            Tab(text: 'NEWS'),
            Tab(text: 'STANDINGS'),
          ],
        ),
      ),
      pinned: true,
    );
  }

  Widget _buildLiveMatchesTab(SportsState state) {
    if (state.isLoadingLiveMatches) {
      return _buildLoadingWidget();
    }

    final liveMatches = state.filteredLiveMatches;

    if (liveMatches.isEmpty) {
      return _buildEmptyState('No live matches at the moment');
    }

    return Listener(
      onPointerMove: _handlePointerMove,
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: liveMatches.length,
        itemBuilder: (context, index) {
          final match = liveMatches[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Hero(
              tag: 'match_${match.id}',
              child: Sports3DCard(
                match: match,
                rotationX: _rotationX,
                rotationY: _rotationY,
                scale: _scale,
                onTap: () => _navigateToMatchDetail(match),
                animationController: _animationController,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingMatchesTab(SportsState state) {
    if (state.isLoadingUpcomingMatches) {
      return _buildLoadingWidget();
    }

    final upcomingMatches = state.filteredUpcomingMatches;

    if (upcomingMatches.isEmpty) {
      return _buildEmptyState('No upcoming matches scheduled');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingMatches.length,
      itemBuilder: (context, index) {
        final match = upcomingMatches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SportsScheduleCard(
            match: match,
            onTap: () => _navigateToMatchDetail(match),
          ),
        );
      },
    );
  }

  Widget _buildRecentMatchesTab(SportsState state) {
    if (state.isLoadingRecentMatches) {
      return _buildLoadingWidget();
    }

    final recentMatches = state.filteredRecentMatches;

    if (recentMatches.isEmpty) {
      return _buildEmptyState('No recent matches found');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentMatches.length,
      itemBuilder: (context, index) {
        final match = recentMatches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SportsResultCard(
            match: match,
            onTap: () => _navigateToMatchDetail(match),
          ),
        );
      },
    );
  }

  Widget _buildSportsNewsTab(SportsState state) {
    if (state.isLoadingNews) {
      return _buildLoadingWidget();
    }

    final news = state.sportsNews;

    if (news.isEmpty) {
      return _buildEmptyState('No sports news available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final newsItem = news[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SportsNewsCard(
            news: newsItem,
            onTap: () {
              // Navigate to news detail
            },
          ),
        );
      },
    );
  }

  Widget _buildStandingsTab(SportsState state) {
    if (state.isLoadingStandings) {
      return _buildLoadingWidget();
    }

    final standings = state.sportsStandings;

    if (standings.isEmpty) {
      return _buildEmptyState('No standings available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: standings.length,
      itemBuilder: (context, index) {
        final standing = standings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SportsStandingCard(
            standing: standing,
            onTap: () {
              // Navigate to tournament detail
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * 3.14159,
                child: child,
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_baseball,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading sports data...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports,
            size: 80,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to live streaming screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SportsLiveScreen(),
          ),
        );
      },
      backgroundColor: Colors.red,
      icon: const Icon(Icons.videocam, color: Colors.white),
      label: const Text(
        'LIVE STREAM',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.grey.shade900],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _selectedTab,
        onTap: _handleTabChange,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade400,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Standings',
          ),
        ],
      ),
    );
  }
}

/// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animation;
  final Color color;

  ParticlePainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      final opacity = random.nextDouble() * 0.5 + 0.1;

      paint.color = color.withOpacity(opacity * animation);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

/// Sliver delegate for tab bar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
