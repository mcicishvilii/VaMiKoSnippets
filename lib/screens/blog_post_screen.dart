import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogPostScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const BlogPostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              post['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ...post['content'].map<Widget>((content) {
              if (content['type'] == 'text') {
                return Text(
                  content['data'],
                  style: TextStyle(fontSize: 16),
                );
              } else if (content['type'] == 'code') {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          content['data'],
                          style:
                              TextStyle(fontFamily: 'monospace', fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          // Copy the code to the clipboard
                          Clipboard.setData(
                              ClipboardData(text: content['data']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Code copied to clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }).toList(),
          ],
        ),
      ),
    );
  }
}
