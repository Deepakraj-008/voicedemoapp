import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Loading progress widget for splash screen
/// Shows progress for voice model downloads and initialization
class LoadingProgressWidget extends StatefulWidget {
  final double progress;
  final String statusText;
  final bool showProgress;
  final Color progressColor;
  final Color backgroundColor;

  const LoadingProgressWidget({
    super.key,
    required this.progress,
    required this.statusText,
    this.showProgress = true,
    this.progressColor = Colors.white,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<LoadingProgressWidget> createState() => _LoadingProgressWidgetState();
}

class _LoadingProgressWidgetState extends State<LoadingProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status text
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      widget.progressColor.withValues(alpha: 0.5),
                      widget.progressColor,
                      widget.progressColor.withValues(alpha: 0.5),
                    ],
                    stops: [
                      (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                      _shimmerAnimation.value.clamp(0.0, 1.0),
                      (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  widget.statusText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: widget.progressColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          widget.showProgress ? SizedBox(height: 2.h) : const SizedBox.shrink(),

          // Progress indicator
          widget.showProgress
              ? Container(
                  width: 60.w,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: widget.progressColor.withValues(alpha: 0.2),
                  ),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: widget.progressColor.withValues(alpha: 0.1),
                        ),
                      ),
                      // Progress fill
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: (60.w * widget.progress).clamp(0.0, 60.w),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              widget.progressColor.withValues(alpha: 0.8),
                              widget.progressColor,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
