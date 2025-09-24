import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated live indicator with 3D effects and smooth animations
class SportsLiveIndicator extends StatefulWidget {
  final AnimationController animationController;
  final double size;
  final Color color;
  final bool showText;
  final Duration animationDuration;

  const SportsLiveIndicator({
    Key? key,
    required this.animationController,
    this.size = 12,
    this.color = Colors.red,
    this.showText = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<SportsLiveIndicator> createState() => _SportsLiveIndicatorState();
}

class _SportsLiveIndicatorState extends State<SportsLiveIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.3), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.8), weight: 70),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticInOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -10), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -10, end: 5), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: 0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.bounceOut),
      ),
    );

    widget.animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _glowAnimation,
        _scaleAnimation,
        _rotationAnimation,
        _bounceAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main live dot with 3D effects
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect
                  Container(
                    width: widget.size * 2.5,
                    height: widget.size * 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.color.withOpacity(_glowAnimation.value * 0.8),
                          widget.color.withOpacity(_glowAnimation.value * 0.4),
                          widget.color.withOpacity(_glowAnimation.value * 0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color
                              .withOpacity(_glowAnimation.value * 0.5),
                          blurRadius: widget.size * 2,
                          spreadRadius: widget.size * 0.5,
                        ),
                      ],
                    ),
                  ),

                  // Middle pulse ring
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: widget.size * 1.5,
                      height: widget.size * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.color
                                .withOpacity(_pulseAnimation.value * 0.6),
                            widget.color
                                .withOpacity(_pulseAnimation.value * 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Inner rotating core
                  Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.color.withOpacity(1.0),
                            widget.color.withOpacity(0.8),
                            widget.color.withOpacity(0.6),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: widget.size * 0.5,
                            offset: const Offset(-1, -1),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: widget.size * 0.5,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Highlight sparkle effect
                  if (_pulseAnimation.value > 0.8)
                    Transform.rotate(
                      angle: _rotationAnimation.value * 2,
                      child: Container(
                        width: widget.size * 0.8,
                        height: widget.size * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(
                                  (_pulseAnimation.value - 0.8) * 2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              if (widget.showText) ...[
                const SizedBox(width: 8),
                // LIVE text with 3D effect
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(_pulseAnimation.value),
                      widget.color.withOpacity(_pulseAnimation.value * 0.7),
                      widget.color.withOpacity(_pulseAnimation.value * 0.4),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.size * 0.8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: widget.color
                              .withOpacity(_glowAnimation.value * 0.8),
                          blurRadius: widget.size * 0.5,
                          offset: const Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: widget.size * 0.3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Enhanced live indicator with additional visual effects
class EnhancedLiveIndicator extends StatelessWidget {
  final AnimationController animationController;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showPulse;
  final bool showRipple;
  final Duration animationDuration;

  const EnhancedLiveIndicator({
    Key? key,
    required this.animationController,
    this.size = 16,
    this.primaryColor = Colors.red,
    this.secondaryColor = Colors.orange,
    this.showPulse = true,
    this.showRipple = true,
    this.animationDuration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final pulseValue = showPulse
            ? CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
              ).value
            : 1.0;

        final rippleValue = showRipple
            ? CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
              ).value
            : 0.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            if (showRipple)
              Transform.scale(
                scale: 1.0 + (rippleValue * 2.0),
                child: Container(
                  width: size * 3,
                  height: size * 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          primaryColor.withOpacity(0.3 * (1.0 - rippleValue)),
                      width: 2,
                    ),
                  ),
                ),
              ),

            // Secondary pulse ring
            if (showPulse)
              Transform.scale(
                scale: 0.8 + (pulseValue * 0.4),
                child: Container(
                  width: size * 2,
                  height: size * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        secondaryColor.withOpacity(0.6 * pulseValue),
                        secondaryColor.withOpacity(0.3 * pulseValue),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

            // Primary live indicator
            SportsLiveIndicator(
              animationController: animationController,
              size: size,
              color: primaryColor,
              showText: false,
              animationDuration: animationDuration,
            ),

            // Central core with gradient
            Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    primaryColor.withOpacity(0.8),
                  ],
                  stops: const [0.0, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: size * 0.2,
                    offset: const Offset(-0.5, -0.5),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Minimal live indicator for compact layouts
class MinimalLiveIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final bool animate;

  const MinimalLiveIndicator({
    Key? key,
    this.size = 8,
    this.color = Colors.red,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: animate
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: size,
                  spreadRadius: size * 0.5,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Live indicator with custom animation controller
class CustomLiveIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final Curve curve;
  final bool autoStart;

  const CustomLiveIndicator({
    Key? key,
    this.size = 12,
    this.color = Colors.red,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<CustomLiveIndicator> createState() => _CustomLiveIndicatorState();
}

class _CustomLiveIndicatorState extends State<CustomLiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.autoStart) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() => _controller.repeat(reverse: true);
  void stop() => _controller.stop();
  void reset() => _controller.reset();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(_animation.value),
                widget.color.withOpacity(_animation.value * 0.5),
                Colors.transparent,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_animation.value * 0.3),
                blurRadius: widget.size,
                spreadRadius: widget.size * 0.3,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Live indicator builder for custom implementations
class LiveIndicatorBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Animation<double> animation)
      builder;
  final Duration duration;
  final Curve curve;

  const LiveIndicatorBuilder({
    Key? key,
    required this.builder,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return builder(context, AlwaysStoppedAnimation(value));
      },
      onEnd: () {
        // Restart animation
        (context as Element).markNeedsBuild();
      },
    );
  }
}
