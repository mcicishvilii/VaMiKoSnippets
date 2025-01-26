import 'package:flutmisho/models/course_data.dart';
import 'package:flutmisho/widgets/categories.dart';
import 'package:flutmisho/widgets/chips.dart';
import 'package:flutmisho/widgets/text_field_with_clear.dart';
import 'package:flutmisho/widgets/topics_list.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final List<Map<String, dynamic>> courses = [
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
      'category': 'Web Design',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
      'category': 'Web Design',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
      'category': 'Web Design',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
      'category': 'development',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
      'category': 'development',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
      'category': 'development',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
      'category': 'development',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
      'category': 'development',
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
      'category': 'marketing',
    },
  ];

  List<Map<String, dynamic>> filteredCourses = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    filteredCourses = courses; // Initially display all courses
  }

  void filterCourses(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null || category.isEmpty) {
        filteredCourses = courses;
      } else {
        filteredCourses = courses
            .where((course) =>
                course['category'].toLowerCase() == category.toLowerCase())
            .toList();
        print(filteredCourses);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFieldWithIcons(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
              ),
              TopicCategories(),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: TopicChips(
            onCategorySelected: filterCourses,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (filteredCourses.isEmpty) {
                // Show a placeholder message if no courses match the filter
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No courses available for the selected category.',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
                );
              }

              // Check if it's the last item (for the "Clear Filter" button)
              if (index == filteredCourses.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        filterCourses(null); // Clear the filter
                      },
                      child: Text('Clear Filter'),
                    ),
                  ),
                );
              }

              // Build the course card
              final course = filteredCourses[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: CourseCard(
                  imageUrl: course['imageUrl'],
                  tags: course['tags'].cast<String>(),
                  title: course['title'],
                  description: course['description'],
                  rating: course['rating'],
                  duration: course['duration'],
                  lectures: course['lectures'],
                ),
              );
            },
            childCount:
                filteredCourses.isEmpty ? 1 : filteredCourses.length + 1,
          ),
        ),
      ],
    );
  }
}
