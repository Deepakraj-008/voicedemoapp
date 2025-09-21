import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isListening;
  final bool isRecording;
  final RecorderController? recorderController;
  final PlayerController? playerController;

  const VoiceWaveformWidget({
    Key? key,
    required this.isListening,
    this.isRecording = false,
    this.recorderController,
    this.playerController,
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isListening
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isRecording && widget.recorderController != null)
            _buildRecordingWaveform()
          else if (widget.playerController != null)
            _buildPlaybackWaveform()
          else
            _buildListeningIndicator(),
          SizedBox(height: 1.h),
          Text(
            widget.isRecording
                ? 'Recording...'
                : widget.isListening
                    ? 'Listening...'
                    : 'Voice Ready',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: widget.isListening
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingWaveform() {
    return Container(
      width: 70.w,
      height: 8.h,
      child: AudioWaveforms(
        size: Size(70.w, 8.h),
        recorderController: widget.recorderController!,
        enableGesture: false,
        waveStyle: WaveStyle(
          waveColor: AppTheme.lightTheme.primaryColor,
          extendWaveform: true,
          showMiddleLine: false,
          spacing: 4,
          waveThickness: 3,
          scaleFactor: 0.8,
        ),
      ),
    );
  }

  Widget _buildPlaybackWaveform() {
    return Container(
      width: 70.w,
      height: 8.h,
      child: AudioWaveforms(
        size: Size(70.w, 8.h),
        recorderController: widget.playerController!,
        enableGesture: true,
        waveStyle: WaveStyle(
          waveColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
          extendWaveform: true,
          showMiddleLine: false,
          spacing: 4,
          waveThickness: 3,
          scaleFactor: 0.8,
        ),
      ),
    );
  }

  Widget _buildListeningIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isListening ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 60.w,
            height: 6.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final height = widget.isListening
                    ? (20 + (index % 3) * 15).toDouble()
                    : 20.0;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  width: 3,
                  height: height,
                  decoration: BoxDecoration(
                    color: widget.isListening
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.7 + (index % 3) * 0.1)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}