import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

/// Helper widget that returns a syntax-highlighted code block.
/// It uses the [flutter_highlight] package to render the code in the style
/// corresponding to the provided [language].
Widget buildCodeBlock(String codeSnippet, String language) {
  return HighlightView(
    codeSnippet,
    language: language.toLowerCase(), // ensure language is lowercase
    theme: monokaiSublimeTheme,
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
            // Post Title
            Text(
              post['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Post Description
            Text(
              post['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Render each content element
            ...post['content'].map<Widget>((content) {
              if (content['type'] == 'text') {
                // Display plain text content
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    content['data'],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else if (content['type'] == 'code') {
                // Retrieve the code snippet and language.
                final String code = content['data'] ?? '';
                // Use the language provided in the code snippet;
                // fallback to a default value (e.g. 'dart') if not provided.
                final String lang = content['language'] ?? 'dart';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // The highlighted code block using our helper.
                      buildCodeBlock(code, lang),
                      // A copy button placed below the code block.
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
              // Fallback widget if content type is unrecognized.
              return const SizedBox.shrink();
            }).toList(),
          ],
        ),
      ),
    );
  }
}
