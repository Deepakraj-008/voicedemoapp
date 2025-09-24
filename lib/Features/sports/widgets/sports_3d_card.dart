import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../models/sports_match_model.dart';
import 'sports_live_indicator.dart';
import 'sports_score_widget.dart';

/// 3D Animated sports match card with smooth animations and interactive elements
class Sports3DCard extends StatefulWidget {
  final SportsMatch match;
  final double rotationX;
  final double rotationY;
  final double scale;
  final VoidCallback onTap;
  final AnimationController animationController;
  final bool isCompact;
  final bool showDetails;

  const Sports3DCard({
    Key? key,
    required this.match,
    this.rotationX = 0.0,
    this.rotationY = 0.0,
    this.scale = 1.0,
    required this.onTap,
    required this.animationController,
    this.isCompact = false,
    this.showDetails = true,
  }) : super(key: key);

  @override
  State<Sports3DCard> createState() => _Sports3DCardState();
}

class _Sports3DCardState extends State<Sports3DCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  double _localRotationX = 0.0;
  double _localRotationY = 0.0;
  double _localScale = 1.0;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovering) {
    setState(() {
      _isHovered = isHovering;
      if (isHovering) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    });
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_isHovered) {
      setState(() {
        _localRotationY = (event.localPosition.dx - 150) * 0.01;
        _localRotationX = (event.localPosition.dy - 100) * 0.01;
      });
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
      _localScale = 0.95;
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
      _localScale = 1.0;
    });
  }

  Color _getSportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return Colors.brown;
      case 'football':
      case 'soccer':
        return Colors.green;
      case 'basketball':
        return Colors.orange;
      case 'tennis':
        return Colors.lime;
      case 'baseball':
        return Colors.red;
      case 'hockey':
        return Colors.blue;
      case 'volleyball':
        return Colors.purple;
      case 'rugby':
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'baseball':
        return Icons.sports_baseball;
      case 'hockey':
        return Icons.sports_hockey;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'rugby':
        return Icons.sports_rugby;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sportColor = _getSportColor(widget.match.sport);
    final sportIcon = _getSportIcon(widget.match.sport);

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: Listener(
        onPointerMove: _handlePointerMove,
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerUp,
        child: AnimatedBuilder(
          animation:
              Listenable.merge([_hoverAnimation, widget.animationController]),
          builder: (context, child) {
            final totalRotationX = widget.rotationX + _localRotationX;
            final totalRotationY = widget.rotationY + _localRotationY;
            final totalScale = widget.scale *
                _localScale *
                (1.0 + _hoverAnimation.value * 0.1);

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(totalRotationX)
                ..rotateY(totalRotationY)
                ..scale(totalScale),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                    sportColor.withOpacity(0.3),
                    sportColor.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: sportColor.withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 20 + (10 * _hoverAnimation.value),
                    spreadRadius: 2 + (3 * _hoverAnimation.value),
                    offset: Offset(0, 5 + (5 * _hoverAnimation.value)),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: -5,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: sportColor.withOpacity(0.5 * _glowAnimation.value),
                  width: 1 + (1 * _hoverAnimation.value),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SportsCardBackgroundPainter(
                          sportColor: sportColor,
                          animation: widget.animationController.value,
                        ),
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: widget.isCompact
                          ? _buildCompactContent(sportIcon, sportColor)
                          : _buildFullContent(sportIcon, sportColor),
                    ),

                    // Live indicator overlay
                    if (widget.match.isLive)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: SportsLiveIndicator(
                          animationController: widget.animationController,
                          size: 12,
                        ),
                      ),

                    // Sport icon overlay
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: sportColor.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: sportColor.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          sportIcon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    // Gradient overlay for depth
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                            stops: const [0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullContent(IconData sportIcon, Color sportColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with sport and status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(sportIcon, color: sportColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.match.sport.toUpperCase(),
                  style: TextStyle(
                    color: sportColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.match.isLive ? Colors.red : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.match.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Match title
        Text(
          widget.match.matchTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // Teams
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildTeamInfo(
                widget.match.team1,
                widget.match.team1Score,
                widget.match.team1Logo,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _buildTeamInfo(
                widget.match.team2,
                widget.match.team2Score,
                widget.match.team2Logo,
                isRightAligned: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Score widget if live
        if (widget.match.isLive && widget.showDetails) ...[
          SportsScoreWidget(
            match: widget.match,
            animationController: widget.animationController,
          ),
          const SizedBox(height: 12),
        ],

        // Match details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.match.venue,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
            Text(
              widget.match.startTime,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),

        if (widget.match.result.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: sportColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.match.result,
              style: TextStyle(
                color: sportColor.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompactContent(IconData sportIcon, Color sportColor) {
    return Row(
      children: [
        // Team 1
        Expanded(
          child: Row(
            children: [
              if (widget.match.team1Logo.isNotEmpty)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.match.team1Logo),
                  radius: 16,
                  backgroundColor: sportColor.withOpacity(0.2),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: sportColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sportIcon, color: sportColor, size: 16),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.match.team1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Score or VS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: widget.match.isLive
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.match.team1Score} - ${widget.match.team2Score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.match.currentInning.isNotEmpty)
                      Text(
                        widget.match.currentInning,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                        ),
                      ),
                  ],
                )
              : const Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),

        // Team 2
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  widget.match.team2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.match.team2Logo.isNotEmpty)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.match.team2Logo),
                  radius: 16,
                  backgroundColor: sportColor.withOpacity(0.2),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: sportColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sportIcon, color: sportColor, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfo(String teamName, String score, String logo,
      {bool isRightAligned = false}) {
    final children = <Widget>[
      if (logo.isNotEmpty)
        CircleAvatar(
          backgroundImage: NetworkImage(logo),
          radius: 20,
          backgroundColor: Colors.grey.shade800,
        )
      else
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sports, color: Colors.white, size: 20),
        ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: isRightAligned
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: isRightAligned ? TextAlign.right : TextAlign.left,
            ),
            if (score.isNotEmpty)
              Text(
                score,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    ];

    return isRightAligned
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: children.reversed.toList(),
          )
        : Row(
            children: children,
          );
  }
}

/// Custom painter for sports card background patterns
class SportsCardBackgroundPainter extends CustomPainter {
  final Color sportColor;
  final double animation;

  SportsCardBackgroundPainter({
    required this.sportColor,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw subtle pattern
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        final x = (size.width / 4) * i;
        final y = (size.height / 4) * j;
        final radius = 2 + (animation * 3);

        paint.color = sportColor.withOpacity(0.05 + (animation * 0.05));

        canvas.drawCircle(
          Offset(x + radius, y + radius),
          radius,
          paint,
        );
      }
    }

    // Draw diagonal lines
    paint.color = sportColor.withOpacity(0.1);
    paint.strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 9) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SportsCardBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        sportColor != oldDelegate.sportColor;
  }
}

/// Additional card widgets for different match states
class SportsScheduleCard extends StatelessWidget {
  final SportsMatch match;
  final VoidCallback onTap;

  const SportsScheduleCard({
    Key? key,
    required this.match,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sports3DCard(
      match: match,
      onTap: onTap,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: Navigator.of(context).context as TickerProvider,
      )..forward(),
      showDetails: false,
    );
  }
}

class SportsResultCard extends StatelessWidget {
  final SportsMatch match;
  final VoidCallback onTap;

  const SportsResultCard({
    Key? key,
    required this.match,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sports3DCard(
      match: match,
      onTap: onTap,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: Navigator.of(context).context as TickerProvider,
      )..forward(),
      showDetails: true,
    );
  }
}

class SportsNewsCard extends StatelessWidget {
  final dynamic news;
  final VoidCallback onTap;

  const SportsNewsCard({
    Key? key,
    required this.news,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF2A2A2A),
              Colors.blue.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    news['category'] ?? 'SPORTS',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    news['time'] ?? '2 hours ago',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                news['title'] ?? 'Sports News Title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                news['summary'] ?? 'News summary...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SportsStandingCard extends StatelessWidget {
  final dynamic standing;
  final VoidCallback onTap;

  const SportsStandingCard({
    Key? key,
    required this.standing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF2A2A2A),
              Colors.purple.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    standing['position'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      standing['team'] ?? 'Team Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      standing['tournament'] ?? 'Tournament',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    standing['points']?.toString() ?? '0',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'PTS',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
