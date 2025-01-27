import 'package:flutmisho/screens/blog_post_screen.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final List<String> tags;
  final String title;
  final String description;
  final double rating;
  final int duration;
  final int lectures;
  final Map<String, dynamic> post; // Add this line

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.tags,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.lectures,
    required this.post, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogPostScreen(post: post),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.0,
                    children:
                        tags.map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1)),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text('$duration h'),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.format_list_bulleted,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text('$lectures lectures'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
