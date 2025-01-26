import 'package:flutmisho/models/course_data.dart';
import 'package:flutmisho/widgets/categories.dart';
import 'package:flutmisho/widgets/chips.dart';
import 'package:flutmisho/widgets/text_field_with_clear.dart';
import 'package:flutmisho/widgets/topics_list.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

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
          child: TopicChips(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final course = courses[index];
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
            childCount: courses.length,
          ),
        ),
      ],
    );
  }
}
