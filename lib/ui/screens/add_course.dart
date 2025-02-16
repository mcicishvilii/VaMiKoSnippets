// add_course_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/content_course.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postDescriptionController =
      TextEditingController();

  bool _isLoading = false;

  List<ContentBlock> _contentBlocks = [
    ContentBlock(type: 'text', data: ''),
  ];

  Future<void> _submitCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://ladogudi.serv00.net/api/insert_course'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'imageUrl': _imageUrlController.text,
          'tags': ['All level'], // or collect tags if you add that field
          'title': _titleController.text,
          'description': _descriptionController.text, // course description
          'rating': 0.0,
          'duration': 0,
          'lectures': 0,
          'category': _categoryController.text,
          'post': {
            'title': _postTitleController.text,
            'description': _postDescriptionController.text,
            // Build content as a list of maps:
            'content': _contentBlocks.map((block) => block.toJson()).toList(),
          }
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course added successfully!')),
        );
        Navigator.pop(context);
      } else {
        print(response.body);
        throw Exception('Failed to add course');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Course'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Course Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Course Description'),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter a description'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter an image URL' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a category' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _postTitleController,
                decoration: InputDecoration(labelText: 'Post Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a post title' : null,
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Post Content Blocks:', style: TextStyle(fontSize: 16)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _contentBlocks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Dropdown for type selection
                              DropdownButtonFormField<String>(
                                value: _contentBlocks[index].type,
                                items: ['text', 'code']
                                    .map((t) => DropdownMenuItem(
                                        value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _contentBlocks[index].type = newValue!;
                                  });
                                },
                                decoration:
                                    InputDecoration(labelText: 'Block Type'),
                              ),
                              SizedBox(height: 8),
                              // Text field for block data
                              TextFormField(
                                initialValue: _contentBlocks[index].data,
                                decoration:
                                    InputDecoration(labelText: 'Block Content'),
                                maxLines: null,
                                onChanged: (value) {
                                  _contentBlocks[index].data = value;
                                },
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Please enter content'
                                        : null,
                              ),
                              // Button to remove block (if more than one exists)
                              if (_contentBlocks.length > 1)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _contentBlocks.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Button to add a new block
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _contentBlocks
                            .add(ContentBlock(type: 'text', data: ''));
                      });
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Block'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitCourse,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _postTitleController.dispose();
    _postDescriptionController.dispose();
    super.dispose();
  }
}
