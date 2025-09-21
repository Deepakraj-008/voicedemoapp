import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget optimized for voice-first educational applications
/// Implements thumb accessibility and gesture-based navigation patterns with conversational minimalism design
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BottomBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final bool isVisible;
  final bool hasVoiceIndicator;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomBarVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.isVisible = true,
    this.hasVoiceIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isVisible && variant == BottomBarVariant.adaptive) {
      return const SizedBox.shrink();
    }

    switch (variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, colorScheme);
      case BottomBarVariant.adaptive:
        return _buildAdaptiveBottomBar(context, theme, colorScheme);
      case BottomBarVariant.voiceOptimized:
        return _buildVoiceOptimizedBottomBar(context, theme, colorScheme);
      case BottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      unselectedItemColor:
          unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: elevation,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      items: _getNavigationItems(context, colorScheme),
    );
  }

  Widget _buildFloatingBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor: unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6),
          elevation: 0,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: _getNavigationItems(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildAdaptiveBottomBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _handleNavigation(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: selectedItemColor ?? colorScheme.primary,
            unselectedItemColor: unselectedItemColor ??
                colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            items: _getNavigationItems(context, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceOptimizedBottomBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildVoiceOptimizedItems(context, colorScheme),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return [
      BottomNavigationBarItem(
        icon: _buildIconWithIndicator(
          Icons.dashboard_outlined,
          Icons.dashboard,
          0,
          colorScheme,
        ),
        activeIcon: _buildIconWithIndicator(
          Icons.dashboard,
          Icons.dashboard,
          0,
          colorScheme,
        ),
        label: 'Dashboard',
        tooltip: 'Voice Dashboard - Main learning hub',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithIndicator(
          Icons.book_outlined,
          Icons.book,
          1,
          colorScheme,
        ),
        activeIcon: _buildIconWithIndicator(
          Icons.book,
          Icons.book,
          1,
          colorScheme,
        ),
        label: 'Courses',
        tooltip: 'Course Detail - Browse learning content',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithIndicator(
          Icons.schedule_outlined,
          Icons.schedule,
          2,
          colorScheme,
        ),
        activeIcon: _buildIconWithIndicator(
          Icons.schedule,
          Icons.schedule,
          2,
          colorScheme,
        ),
        label: 'Schedule',
        tooltip: 'Schedule Manager - Plan your learning',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithIndicator(
          Icons.analytics_outlined,
          Icons.analytics,
          3,
          colorScheme,
        ),
        activeIcon: _buildIconWithIndicator(
          Icons.analytics,
          Icons.analytics,
          3,
          colorScheme,
        ),
        label: 'Progress',
        tooltip: 'Progress Analytics - Track your growth',
      ),
    ];
  }

  Widget _buildIconWithIndicator(
    IconData iconData,
    IconData activeIconData,
    int index,
    ColorScheme colorScheme,
  ) {
    final isSelected = currentIndex == index;
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(4),
          decoration: isSelected
              ? BoxDecoration(
                  color: selectedItemColor?.withValues(alpha: 0.1) ??
                      colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Icon(
            isSelected ? activeIconData : iconData,
            size: 24,
            color: isSelected
                ? selectedItemColor ?? colorScheme.primary
                : unselectedItemColor ??
                    colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (hasVoiceIndicator && index == 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildVoiceOptimizedItems(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final items = [
      _VoiceOptimizedNavItem(
        icon: Icons.home,
        outlinedIcon: Icons.home_outlined,
        label: 'Home',
        isSelected: currentIndex == 0,
        onTap: () => _handleNavigation(context, 0),
        colorScheme: colorScheme,
        hasIndicator: hasVoiceIndicator && currentIndex == 0,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.school,
        outlinedIcon: Icons.school_outlined,
        label: 'Courses',
        isSelected: currentIndex == 1,
        onTap: () => _handleNavigation(context, 1),
        colorScheme: colorScheme,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.chat_bubble,
        outlinedIcon: Icons.chat_bubble_outline,
        label: 'Chat',
        isSelected: currentIndex == 2,
        onTap: () => _handleNavigation(context, 2),
        colorScheme: colorScheme,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.person,
        outlinedIcon: Icons.person_outline,
        label: 'Profile',
        isSelected: currentIndex == 3,
        onTap: () => _handleNavigation(context, 3),
        colorScheme: colorScheme,
      ),
    ];

    return items;
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    onTap(index);

    // Navigate to corresponding routes
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/voice-dashboard',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/course-detail',
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/schedule-manager',
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/progress-analytics',
          (route) => false,
        );
        break;
    }
  }
}

/// Voice-optimized navigation item with larger touch targets
class _VoiceOptimizedNavItem extends StatelessWidget {
  const _VoiceOptimizedNavItem({
    required this.icon,
    required this.outlinedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    this.hasIndicator = false,
  });

  final IconData icon;
  final IconData outlinedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool hasIndicator;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Icon(
                    isSelected ? icon : outlinedIcon,
                    size: 28,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  if (hasIndicator)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Enum defining different BottomBar variants for educational contexts
enum BottomBarVariant {
  /// Standard bottom navigation bar
  standard,

  /// Floating bottom navigation bar with rounded corners
  floating,

  /// Adaptive navigation that shows/hides based on context
  adaptive,

  /// Voice-optimized navigation with larger touch targets
  voiceOptimized,
}
