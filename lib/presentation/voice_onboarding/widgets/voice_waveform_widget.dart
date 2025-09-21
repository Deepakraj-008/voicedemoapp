import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isListening;
  final double amplitude;

  const VoiceWaveformWidget({
    super.key,
    required this.isListening,
    this.amplitude = 0.5,
  });

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _waveController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _waveController.stop();
    _pulseController.stop();
    _waveController.reset();
    _pulseController.reset();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.h,
      child: AnimatedBuilder(
        animation: Listenable.merge([_waveAnimation, _pulseAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              waveProgress: _waveAnimation.value,
              pulseScale: _pulseAnimation.value,
              amplitude: widget.amplitude,
              isListening: widget.isListening,
              primaryColor: AppTheme.lightTheme.colorScheme.primary,
              secondaryColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
            size: Size(double.infinity, 20.h),
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double waveProgress;
  final double pulseScale;
  final double amplitude;
  final bool isListening;
  final Color primaryColor;
  final Color secondaryColor;

  WaveformPainter({
    required this.waveProgress,
    required this.pulseScale,
    required this.amplitude,
    required this.isListening,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final waveWidth = size.width * 0.8;
    final startX = (size.width - waveWidth) / 2;

    if (!isListening) {
      // Draw static line when not listening
      paint.color = primaryColor.withValues(alpha: 0.3);
      canvas.drawLine(
        Offset(startX, centerY),
        Offset(startX + waveWidth, centerY),
        paint,
      );
      return;
    }

    // Draw animated waveform when listening
    final path = Path();
    final waveCount = 3;

    for (int i = 0; i < waveCount; i++) {
      final waveOffset = (i * size.width / waveCount);
      final wavePhase = (waveProgress * 2 * 3.14159) + (i * 0.5);

      paint.color = i == 1
          ? primaryColor.withValues(alpha: 0.8)
          : secondaryColor.withValues(alpha: 0.4);

      path.reset();

      for (double x = 0; x <= waveWidth; x += 2) {
        final normalizedX = x / waveWidth;
        final waveValue = amplitude *
            (size.height * 0.15) *
            (0.5 + 0.5 * (normalizedX * (1 - normalizedX) * 4)) *
            (pulseScale - 0.8) /
            0.4 *
            (1 + 0.3 * (i - 1).abs()) *
            (waveCount == 3 && i == 1 ? 1.2 : 1.0);

        final y = centerY +
            waveValue *
                (i == 1 ? 1.0 : 0.6) *
                (waveCount > 1 ? (i % 2 == 0 ? 1 : -1) : 1) *
                (1 + 0.3 * (waveProgress - 0.5).abs());

        if (x == 0) {
          path.moveTo(startX + x, y);
        } else {
          path.lineTo(startX + x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Draw center pulse circle
    final pulsePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, centerY),
      (12 * pulseScale).clamp(8.0, 20.0),
      pulsePaint,
    );

    // Draw inner pulse circle
    final innerPulsePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, centerY),
      (6 * pulseScale).clamp(4.0, 10.0),
      innerPulsePaint,
    );
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress ||
        oldDelegate.pulseScale != pulseScale ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.isListening != isListening;
  }
}
