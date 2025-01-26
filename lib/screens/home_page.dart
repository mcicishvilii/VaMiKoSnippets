import 'package:flutmisho/screens/user_profile.dart';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/course_data.dart';
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _error;

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

  void _showUserMenu() {
    _hideUserMenu();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-150, 50),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      _hideUserMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Contact tapped!")),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Account Settings'),
                    onTap: () {
                      _hideUserMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Accoun settings tapped!")),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () {
                      _hideUserMenu();
                      _handleLogout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("see you soon!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideUserMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
                _hideUserMenu();
              },
            ),
          ),
          CompositedTransformTarget(
            link: _layerLink,
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                if (_overlayEntry == null) {
                  _showUserMenu();
                } else {
                  _hideUserMenu();
                }
              },
            ),
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
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
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
                      ),
                    ),
                  ],
                ),
    );
  }
}
