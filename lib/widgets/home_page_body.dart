// home_page_body.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutmisho/widgets/catgegory_tabs.dart';
import 'package:flutmisho/widgets/topics_list.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});
  @override
  HomePageBodyState createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  List<Map<String, dynamic>> allCourses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  String? selectedCategory;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final response =
          await http.get(Uri.parse('https://ladogudi.serv00.net/api/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allCourses =
              data.map((item) => item as Map<String, dynamic>).toList();
          filteredCourses = allCourses;
          isLoading = false;
          error = null;
        });
      } else {
        setState(() {
          error = 'Failed to load courses. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading courses: $e';
        isLoading = false;
      });
    }
  }

  void filterCourses(String? category, {String query = ''}) {
    setState(() {
      selectedCategory = category;
      if ((category == null || category.isEmpty) && query.isEmpty) {
        filteredCourses = allCourses;
      } else {
        filteredCourses = allCourses.where((course) {
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: fetchCourses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: TopicTabs(
            onCategorySelected: (category) {
              filterCourses(category);
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (filteredCourses.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
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
                      child: const Text('Clear Filter'),
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
                  tags: (course['tags'] as List)
                      .map((tag) => tag.toString())
                      .toList(),
                  title: course['title'],
                  description: course['description'],
                  rating: course['rating'] is String
                      ? double.parse(course['rating'])
                      : (course['rating'] as num).toDouble(),
                  duration: course['duration'],
                  lectures: course['lectures'],
                  post: course['post'],
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
