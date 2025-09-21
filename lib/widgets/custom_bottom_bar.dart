import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget optimized for voice-first educational applications
/// Implements thumb accessibility and gesture-based navigation patterns
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BottomBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomBarVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems(context);

    switch (variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, colorScheme, items);
      case BottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, colorScheme, items);
    }
  }

  Widget _buildStandardBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
    List<BottomNavigationBarItem> items,
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
      items: items,
    );
  }

  Widget _buildFloatingBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
    List<BottomNavigationBarItem> items,
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
          items: items,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: _buildIcon(Icons.dashboard_outlined, 0),
        activeIcon: _buildIcon(Icons.dashboard, 0),
        label: 'Dashboard',
        tooltip: 'Voice Dashboard - Main learning hub',
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(Icons.book_outlined, 1),
        activeIcon: _buildIcon(Icons.book, 1),
        label: 'Courses',
        tooltip: 'Course Detail - Browse learning content',
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(Icons.schedule_outlined, 2),
        activeIcon: _buildIcon(Icons.schedule, 2),
        label: 'Schedule',
        tooltip: 'Schedule Manager - Plan your learning',
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(Icons.analytics_outlined, 3),
        activeIcon: _buildIcon(Icons.analytics, 3),
        label: 'Progress',
        tooltip: 'Progress Analytics - Track your growth',
      ),
    ];
  }

  Widget _buildIcon(IconData iconData, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(4),
      decoration: currentIndex == index
          ? BoxDecoration(
              color: selectedItemColor?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Icon(
        iconData,
        size: 24,
      ),
    );
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

/// Enum defining different BottomBar variants for educational contexts
enum BottomBarVariant {
  /// Standard bottom navigation bar
  standard,

  /// Floating bottom navigation bar with rounded corners
  floating,
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Conversational Minimalism design philosophy
/// Context-sensitive navigation that appears based on voice commands and user interaction patterns
enum CustomBottomBarVariant {
  /// Standard bottom navigation with fixed items
  standard,

  /// Adaptive navigation that shows/hides based on context
  adaptive,

  /// Voice-optimized navigation with larger touch targets
  voiceOptimized,
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.isVisible = true,
    this.hasVoiceIndicator = false,
  });

  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// The variant of the bottom bar to display
  final CustomBottomBarVariant variant;

  /// Whether the bottom bar is visible (for adaptive variant)
  final bool isVisible;

  /// Whether to show voice activity indicator
  final bool hasVoiceIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isVisible && variant == CustomBottomBarVariant.adaptive) {
      return const SizedBox.shrink();
    }

    switch (variant) {
      case CustomBottomBarVariant.adaptive:
        return _buildAdaptiveBottomBar(context, theme, colorScheme);
      case CustomBottomBarVariant.voiceOptimized:
        return _buildVoiceOptimizedBottomBar(context, theme, colorScheme);
      case CustomBottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, theme, colorScheme);
    }
  }

  /// Build standard bottom navigation bar
  Widget _buildStandardBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          items: _buildNavigationItems(colorScheme),
        ),
      ),
    );
  }

  /// Build adaptive bottom navigation bar with context sensitivity
  Widget _buildAdaptiveBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
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
            onTap: _handleTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor:
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
            items: _buildNavigationItems(colorScheme),
          ),
        ),
      ),
    );
  }

  /// Build voice-optimized bottom navigation with larger touch targets
  Widget _buildVoiceOptimizedBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surface,
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

  /// Build navigation items for standard and adaptive variants
  List<BottomNavigationBarItem> _buildNavigationItems(ColorScheme colorScheme) {
    return [
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 24,
            ),
            if (hasVoiceIndicator && currentIndex == 0)
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
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 1 ? Icons.school : Icons.school_outlined,
          size: 24,
        ),
        label: 'Courses',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline,
          size: 24,
        ),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 3 ? Icons.person : Icons.person_outline,
          size: 24,
        ),
        label: 'Profile',
      ),
    ];
  }

  /// Build voice-optimized navigation items with larger touch targets
  List<Widget> _buildVoiceOptimizedItems(
      BuildContext context, ColorScheme colorScheme) {
    final items = [
      _VoiceOptimizedNavItem(
        icon: Icons.home,
        outlinedIcon: Icons.home_outlined,
        label: 'Home',
        isSelected: currentIndex == 0,
        onTap: () => _handleTap(0),
        colorScheme: colorScheme,
        hasIndicator: hasVoiceIndicator && currentIndex == 0,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.school,
        outlinedIcon: Icons.school_outlined,
        label: 'Courses',
        isSelected: currentIndex == 1,
        onTap: () => _handleTap(1),
        colorScheme: colorScheme,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.chat_bubble,
        outlinedIcon: Icons.chat_bubble_outline,
        label: 'Chat',
        isSelected: currentIndex == 2,
        onTap: () => _handleTap(2),
        colorScheme: colorScheme,
      ),
      _VoiceOptimizedNavItem(
        icon: Icons.person,
        outlinedIcon: Icons.person_outline,
        label: 'Profile',
        isSelected: currentIndex == 3,
        onTap: () => _handleTap(3),
        colorScheme: colorScheme,
      ),
    ];

    return items;
  }

  /// Handle navigation tap with route navigation
  void _handleTap(int index) {
    onTap(index);

    // Navigate to appropriate routes based on index
    // This is a simplified navigation - in a real app, you'd use a more sophisticated routing system
    final context = navigatorKey.currentContext;
    if (context == null) return;

    switch (index) {
      case 0:
        // Home - typically would stay on current route or navigate to home
        break;
      case 1:
        Navigator.pushNamed(context, '/course-catalog');
        break;
      case 2:
        // Chat - would navigate to chat screen
        break;
      case 3:
        Navigator.pushNamed(context, '/login-screen');
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

/// Global navigator key for navigation from static contexts
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
