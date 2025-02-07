import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/zenburn.dart';

Widget buildCodeBlock(String codeSnippet, String language) {
  return HighlightView(
    codeSnippet,
    language: language.toLowerCase(),
    theme: zenburnTheme,
    padding: const EdgeInsets.all(12),
    textStyle: const TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
    ),
  );
}

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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              post['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...post['content'].map<Widget>((content) {
              if (content['type'] == 'text') {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    content['data'],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else if (content['type'] == 'code') {
                final String code = content['data'] ?? '';
                final String lang = content['language'] ?? 'dart';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildCodeBlock(code, lang),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }).toList(),
          ],
        ),
      ),
    );
  }
}
