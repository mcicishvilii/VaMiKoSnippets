import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../utils/api_service.dart';
import 'login/login_page.dart';
import 'package:flutmisho/widgets/topics_list.dart';

class HomePage extends StatefulWidget {
  final String accessToken;
  final String refreshToken;

  const HomePage({
    super.key,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> _courses = [
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['All level'],
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'rating': 4.0,
      'duration': 13,
      'lectures': 15,
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'tags': ['Beginner', 'Design'],
      'title': 'UI/UX Design Masterclass',
      'description': 'Dive into the world of user-centered design.',
      'rating': 4.5,
      'duration': 20,
      'lectures': 42,
    },
    // Add more course data as needed
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final result = await _apiService.getProfile(widget.accessToken);

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _userProfile = result['profile'];
        _error = null;
      } else {
        _error = result['message'];
      }
    });
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);

    final result = await _apiService.logout(
      widget.accessToken,
      widget.refreshToken,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/flutter_logo.png',
              height: 40,
            ),
          ],
        ),
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _isLoading ? null : _handleLogout,
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("About Us tapped!")),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Contact tapped!")),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Terms of Service'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Terms of Service tapped!")),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Privacy Policy tapped!")),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search...',
                ),
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('ID: ${_userProfile?.id}'),
                          const SizedBox(height: 8),
                          Text('Email: ${_userProfile?.email}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
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
                      ),
                    ),
                  ],
                ),
    );
  }
}
