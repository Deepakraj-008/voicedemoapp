import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseReviewsSection extends StatefulWidget {
  final Map<String, dynamic> reviewData;

  const CourseReviewsSection({
    super.key,
    required this.reviewData,
  });

  @override
  State<CourseReviewsSection> createState() => _CourseReviewsSectionState();
}

class _CourseReviewsSectionState extends State<CourseReviewsSection> {
  String? playingAudioId;

  @override
  Widget build(BuildContext context) {
    final reviews =
        (widget.reviewData["reviews"] as List).cast<Map<String, dynamic>>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Student Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Rating Summary
          Row(
            children: [
              Text(
                widget.reviewData["averageRating"].toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(width: 2.w),
              _buildStarRating(widget.reviewData["averageRating"] as double),
              SizedBox(width: 2.w),
              Text(
                '(${widget.reviewData["totalReviews"]} reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Reviews List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewCard(context, review);
            },
          ),

          SizedBox(height: 2.h),

          // View All Reviews Button
          Center(
            child: OutlinedButton(
              onPressed: () {
                // Navigate to all reviews screen
              },
              child: Text('View All Reviews'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final hasAudio = review["audioReview"] != null;
    final isPlaying = playingAudioId == review["id"];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 5.w,
                child: CustomImageWidget(
                  imageUrl: review["userAvatar"] as String,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 3.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["userName"] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: [
                        _buildStarRating(review["rating"] as double),
                        SizedBox(width: 2.w),
                        Text(
                          review["date"] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Audio Review Button
              if (hasAudio)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => _toggleAudioReview(review["id"] as String),
                    icon: CustomIconWidget(
                      iconName: isPlaying ? 'pause' : 'play_arrow',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    ),
                    tooltip:
                        isPlaying ? 'Pause audio review' : 'Play audio review',
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Review Text
          Text(
            review["comment"] as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          // Audio Review Indicator
          if (hasAudio && isPlaying)
            Container(
              margin: EdgeInsets.only(top: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'volume_up',
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Playing audio review...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating.floor()
              ? 'star'
              : index < rating
                  ? 'star_half'
                  : 'star_border',
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void _toggleAudioReview(String reviewId) {
    setState(() {
      playingAudioId = playingAudioId == reviewId ? null : reviewId;
    });

    // Here you would implement actual audio playback functionality
    // For now, we'll simulate it with a timer
    if (playingAudioId == reviewId) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && playingAudioId == reviewId) {
          setState(() {
            playingAudioId = null;
          });
        }
      });
    }
  }
}
