import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseHeroSection extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final VoidCallback onPlayPreview;

  const CourseHeroSection({
    super.key,
    required this.courseData,
    required this.onPlayPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Hero Image
          CustomImageWidget(
            imageUrl: courseData["heroImage"] as String,
            width: double.infinity,
            height: 35.h,
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                Text(
                  courseData["title"] as String,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Course Subtitle
                Text(
                  courseData["subtitle"] as String,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                // Action Buttons Row
                Row(
                  children: [
                    // Preview Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onPlayPreview,
                        icon: CustomIconWidget(
                          iconName: 'play_arrow',
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Voice Assistant Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Voice assistant functionality
                        },
                        icon: CustomIconWidget(
                          iconName: 'mic',
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: 'Ask about this course',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
