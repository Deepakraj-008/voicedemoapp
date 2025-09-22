import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/course_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/voice_fab_widget.dart';

class CourseCatalog extends StatefulWidget {
  const CourseCatalog({super.key});

  @override
  State<CourseCatalog> createState() => _CourseCatalogState();
}

class _CourseCatalogState extends State<CourseCatalog>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _selectedCategories = [];
  bool _isVoiceListening = false;
  bool _isLoading = false;
  String _sortBy = 'popularity';
  String? _voiceHint;

  // Mock data for courses
  final List<Map<String, dynamic>> _allCourses = [
    {
      "id": 1,
      "title": "Complete Python Programming Bootcamp",
      "instructor": "Dr. Sarah Johnson",
      "image":
          "https://images.unsplash.com/photo-1526379095098-d400fd0bf935?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Beginner",
      "rating": 4.8,
      "enrolledCount": 12450,
      "price": "\$89.99",
      "category": "Programming",
      "isEnrolled": false,
      "isWishlisted": false,
      "duration": "40 hours",
      "description":
          "Master Python programming from basics to advanced concepts with hands-on projects and real-world applications."
    },
    {
      "id": 2,
      "title": "Advanced React Development",
      "instructor": "Michael Chen",
      "image":
          "https://images.unsplash.com/photo-1633356122544-f134324a6cee?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Advanced",
      "rating": 4.9,
      "enrolledCount": 8920,
      "price": "\$129.99",
      "category": "Web Development",
      "isEnrolled": true,
      "isWishlisted": false,
      "duration": "35 hours",
      "description":
          "Build modern web applications with React, Redux, and advanced patterns used by industry professionals."
    },
    {
      "id": 3,
      "title": "Machine Learning Fundamentals",
      "instructor": "Prof. Emily Rodriguez",
      "image":
          "https://images.unsplash.com/photo-1555949963-aa79dcee981c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Intermediate",
      "rating": 4.7,
      "enrolledCount": 15680,
      "price": "\$149.99",
      "category": "Data Science",
      "isEnrolled": false,
      "isWishlisted": true,
      "duration": "50 hours",
      "description":
          "Learn machine learning algorithms, data preprocessing, and model evaluation with Python and scikit-learn."
    },
    {
      "id": 4,
      "title": "iOS App Development with Swift",
      "instructor": "David Kim",
      "image":
          "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Intermediate",
      "rating": 4.6,
      "enrolledCount": 6750,
      "price": "\$99.99",
      "category": "Mobile Development",
      "isEnrolled": false,
      "isWishlisted": false,
      "duration": "45 hours",
      "description":
          "Create stunning iOS applications using Swift and Xcode with modern development practices."
    },
    {
      "id": 5,
      "title": "Digital Marketing Mastery",
      "instructor": "Lisa Thompson",
      "image":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Beginner",
      "rating": 4.5,
      "enrolledCount": 9340,
      "price": "\$79.99",
      "category": "Marketing",
      "isEnrolled": false,
      "isWishlisted": false,
      "duration": "30 hours",
      "description":
          "Master digital marketing strategies including SEO, social media, and content marketing."
    },
    {
      "id": 6,
      "title": "UI/UX Design Principles",
      "instructor": "Alex Morgan",
      "image":
          "https://images.unsplash.com/photo-1561070791-2526d30994b5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "difficulty": "Beginner",
      "rating": 4.8,
      "enrolledCount": 11200,
      "price": "\$69.99",
      "category": "Design",
      "isEnrolled": false,
      "isWishlisted": true,
      "duration": "25 hours",
      "description":
          "Learn user-centered design principles and create beautiful, functional interfaces."
    }
  ];

  final List<String> _categories = [
    "Programming",
    "Web Development",
    "Data Science",
    "Mobile Development",
    "Marketing",
    "Design",
    "Business",
    "Photography"
  ];

  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = List.from(_allCourses);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final matchesSearch = _searchController.text.isEmpty ||
            (course["title"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (course["instructor"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (course["category"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(course["category"] as String);

        return matchesSearch && matchesCategory;
      }).toList();

      _sortCourses();
    });
  }

  void _sortCourses() {
    switch (_sortBy) {
      case 'popularity':
        _filteredCourses.sort((a, b) =>
            (b["enrolledCount"] as int).compareTo(a["enrolledCount"] as int));
        break;
      case 'rating':
        _filteredCourses.sort(
            (a, b) => (b["rating"] as double).compareTo(a["rating"] as double));
        break;
      case 'price_low':
        _filteredCourses.sort((a, b) {
          final priceA = double.tryParse(
                  (a["price"] as String).replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          final priceB = double.tryParse(
                  (b["price"] as String).replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        _filteredCourses.sort((a, b) {
          final priceA = double.tryParse(
                  (a["price"] as String).replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          final priceB = double.tryParse(
                  (b["price"] as String).replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          return priceB.compareTo(priceA);
        });
        break;
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _filterCourses();
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategories.clear();
      _searchController.clear();
    });
    _filterCourses();
  }

  void _onVoiceSearch() {
    setState(() {
      _isVoiceListening = !_isVoiceListening;
      if (_isVoiceListening) {
        _voiceHint =
            "Say 'Hello Sweety, find Python courses' or 'Show beginner courses'";
        // Simulate voice recognition
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isVoiceListening) {
            setState(() {
              _isVoiceListening = false;
              _voiceHint = null;
              _searchController.text = "Python";
            });
            _filterCourses();
          }
        });
      } else {
        _voiceHint = null;
      }
    });
  }

  void _onCourseEnroll(Map<String, dynamic> course) {
    setState(() {
      final index = _allCourses.indexWhere((c) => c["id"] == course["id"]);
      if (index != -1) {
        _allCourses[index]["isEnrolled"] =
            !(course["isEnrolled"] as bool? ?? false);
      }
    });
    _filterCourses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          course["isEnrolled"] == true
              ? "Continuing ${course["title"]}"
              : "Enrolled in ${course["title"]}",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCourseWishlist(Map<String, dynamic> course) {
    setState(() {
      final index = _allCourses.indexWhere((c) => c["id"] == course["id"]);
      if (index != -1) {
        _allCourses[index]["isWishlisted"] =
            !(course["isWishlisted"] as bool? ?? false);
      }
    });
    _filterCourses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          course["isWishlisted"] == true
              ? "Removed from wishlist"
              : "Added to wishlist",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Course catalog updated"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort by",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              _buildSortOption("Popularity", "popularity"),
              _buildSortOption("Highest Rated", "rating"),
              _buildSortOption("Price: Low to High", "price_low"),
              _buildSortOption("Price: High to Low", "price_high"),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: _sortBy == value ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: _sortBy == value ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: _sortBy == value
          ? CustomIconWidget(
              iconName: 'check',
              color: colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        _filterCourses();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Course Catalog",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'sort',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showSortOptions,
            tooltip: 'Sort courses',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, '/profile-settings'),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) => _filterCourses(),
            onVoiceSearch: _onVoiceSearch,
            hintText: "Search courses, instructors, or topics...",
          ),

          // Filter Chips
          FilterChipsWidget(
            categories: _categories,
            selectedCategories: _selectedCategories,
            onCategorySelected: _onCategorySelected,
            onClearFilters: _clearAllFilters,
          ),

          // Course List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCourses.isEmpty
                    ? EmptyStateWidget(
                        title: _searchController.text.isNotEmpty ||
                                _selectedCategories.isNotEmpty
                            ? "No courses found"
                            : "Discover Amazing Courses",
                        subtitle: _searchController.text.isNotEmpty ||
                                _selectedCategories.isNotEmpty
                            ? "Try adjusting your search or filters to find what you're looking for."
                            : "Explore our comprehensive course catalog and start your learning journey today.",
                        actionText: _searchController.text.isNotEmpty ||
                                _selectedCategories.isNotEmpty
                            ? "Clear Filters"
                            : null,
                        onActionPressed: _searchController.text.isNotEmpty ||
                                _selectedCategories.isNotEmpty
                            ? _clearAllFilters
                            : null,
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = _filteredCourses[index];
                            return CourseCardWidget(
                              course: course,
                              onTap: () {
                                // Navigate to course details
                                Navigator.pushNamed(context, '/course-detail');
                              },
                              onEnroll: () => _onCourseEnroll(course),
                              onWishlist: () => _onCourseWishlist(course),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: VoiceFabWidget(
        onPressed: _onVoiceSearch,
        isListening: _isVoiceListening,
        voiceHint: _voiceHint,
      ),
    );
  }
}
