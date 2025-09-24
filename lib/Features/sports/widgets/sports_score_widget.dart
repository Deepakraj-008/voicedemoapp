import 'package:flutter/material.dart';
// removed unused math import
// removed unused dart:ui import
import '../models/sports_match_model.dart';
import 'sports_live_indicator.dart';

/// 3D Animated sports score widget with real-time updates and smooth animations
class SportsScoreWidget extends StatefulWidget {
  final SportsMatch match;
  final AnimationController animationController;
  final bool showDetails;
  final bool compactMode;
  final Function(String)? onScoreTap;
  final Function(String)? onInningTap;
  final double size;

  const SportsScoreWidget({
    Key? key,
    required this.match,
    required this.animationController,
    this.showDetails = true,
    this.compactMode = false,
    this.onScoreTap,
    this.onInningTap,
    this.size = 24,
  }) : super(key: key);

  @override
  State<SportsScoreWidget> createState() => _SportsScoreWidgetState();
}

class _SportsScoreWidgetState extends State<SportsScoreWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scoreAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  String _previousTeam1Score = '';
  String _previousTeam2Score = '';

  String get _team1Score =>
      widget.match.currentScore?.team1Score['runs']?.toString() ?? '0';
  String get _team2Score =>
      widget.match.currentScore?.team2Score['runs']?.toString() ?? '0';
  String get _currentInning =>
      widget.match.currentScore?.currentInning ?? widget.match.currentInning;

  @override
  void initState() {
    super.initState();

    _previousTeam1Score = _team1Score;
    _previousTeam2Score = _team2Score;

    _initializeAnimations();
    // Initial scores set. Score changes are detected in didUpdateWidget
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SportsScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Detect when the match object or its score changed and trigger animation
    if (oldWidget.match.currentScore != widget.match.currentScore) {
      _handleScoreChange();
    }
  }

  void _initializeAnimations() {
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 80),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );
  }

  void _handleScoreChange() {
    if (_previousTeam1Score != _team1Score ||
        _previousTeam2Score != _team2Score) {
      setState(() {
        // trigger a small visual change while animation runs
      });

      widget.animationController.forward().then((_) {
        setState(() {
          _previousTeam1Score = _team1Score;
          _previousTeam2Score = _team2Score;
        });
        widget.animationController.reset();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (widget.compactMode) {
      return _buildCompactScoreWidget();
    }

    return widget.showDetails
        ? _buildDetailedScoreWidget()
        : _buildSimpleScoreWidget();
  }

  Widget _buildDetailedScoreWidget() {
    final sportColor = _getSportColor(widget.match.sport);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sportColor.withOpacity(0.2),
            sportColor.withOpacity(0.1),
            Colors.grey.shade900.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        border: Border.all(
          color: sportColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: sportColor.withOpacity(_glowAnimation.value * 0.3),
            blurRadius: 15 + (10 * _glowAnimation.value),
            spreadRadius: 2 + (3 * _glowAnimation.value),
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Match status and inning info
          if (widget.match.currentInning.isNotEmpty ||
              widget.match.status.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.match.currentInning.isNotEmpty)
                  GestureDetector(
                    onTap: () =>
                        widget.onInningTap?.call(widget.match.currentInning),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            sportColor.withOpacity(0.8),
                            sportColor.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: sportColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sports_baseball,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _currentInning,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.match.status.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade800.withOpacity(0.8),
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.match.status,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

          const SizedBox(height: 12),

          // Main scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamScore(
                widget.match.team1,
                _team1Score,
                widget.match.team1Logo,
                sportColor,
                isLeft: true,
              ),

              // VS indicator with live animation
              Column(
                children: [
                  if (widget.match.isLive)
                    SportsLiveIndicator(
                      animationController: widget.animationController,
                      size: widget.size * 0.8,
                      color: Colors.red,
                    )
                  else
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              _buildTeamScore(
                widget.match.team2,
                _team2Score,
                widget.match.team2Logo,
                sportColor,
                isLeft: false,
              ),
            ],
          ),

          // Additional score details
          if (_team1Score.isNotEmpty && _team2Score.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 12),
                _buildScoreDetails(sportColor),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTeamScore(
      String teamName, String score, String logo, Color sportColor,
      {bool isLeft = true}) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scoreAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                colors: [
                  sportColor.withOpacity(0.3),
                  sportColor.withOpacity(0.1),
                  Colors.grey.shade900.withOpacity(0.5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: sportColor.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: sportColor.withOpacity(_glowAnimation.value * 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                // Team logo or icon
                if (logo.isNotEmpty)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sportColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        logo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: sportColor.withOpacity(0.2),
                            child: Icon(
                              Icons.sports,
                              color: sportColor,
                              size: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sportColor.withOpacity(0.2),
                      border: Border.all(
                        color: sportColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.sports,
                      color: sportColor,
                      size: 16,
                    ),
                  ),

                const SizedBox(height: 8),

                // Team name
                SizedBox(
                  width: 80,
                  child: Text(
                    teamName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 6),

                // Score with flip animation
                GestureDetector(
                  onTap: () => widget.onScoreTap?.call(score),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: animation,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey(score),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade800,
                            Colors.grey.shade900,
                          ],
                        ),
                        border: Border.all(
                          color: sportColor.withOpacity(0.6),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: sportColor.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        score.isEmpty ? '0' : score,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: sportColor.withOpacity(0.8),
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreDetails(Color sportColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade900.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
        border: Border.all(
          color: sportColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Format: ${widget.match.format}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
              Text(
                'Match #${widget.match.matchNumber}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (widget.match.seriesName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.match.seriesName,
              style: TextStyle(
                color: sportColor.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (widget.match.result?.isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: sportColor.withOpacity(0.2),
                border: Border.all(
                  color: sportColor.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Text(
                widget.match.result ?? '',
                style: TextStyle(
                  color: sportColor.withOpacity(0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimpleScoreWidget() {
    final sportColor = _getSportColor(widget.match.sport);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            sportColor.withOpacity(0.2),
            sportColor.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: sportColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.match.isLive)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SportsLiveIndicator(
                animationController: widget.animationController,
                size: 8,
                color: Colors.red,
              ),
            ),
          Text(
            '$_team1Score - $_team2Score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_currentInning.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              _currentInning,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactScoreWidget() {
    final sportColor = _getSportColor(widget.match.sport);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade900.withOpacity(0.8),
        border: Border.all(
          color: sportColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.match.isLive)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: MinimalLiveIndicator(
                size: 6,
                color: Colors.red,
                animate: true,
              ),
            ),
          Text(
            '$_team1Score-$_team2Score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
