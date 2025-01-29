import 'package:flutmisho/models/course_data.dart';
import 'package:flutmisho/widgets/catgegory_tabs.dart';
import 'package:flutmisho/widgets/topics_list.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});
  @override
  HomePageBodyState createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  List<Map<String, dynamic>> filteredCourses = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    filteredCourses = courses;
  }

  void filterCourses(String? category, {String query = ''}) {
    setState(() {
      selectedCategory = category;
      if ((category == null || category.isEmpty) && query.isEmpty) {
        filteredCourses = courses;
      } else {
        filteredCourses = courses.where((course) {
          final matchesCategory = category == null ||
              category.isEmpty ||
              course['category'].toLowerCase() == category.toLowerCase();
          final matchesQuery = query.isEmpty ||
              course['title'].toLowerCase().contains(query.toLowerCase()) ||
              course['description'].toLowerCase().contains(query.toLowerCase());
          return matchesCategory && matchesQuery;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: TopicTabs(
          onCategorySelected: (category) {
            filterCourses(category);
          },
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (filteredCourses.isEmpty) {
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

              if (index == filteredCourses.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        filterCourses(null);
                      },
                      child: Text('Clear Filter'),
                    ),
                  ),
                );
              }

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
                  post: course['post'], // Pass the post data
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
