import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillRadarChart extends StatefulWidget {
  final List<Map<String, dynamic>> skillData;

  const SkillRadarChart({
    super.key,
    required this.skillData,
  });

  @override
  State<SkillRadarChart> createState() => _SkillRadarChartState();
}

class _SkillRadarChartState extends State<SkillRadarChart> {
  int selectedDataSetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skill Assessment',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
              GestureDetector(
                onTap: () => _showSkillDetails(context),
                child: CustomIconWidget(
                  iconName: 'info_outline',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: RadarChart(
              RadarChartData(
                radarTouchData: RadarTouchData(enabled: false),
                dataSets: [
                  RadarDataSet(
                    fillColor: colorScheme.primary.withValues(alpha: 0.2),
                    borderColor: colorScheme.primary,
                    entryRadius: 3,
                    dataEntries: widget.skillData.map((skill) {
                      return RadarEntry(
                          value: (skill['level'] as num).toDouble());
                    }).toList(),
                    borderWidth: 2,
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                getTitle: (index, angle) {
                  if (index < widget.skillData.length) {
                    return RadarChartTitle(
                      text: widget.skillData[index]['skill'] as String,
                      angle: angle,
                    );
                  }
                  return const RadarChartTitle(text: '');
                },
                tickCount: 5,
                ticksTextStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 8.sp,
                ),
                tickBorderData: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
                gridBorderData: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          _buildSkillLegend(context),
        ],
      ),
    );
  }

  Widget _buildSkillLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: widget.skillData.asMap().entries.map((entry) {
        final index = entry.key;
        final skill = entry.value;
        final level = skill['level'] as num;
        final skillName = skill['skill'] as String;
        final improvement = skill['improvement'] as num;

        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: _getSkillColor(index),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Level ${level.toInt()}/10',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: improvement >= 0
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName:
                          improvement >= 0 ? 'trending_up' : 'trending_down',
                      color: improvement >= 0
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${improvement >= 0 ? '+' : ''}${improvement.toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: improvement >= 0
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getSkillColor(int index) {
    final colors = [
      AppTheme.primaryLight,
      AppTheme.secondaryLight,
      AppTheme.accentLight,
      AppTheme.warningLight,
      AppTheme.successLight,
    ];
    return colors[index % colors.length];
  }

  void _showSkillDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Skill Assessment Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: widget.skillData.length,
                itemBuilder: (context, index) {
                  final skill = widget.skillData[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              skill['skill'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            Text(
                              '${skill['level']}/10',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: _getSkillColor(index),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        LinearProgressIndicator(
                          value: (skill['level'] as num) / 10,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _getSkillColor(index)),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          skill['description'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 11.sp,
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
