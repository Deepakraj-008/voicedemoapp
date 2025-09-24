import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// 3D Animated filter chips for sports filtering with smooth animations
class SportsFilterChips extends StatefulWidget {
  final List<String> categories;
  final List<String> formats;
  final List<String> priorities;
  final String? selectedCategory;
  final String? selectedFormat;
  final String? selectedPriority;
  final Function(String?)? onCategoryChanged;
  final Function(String?)? onFormatChanged;
  final Function(String?)? onPriorityChanged;
  final bool showCategoryFilter;
  final bool showFormatFilter;
  final bool showPriorityFilter;
  final Color activeColor;
  final Color inactiveColor;
  final double chipHeight;
  final double chipSpacing;
  final bool enable3DEffects;

  const SportsFilterChips({
    Key? key,
    this.categories = const [
      'All',
      'Cricket',
      'Football',
      'Basketball',
      'Tennis',
      'Baseball',
      'Hockey'
    ],
    this.formats = const ['All', 'Test', 'ODI', 'T20', 'League', 'Cup'],
    this.priorities = const ['All', 'Live', 'Upcoming', 'Recent', 'Popular'],
    this.selectedCategory,
    this.selectedFormat,
    this.selectedPriority,
    this.onCategoryChanged,
    this.onFormatChanged,
    this.onPriorityChanged,
    this.showCategoryFilter = true,
    this.showFormatFilter = true,
    this.showPriorityFilter = true,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.chipHeight = 40,
    this.chipSpacing = 8,
    this.enable3DEffects = true,
  }) : super(key: key);

  @override
  State<SportsFilterChips> createState() => _SportsFilterChipsState();
}

class _SportsFilterChipsState extends State<SportsFilterChips>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;

  String? _selectedCategory;
  String? _selectedFormat;
  String? _selectedPriority;

  final Map<String, GlobalKey> _chipKeys = {};
  final Map<String, Animation<double>> _individualAnimations = {};

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.selectedCategory;
    _selectedFormat = widget.selectedFormat;
    _selectedPriority = widget.selectedPriority;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeAnimations();

    // Initialize individual chip animations
    _initializeChipAnimations();
  }

  void _initializeAnimations() {
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: math.pi * 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );
  }

  void _initializeChipAnimations() {
    final allOptions = [
      ...widget.categories,
      ...widget.formats,
      ...widget.priorities,
    ];

    for (final option in allOptions) {
      final chipController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );

      _individualAnimations[option] =
          Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: chipController,
          curve: Curves.easeOutBack,
        ),
      );

      _chipKeys[option] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final animation in _individualAnimations.values) {
      (animation as Animation<double>).removeStatusListener((status) {});
    }
    super.dispose();
  }

  void _handleChipTap(String value, String filterType) {
    _controller.forward().then((_) {
      _controller.reverse();
    });

    setState(() {
      switch (filterType) {
        case 'category':
          _selectedCategory = _selectedCategory == value ? null : value;
          widget.onCategoryChanged?.call(_selectedCategory);
          break;
        case 'format':
          _selectedFormat = _selectedFormat == value ? null : value;
          widget.onFormatChanged?.call(_selectedFormat);
          break;
        case 'priority':
          _selectedPriority = _selectedPriority == value ? null : value;
          widget.onPriorityChanged?.call(_selectedPriority);
          break;
      }
    });
  }

  Color _getChipColor(bool isSelected, String filterType) {
    if (isSelected) {
      switch (filterType) {
        case 'category':
          return widget.activeColor;
        case 'format':
          return Colors.orange;
        case 'priority':
          return Colors.purple;
        default:
          return widget.activeColor;
      }
    }
    return widget.inactiveColor;
  }

  IconData _getChipIcon(String value, String filterType) {
    switch (filterType) {
      case 'category':
        switch (value.toLowerCase()) {
          case 'cricket':
            return Icons.sports_cricket;
          case 'football':
          case 'soccer':
            return Icons.sports_soccer;
          case 'basketball':
            return Icons.sports_basketball;
          case 'tennis':
            return Icons.sports_tennis;
          case 'baseball':
            return Icons.sports_baseball;
          case 'hockey':
            return Icons.sports_hockey;
          case 'volleyball':
            return Icons.sports_volleyball;
          case 'rugby':
            return Icons.sports_rugby;
          default:
            return Icons.sports;
        }
      case 'format':
        switch (value.toLowerCase()) {
          case 'test':
            return Icons.hourglass_empty;
          case 'odi':
          case 't20':
            return Icons.timer;
          case 'league':
            return Icons.format_list_numbered;
          case 'cup':
            return Icons.emoji_events;
          default:
            return Icons.format_shapes;
        }
      case 'priority':
        switch (value.toLowerCase()) {
          case 'live':
            return Icons.circle;
          case 'upcoming':
            return Icons.schedule;
          case 'recent':
            return Icons.history;
          case 'popular':
            return Icons.trending_up;
          default:
            return Icons.filter_list;
        }
      default:
        return Icons.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showCategoryFilter) ...[
          _buildFilterSection(
            'Sports',
            widget.categories,
            _selectedCategory,
            'category',
          ),
          SizedBox(height: widget.chipSpacing),
        ],
        if (widget.showFormatFilter) ...[
          _buildFilterSection(
            'Format',
            widget.formats,
            _selectedFormat,
            'format',
          ),
          SizedBox(height: widget.chipSpacing),
        ],
        if (widget.showPriorityFilter) ...[
          _buildFilterSection(
            'Priority',
            widget.priorities,
            _selectedPriority,
            'priority',
          ),
        ],
      ],
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String? selectedValue, String filterType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: widget.chipHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedValue == option;

              return Padding(
                padding: EdgeInsets.only(right: widget.chipSpacing),
                child: _build3DChip(option, isSelected, filterType),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _build3DChip(String label, bool isSelected, String filterType) {
    final chipColor = _getChipColor(isSelected, filterType);
    final icon = _getChipIcon(label, filterType);

    return GestureDetector(
      onTap: () => _handleChipTap(label, filterType),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _individualAnimations[label] ?? AlwaysStoppedAnimation(1.0)
        ]),
        builder: (context, child) {
          final scale = isSelected ? _scaleAnimation.value : 1.0;
          final elevation = isSelected ? _elevationAnimation.value : 2.0;
          final glowIntensity = isSelected ? _glowAnimation.value : 0.0;
          final rotation = widget.enable3DEffects && isSelected
              ? _rotationAnimation.value
              : 0.0;

          return Transform.scale(
            scale: scale,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotation),
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      chipColor.withOpacity(0.9),
                      chipColor.withOpacity(0.7),
                      chipColor.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: chipColor.withOpacity(isSelected ? 0.8 : 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: chipColor.withOpacity(glowIntensity * 0.4),
                      blurRadius: 15 + (10 * glowIntensity),
                      spreadRadius: 2 + (3 * glowIntensity),
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: elevation.toDouble(),
                      spreadRadius: -2,
                      offset: Offset(0, elevation.toDouble()),
                    ),
                    if (widget.enable3DEffects)
                      BoxShadow(
                        color: chipColor.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Advanced filter panel with collapsible sections and search
class AdvancedSportsFilterPanel extends StatefulWidget {
  final List<String> sports;
  final List<String> formats;
  final List<String> statuses;
  final List<String> venues;
  final List<String> teams;
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final bool enableSearch;
  final double maxHeight;

  const AdvancedSportsFilterPanel({
    Key? key,
    this.sports = const [],
    this.formats = const [],
    this.statuses = const [],
    this.venues = const [],
    this.teams = const [],
    this.initialFilters = const {},
    required this.onFiltersChanged,
    this.enableSearch = true,
    this.maxHeight = 400,
  }) : super(key: key);

  @override
  State<AdvancedSportsFilterPanel> createState() =>
      _AdvancedSportsFilterPanelState();
}

class _AdvancedSportsFilterPanelState extends State<AdvancedSportsFilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic> _currentFilters = {};
  TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _currentFilters = Map.from(widget.initialFilters);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleFilterChange(String key, dynamic value) {
    setState(() {
      _currentFilters[key] = value;
    });
    widget.onFiltersChanged(_currentFilters);
  }

  void _clearFilters() {
    setState(() {
      _currentFilters.clear();
      _searchController.clear();
      _searchQuery = '';
    });
    widget.onFiltersChanged(_currentFilters);
  }

  List<String> _filterOptions(List<String> options) {
    if (_searchQuery.isEmpty) return options;

    return options
        .where((option) =>
            option.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
        border: Border.all(
          color: Colors.grey.shade700,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (widget.enableSearch) _buildSearchField(),
                      if (widget.sports.isNotEmpty) ...[
                        _buildFilterSection(
                            'Sports', widget.sports, 'sport', Icons.sports),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                      if (widget.formats.isNotEmpty) ...[
                        _buildFilterSection('Format', widget.formats, 'format',
                            Icons.format_shapes),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                      if (widget.statuses.isNotEmpty) ...[
                        _buildFilterSection(
                            'Status', widget.statuses, 'status', Icons.info),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                      if (widget.venues.isNotEmpty) ...[
                        _buildFilterSection(
                            'Venue', widget.venues, 'venue', Icons.location_on),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                      if (widget.teams.isNotEmpty) ...[
                        _buildFilterSection(
                            'Team', widget.teams, 'team', Icons.group),
                      ],
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800.withOpacity(0.8),
              Colors.blue.shade900.withOpacity(0.9),
            ],
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: Colors.white.withOpacity(0.9),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Advanced Filters',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: Colors.white.withOpacity(0.9),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search filters...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade400),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade800.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, String filterKey, IconData icon) {
    final filteredOptions = _filterOptions(options);
    final selectedValues = _currentFilters[filterKey] as List<String>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade400, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filteredOptions.map((option) {
              final isSelected = selectedValues.contains(option);

              return FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade300,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final newSelectedValues = List<String>.from(selectedValues);
                  if (selected) {
                    newSelectedValues.add(option);
                  } else {
                    newSelectedValues.remove(option);
                  }
                  _handleFilterChange(filterKey, newSelectedValues);
                },
                backgroundColor: Colors.grey.shade800.withOpacity(0.5),
                selectedColor: Colors.blue.shade600.withOpacity(0.8),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.blue.shade400
                        : Colors.grey.shade600,
                    width: 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800.withOpacity(0.8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _toggleExpanded();
                widget.onFiltersChanged(_currentFilters);
              },
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Apply'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800.withOpacity(0.8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
