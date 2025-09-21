import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CourseEnrollmentSection extends StatefulWidget {
  final Map<String, dynamic> courseData;
  final bool isEnrolled;
  final VoidCallback onEnroll;
  final VoidCallback onContinue;

  const CourseEnrollmentSection({
    super.key,
    required this.courseData,
    required this.isEnrolled,
    required this.onEnroll,
    required this.onContinue,
  });

  @override
  State<CourseEnrollmentSection> createState() =>
      _CourseEnrollmentSectionState();
}

class _CourseEnrollmentSectionState extends State<CourseEnrollmentSection> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isEnrolled) ...[
            // Pricing Section
            Row(
              children: [
                if (widget.courseData["originalPrice"] != null) ...[
                  Text(
                    widget.courseData["originalPrice"] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                  SizedBox(width: 2.w),
                ],

                Text(
                  widget.courseData["price"] as String,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),

                Spacer(),

                // Discount Badge
                if (widget.courseData["discount"] != null)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.courseData["discount"]}% OFF',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 2.h),

            // Course Features
            _buildFeaturesList(context),

            SizedBox(height: 3.h),
          ] else ...[
            // Progress Section for Enrolled Users
            _buildProgressSection(context),

            SizedBox(height: 2.h),
          ],

          // Action Buttons
          Row(
            children: [
              // Main Action Button
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : () => _handleMainAction(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isEnrolled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isProcessing
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: widget.isEnrolled
                                  ? 'play_arrow'
                                  : 'shopping_cart',
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              widget.isEnrolled
                                  ? 'Continue Learning'
                                  : 'Enroll Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(width: 3.w),

              // Voice Command Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => _handleVoiceCommand(),
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: Colors.white,
                    size: 24,
                  ),
                  tooltip: widget.isEnrolled
                      ? 'Say "Continue learning"'
                      : 'Say "Enroll me"',
                ),
              ),

              SizedBox(width: 2.w),

              // Share Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => _handleShare(),
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                  tooltip: 'Share course',
                ),
              ),
            ],
          ),

          // Voice Command Hints
          SizedBox(height: 2.h),

          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    widget.isEnrolled
                        ? 'Try: "Continue learning" or "Show my progress"'
                        : 'Try: "Enroll me in this course" or "What\'s included?"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      {'icon': 'video_library', 'text': 'Lifetime access to course content'},
      {'icon': 'download', 'text': 'Downloadable resources and code'},
      {'icon': 'certificate', 'text': 'Certificate of completion'},
      {'icon': 'support', 'text': '24/7 instructor support'},
      {'icon': 'mobile_friendly', 'text': 'Access on mobile and desktop'},
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: feature['icon'] as String,
                color: Colors.green,
                size: 16,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  feature['text'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progress = widget.courseData["progress"] as double? ?? 0.0;
    final completedLessons = widget.courseData["completedLessons"] as int? ?? 0;
    final totalLessons = widget.courseData["totalLessons"] as int? ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '$completedLessons of $totalLessons lessons completed',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  void _handleMainAction() {
    setState(() {
      isProcessing = true;
    });

    // Simulate processing delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        if (widget.isEnrolled) {
          widget.onContinue();
        } else {
          widget.onEnroll();
        }
      }
    });
  }

  void _handleVoiceCommand() {
    // Voice command functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEnrolled
              ? 'Listening for "Continue learning" command...'
              : 'Listening for enrollment command...',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleShare() {
    // Share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
