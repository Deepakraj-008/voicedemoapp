import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/course_curriculum_section.dart';
import './widgets/course_enrollment_section.dart';
import './widgets/course_hero_section.dart';
import './widgets/course_info_cards.dart';
import './widgets/course_reviews_section.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool isEnrolled = false;
  bool isLoading = false;

  // Mock course data
  final Map<String, dynamic> courseData = {
    "id": "course_001",
    "title": "Complete Python Programming Bootcamp",
    "subtitle":
        "Master Python from beginner to advanced with AI-powered learning",
    "heroImage":
        "https://images.unsplash.com/photo-1526379095098-d400fd0bf935?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "difficulty": "Intermediate",
    "duration": "12 weeks",
    "studentsCount": "15,420",
    "price": "\$89.99",
    "originalPrice": "\$199.99",
    "discount": 55,
    "description":
        """Master Python programming with our comprehensive bootcamp designed for aspiring developers. This course combines traditional learning with AI-powered assistance to accelerate your journey from beginner to professional Python developer.

You'll learn everything from basic syntax to advanced concepts like web development, data analysis, and machine learning. Our voice-guided learning system makes it easy to study hands-free, perfect for busy professionals.""",
    "prerequisites": [
      "Basic computer literacy",
      "No prior programming experience required",
      "Willingness to learn and practice regularly"
    ],
    "learningOutcomes": [
      "Write clean, efficient Python code",
      "Build web applications with Django/Flask",
      "Analyze data with pandas and NumPy",
      "Create machine learning models",
      "Deploy applications to the cloud",
      "Debug and optimize Python programs"
    ],
    "totalLessons": 156,
    "completedLessons": 45,
    "progress": 0.35,
  };

  final List<Map<String, dynamic>> curriculumModules = [
    {
      "title": "Python Fundamentals",
      "lessonCount": 25,
      "duration": "4.5 hours",
      "lessons": [
        {
          "title": "Introduction to Python",
          "duration": "12 min",
          "type": "video",
          "hasPreview": true,
        },
        {
          "title": "Variables and Data Types",
          "duration": "18 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Control Structures",
          "duration": "22 min",
          "type": "video",
          "hasPreview": true,
        },
        {
          "title": "Practice Exercises",
          "duration": "30 min",
          "type": "exercise",
          "hasPreview": false,
        },
      ]
    },
    {
      "title": "Object-Oriented Programming",
      "lessonCount": 18,
      "duration": "3.2 hours",
      "lessons": [
        {
          "title": "Classes and Objects",
          "duration": "15 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Inheritance and Polymorphism",
          "duration": "20 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Advanced OOP Concepts",
          "duration": "25 min",
          "type": "video",
          "hasPreview": false,
        },
      ]
    },
    {
      "title": "Web Development with Django",
      "lessonCount": 32,
      "duration": "6.8 hours",
      "lessons": [
        {
          "title": "Django Setup and Configuration",
          "duration": "16 min",
          "type": "video",
          "hasPreview": true,
        },
        {
          "title": "Models and Database",
          "duration": "24 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Views and Templates",
          "duration": "28 min",
          "type": "video",
          "hasPreview": false,
        },
      ]
    },
    {
      "title": "Data Science and Machine Learning",
      "lessonCount": 28,
      "duration": "5.5 hours",
      "lessons": [
        {
          "title": "NumPy and Pandas Basics",
          "duration": "20 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Data Visualization",
          "duration": "18 min",
          "type": "video",
          "hasPreview": false,
        },
        {
          "title": "Machine Learning Fundamentals",
          "duration": "35 min",
          "type": "video",
          "hasPreview": false,
        },
      ]
    },
  ];

  final Map<String, dynamic> reviewData = {
    "averageRating": 4.8,
    "totalReviews": 2847,
    "reviews": [
      {
        "id": "review_001",
        "userName": "Sarah Johnson",
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 5.0,
        "date": "2 weeks ago",
        "comment":
            "Absolutely fantastic course! The AI voice assistant made learning so much easier. I could practice coding while commuting and the explanations were crystal clear. Highly recommend for anyone serious about learning Python.",
        "audioReview": "audio_review_001.mp3"
      },
      {
        "id": "review_002",
        "userName": "Michael Chen",
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 5.0,
        "date": "1 month ago",
        "comment":
            "The voice-guided learning feature is a game changer. I was able to learn while working out and during my daily walks. The course content is comprehensive and well-structured.",
        "audioReview": null
      },
      {
        "id": "review_003",
        "userName": "Emily Rodriguez",
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 4.0,
        "date": "3 weeks ago",
        "comment":
            "Great course with excellent practical examples. The AI assistant sometimes had trouble understanding my accent, but overall a very positive learning experience.",
        "audioReview": "audio_review_003.mp3"
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 35.h,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _handleBookmark(),
                  icon: CustomIconWidget(
                    iconName: 'bookmark_border',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CourseHeroSection(
                courseData: courseData,
                onPlayPreview: _handlePlayPreview,
              ),
            ),
          ),

          // Course Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Course Info Cards
                CourseInfoCards(courseData: courseData),

                SizedBox(height: 3.h),

                // Course Description
                _buildDescriptionSection(),

                SizedBox(height: 3.h),

                // Prerequisites and Learning Outcomes
                _buildPrerequisitesAndOutcomes(),

                SizedBox(height: 3.h),

                // Course Curriculum
                CourseCurriculumSection(modules: curriculumModules),

                SizedBox(height: 3.h),

                // Student Reviews
                CourseReviewsSection(reviewData: reviewData),

                SizedBox(height: 10.h), // Space for bottom sheet
              ],
            ),
          ),
        ],
      ),

      // Floating Voice Assistant
      floatingActionButton: FloatingActionButton(
        onPressed: _handleVoiceAssistant,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: CustomIconWidget(
          iconName: 'mic',
          color: Colors.white,
          size: 28,
        ),
        tooltip: 'Voice Assistant - Ask about this course',
      ),

      // Bottom Enrollment Section
      bottomSheet: CourseEnrollmentSection(
        courseData: courseData,
        isEnrolled: isEnrolled,
        onEnroll: _handleEnrollment,
        onContinue: _handleContinueLearning,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'About This Course',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            courseData["description"] as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesAndOutcomes() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prerequisites
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'checklist',
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Prerequisites',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ...(courseData["prerequisites"] as List<String>)
                      .map((prerequisite) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: 'fiber_manual_record',
                            color: Theme.of(context).colorScheme.secondary,
                            size: 8,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              prerequisite,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Learning Outcomes
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: Colors.amber,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'You\'ll Learn',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ...(courseData["learningOutcomes"] as List<String>)
                      .take(4)
                      .map((outcome) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: Colors.green,
                            size: 12,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              outcome,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if ((courseData["learningOutcomes"] as List<String>).length >
                      4)
                    Text(
                      '+${(courseData["learningOutcomes"] as List<String>).length - 4} more...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlayPreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'play_circle',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Course Preview'),
          ],
        ),
        content: Text(
          'Playing course preview... This would show a sample lesson or course trailer with voice narration.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleBookmark() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course bookmarked for later'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleVoiceAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Handle
            Container(
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

            SizedBox(height: 2.h),

            // Voice Assistant Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'assistant',
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Learning Assistant',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Ask me anything about this course',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Suggested Questions
            Text(
              'Try asking:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            SizedBox(height: 1.h),

            Expanded(
              child: ListView(
                children: [
                  _buildSuggestedQuestion('What will I learn in this course?'),
                  _buildSuggestedQuestion('How long does it take to complete?'),
                  _buildSuggestedQuestion('What are the prerequisites?'),
                  _buildSuggestedQuestion('Is this suitable for beginners?'),
                  _buildSuggestedQuestion('What projects will I build?'),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Voice Input Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Listening... Ask your question now'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'mic',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Start Voice Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestion(String question) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _handleVoiceQuestion(question);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'chat_bubble_outline',
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVoiceQuestion(String question) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing: "$question"'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEnrollment() {
    setState(() {
      isEnrolled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Successfully enrolled! Welcome to the course.'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleContinueLearning() {
    Navigator.pushNamed(context, '/learning-session');
  }
}
