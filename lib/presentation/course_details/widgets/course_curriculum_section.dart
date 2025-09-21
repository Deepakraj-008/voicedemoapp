import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CourseCurriculumSection extends StatefulWidget {
  final List<Map<String, dynamic>> modules;

  const CourseCurriculumSection({
    super.key,
    required this.modules,
  });

  @override
  State<CourseCurriculumSection> createState() =>
      _CourseCurriculumSectionState();
}

class _CourseCurriculumSectionState extends State<CourseCurriculumSection> {
  Set<int> expandedModules = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'menu_book',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),

              SizedBox(width: 2.w),

              Text(
                'Course Curriculum',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              Spacer(),

              // Voice Command Hint
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'mic',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Say "Module 1"',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Modules List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.modules.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final module = widget.modules[index];
              final isExpanded = expandedModules.contains(index);

              return _buildModuleCard(context, module, index, isExpanded);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    Map<String, dynamic> module,
    int index,
    bool isExpanded,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Module Header
          InkWell(
            onTap: () {
              setState(() {
                isExpanded
                    ? expandedModules.remove(index)
                    : expandedModules.add(index);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Module Number
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Module Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module["title"] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'play_circle_outline',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${module["lessonCount"]} lessons',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(width: 3.w),
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              module["duration"] as String,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Expand Icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: isExpanded ? null : 0,
            child: isExpanded ? _buildModuleLessons(context, module) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleLessons(
      BuildContext context, Map<String, dynamic> module) {
    final lessons = (module["lessons"] as List).cast<Map<String, dynamic>>();

    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        children: [
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: lessons.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final lesson = lessons[index];

              return Row(
                children: [
                  // Lesson Icon
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomIconWidget(
                      iconName: lesson["type"] == "video"
                          ? 'play_circle_outline'
                          : 'article',
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Lesson Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson["title"] as String,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          lesson["duration"] as String,
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
                  ),

                  // Preview Button
                  if (lesson["hasPreview"] == true)
                    TextButton(
                      onPressed: () {
                        // Preview lesson functionality
                      },
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
