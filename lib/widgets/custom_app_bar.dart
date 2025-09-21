import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Conversational Minimalism design
/// Optimized for voice-first educational applications with clean, uncluttered interface
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final AppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.variant = AppBarVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: _getTitleStyle(theme, variant),
      ),
      actions: _buildActions(context),
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ?? _getBackgroundColor(colorScheme, variant),
      foregroundColor:
          foregroundColor ?? _getForegroundColor(colorScheme, variant),
      elevation: _getElevation(variant),
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColor(colorScheme, variant),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColor(colorScheme, variant),
        size: 24,
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return [
      ...actions!,
      const SizedBox(width: 8), // Padding for thumb accessibility
    ];
  }

  TextStyle _getTitleStyle(ThemeData theme, AppBarVariant variant) {
    switch (variant) {
      case AppBarVariant.large:
        return GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        );
      case AppBarVariant.medium:
        return GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        );
      case AppBarVariant.small:
        return GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        );
      case AppBarVariant.standard:
      default:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        );
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme, AppBarVariant variant) {
    switch (variant) {
      case AppBarVariant.transparent:
        return Colors.transparent;
      case AppBarVariant.primary:
        return colorScheme.primary;
      case AppBarVariant.surface:
      case AppBarVariant.standard:
      case AppBarVariant.large:
      case AppBarVariant.medium:
      case AppBarVariant.small:
      default:
        return colorScheme.surface;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme, AppBarVariant variant) {
    switch (variant) {
      case AppBarVariant.primary:
        return colorScheme.onPrimary;
      case AppBarVariant.transparent:
      case AppBarVariant.surface:
      case AppBarVariant.standard:
      case AppBarVariant.large:
      case AppBarVariant.medium:
      case AppBarVariant.small:
      default:
        return colorScheme.onSurface;
    }
  }

  double _getElevation(AppBarVariant variant) {
    switch (variant) {
      case AppBarVariant.transparent:
        return 0;
      case AppBarVariant.large:
        return 4;
      case AppBarVariant.primary:
      case AppBarVariant.surface:
      case AppBarVariant.standard:
      case AppBarVariant.medium:
      case AppBarVariant.small:
      default:
        return elevation;
    }
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }

    switch (variant) {
      case AppBarVariant.large:
        height = kToolbarHeight + 32;
        break;
      case AppBarVariant.medium:
        height = kToolbarHeight + 16;
        break;
      case AppBarVariant.small:
        height = kToolbarHeight - 8;
        break;
      default:
        break;
    }

    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }

    return Size.fromHeight(height);
  }
}

/// Enum defining different AppBar variants for educational contexts
enum AppBarVariant {
  /// Standard app bar for general use
  standard,

  /// Large app bar for main sections
  large,

  /// Medium app bar for sub-sections
  medium,

  /// Small app bar for detailed views
  small,

  /// Primary colored app bar for emphasis
  primary,

  /// Surface colored app bar (default)
  surface,

  /// Transparent app bar for overlay contexts
  transparent,
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Conversational Minimalism design philosophy
/// Optimized for voice-first educational mobile applications with clean spatial hierarchy
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with search functionality for course discovery
  search,

  /// Minimal app bar for distraction-free learning sessions
  minimal,

  /// App bar with voice activation indicator
  voiceActive,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.onSearchChanged,
    this.searchController,
    this.showBackButton = true,
    this.centerTitle = false,
    this.isVoiceActive = false,
  });

  /// The title to display in the app bar
  final String title;

  /// The variant of the app bar to display
  final CustomAppBarVariant variant;

  /// Optional actions to display on the right side
  final List<Widget>? actions;

  /// Optional leading widget (overrides back button)
  final Widget? leading;

  /// Callback for search text changes (required for search variant)
  final ValueChanged<String>? onSearchChanged;

  /// Controller for search input (required for search variant)
  final TextEditingController? searchController;

  /// Whether to show the back button
  final bool showBackButton;

  /// Whether to center the title
  final bool centerTitle;

  /// Whether voice is currently active (for voice variant)
  final bool isVoiceActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.voiceActive:
        return _buildVoiceActiveAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.standard:
      default:
        return _buildStandardAppBar(context, theme, colorScheme);
    }
  }

  /// Build standard app bar with title and actions
  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions ?? _buildDefaultActions(context, colorScheme),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  /// Build search app bar with search input field
  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Search courses...',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: searchController?.text.isNotEmpty == true
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      searchController?.clear();
                      onSearchChanged?.call('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: colorScheme.onSurface,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            )
          : null,
      actions: actions,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  /// Build minimal app bar for distraction-free learning
  Widget _buildMinimalAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface.withValues(alpha: 0.8),
          letterSpacing: -0.1,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  /// Build voice active app bar with pulse animation
  Widget _buildVoiceActiveAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Row(
        children: [
          if (isVoiceActive) ...[
            _VoicePulseIndicator(color: colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              isVoiceActive ? 'Listening...' : title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:
                    isVoiceActive ? colorScheme.primary : colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions ?? _buildVoiceActions(context, colorScheme),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  /// Build default actions for standard app bar
  List<Widget> _buildDefaultActions(
      BuildContext context, ColorScheme colorScheme) {
    return [
      IconButton(
        icon: Icon(
          Icons.search,
          color: colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Navigator.pushNamed(context, '/course-catalog'),
        tooltip: 'Search',
      ),
      IconButton(
        icon: Icon(
          Icons.account_circle_outlined,
          color: colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Navigator.pushNamed(context, '/login-screen'),
        tooltip: 'Profile',
      ),
    ];
  }

  /// Build voice-specific actions
  List<Widget> _buildVoiceActions(
      BuildContext context, ColorScheme colorScheme) {
    return [
      IconButton(
        icon: Icon(
          isVoiceActive ? Icons.mic : Icons.mic_none,
          color: isVoiceActive ? colorScheme.primary : colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          // Voice activation logic would go here
        },
        tooltip: isVoiceActive ? 'Stop listening' : 'Start voice',
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Voice pulse animation indicator for active listening states
class _VoicePulseIndicator extends StatefulWidget {
  const _VoicePulseIndicator({required this.color});

  final Color color;

  @override
  State<_VoicePulseIndicator> createState() => _VoicePulseIndicatorState();
}

class _VoicePulseIndicatorState extends State<_VoicePulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: _animation.value),
          ),
        );
      },
    );
  }
}
