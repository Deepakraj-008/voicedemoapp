import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Voice waveform visualization widget for splash screen
/// Displays animated waveform during voice service initialization
class VoiceWaveformWidget extends StatefulWidget {
  final bool isAnimating;
  final Color color;
  final double height;
  final double width;

  const VoiceWaveformWidget({
    super.key,
    required this.isAnimating,
    this.color = Colors.white,
    this.height = 60.0,
    this.width = 200.0,
  });

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.isAnimating) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              animationValue: _animation.value,
              color: widget.color,
              isAnimating: widget.isAnimating,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

/// Custom painter for voice waveform visualization
class WaveformPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final bool isAnimating;

  WaveformPainter({
    required this.animationValue,
    required this.color,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 20;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;

      // Calculate bar height with animation
      double barHeight;
      if (isAnimating) {
        final phase = (animationValue + i * 0.3) % (2 * math.pi);
        barHeight = (math.sin(phase) * 0.5 + 0.5) * size.height * 0.6 +
            size.height * 0.1;
      } else {
        barHeight = size.height * 0.2;
      }

      // Draw bar
      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isAnimating != isAnimating;
  }
}
