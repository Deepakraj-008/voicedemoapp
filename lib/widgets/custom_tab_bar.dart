import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom TabBar widget implementing educational content navigation
/// Optimized for voice-first learning applications with clear visual hierarchy
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final Function(int)? onTap;
  final TabBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.variant = TabBarVariant.standard,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ?? _getBackgroundColor(colorScheme, variant),
      padding: padding ?? _getPadding(variant),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: _buildTabs(context),
        isScrollable: isScrollable,
        labelColor: selectedColor ?? _getSelectedColor(colorScheme, variant),
        unselectedLabelColor:
            unselectedColor ?? _getUnselectedColor(colorScheme, variant),
        indicatorColor:
            indicatorColor ?? _getIndicatorColor(colorScheme, variant),
        indicatorWeight: _getIndicatorWeight(variant),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: _getLabelStyle(variant, true),
        unselectedLabelStyle: _getLabelStyle(variant, false),
        indicator: _buildIndicator(colorScheme, variant),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    return tabs.map((tabText) {
      final index = tabs.indexOf(tabText);

      switch (variant) {
        case TabBarVariant.chip:
          return _buildChipTab(context, tabText, index);
        case TabBarVariant.segmented:
          return _buildSegmentedTab(context, tabText, index);
        case TabBarVariant.standard:
        case TabBarVariant.underlined:
        case TabBarVariant.rounded:
        default:
          return _buildStandardTab(context, tabText);
      }
    }).toList();
  }

  Widget _buildStandardTab(BuildContext context, String text) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildChipTab(BuildContext context, String text, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = controller?.index == index;

    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? colorScheme.primary).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? colorScheme.primary)
                : (unselectedColor ?? colorScheme.outline),
            width: 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildSegmentedTab(BuildContext context, String text, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = controller?.index == index;

    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: isSelected
                ? colorScheme.onPrimary
                : (unselectedColor ?? colorScheme.onSurface),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme, TabBarVariant variant) {
    switch (variant) {
      case TabBarVariant.segmented:
        return colorScheme.surface;
      case TabBarVariant.chip:
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      case TabBarVariant.rounded:
      default:
        return Colors.transparent;
    }
  }

  Color _getSelectedColor(ColorScheme colorScheme, TabBarVariant variant) {
    return colorScheme.primary;
  }

  Color _getUnselectedColor(ColorScheme colorScheme, TabBarVariant variant) {
    return colorScheme.onSurface.withValues(alpha: 0.6);
  }

  Color _getIndicatorColor(ColorScheme colorScheme, TabBarVariant variant) {
    switch (variant) {
      case TabBarVariant.chip:
      case TabBarVariant.segmented:
        return Colors.transparent;
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      case TabBarVariant.rounded:
      default:
        return colorScheme.primary;
    }
  }

  double _getIndicatorWeight(TabBarVariant variant) {
    switch (variant) {
      case TabBarVariant.chip:
      case TabBarVariant.segmented:
        return 0;
      case TabBarVariant.underlined:
        return 3;
      case TabBarVariant.standard:
      case TabBarVariant.rounded:
      default:
        return 2;
    }
  }

  EdgeInsetsGeometry _getPadding(TabBarVariant variant) {
    switch (variant) {
      case TabBarVariant.segmented:
        return const EdgeInsets.all(4);
      case TabBarVariant.chip:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      case TabBarVariant.rounded:
      default:
        return EdgeInsets.zero;
    }
  }

  TextStyle _getLabelStyle(TabBarVariant variant, bool isSelected) {
    switch (variant) {
      case TabBarVariant.chip:
        return GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        );
      case TabBarVariant.segmented:
        return GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      case TabBarVariant.rounded:
      default:
        return GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        );
    }
  }

  Decoration? _buildIndicator(ColorScheme colorScheme, TabBarVariant variant) {
    switch (variant) {
      case TabBarVariant.rounded:
        return BoxDecoration(
          color: indicatorColor ?? colorScheme.primary,
          borderRadius: BorderRadius.circular(4),
        );
      case TabBarVariant.chip:
      case TabBarVariant.segmented:
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      default:
        return null;
    }
  }

  @override
  Size get preferredSize {
    switch (variant) {
      case TabBarVariant.chip:
        return const Size.fromHeight(56);
      case TabBarVariant.segmented:
        return const Size.fromHeight(52);
      case TabBarVariant.standard:
      case TabBarVariant.underlined:
      case TabBarVariant.rounded:
      default:
        return const Size.fromHeight(48);
    }
  }
}

/// Enum defining different TabBar variants for educational contexts
enum TabBarVariant {
  /// Standard tab bar with underline indicator
  standard,

  /// Tab bar with prominent underline
  underlined,

  /// Tab bar with rounded indicator
  rounded,

  /// Chip-style tabs with borders
  chip,

  /// Segmented control style tabs
  segmented,
}
