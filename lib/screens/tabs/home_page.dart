import 'package:flutmisho/screens/tabs/explore_screen.dart';
import 'package:flutmisho/screens/tabs/library_screen.dart';
import 'package:flutmisho/screens/tabs/profile_screen.dart';
import 'package:flutmisho/widgets/home_page_body.dart';
import 'package:flutmisho/widgets/network_error_popup.dart';
import 'package:flutmisho/widgets/user_settings_popup.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../utils/api_service.dart';
import '../login/login_page.dart';

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
  final List<String> appBarTitles = ['Home', 'Explore', 'Library', 'Profile'];

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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
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
      _hideUserMenu();
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
              child: CustomPopupMenu(
                hideUserMenu: () {
                  _hideUserMenu();
                },
                logOut: () {
                  _handleLogout();
                },
                userProfile: _userProfile,
              )),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideUserMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePageBody(),
      const ExploreScreen(),
      const LibraryScreen(),
      ProfileScreen(userProfile: _userProfile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            appBarTitles[currentPageIndex]),
        actions: [
          CompositedTransformTarget(
            link: _layerLink,
            child: IconButton(
              color: Theme.of(context).colorScheme.onSurface,
              icon: const Icon(Icons.notifications_sharp),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          0.5,
        ),
        child: const Icon(Icons.create),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Floating Action Button tapped!")),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        elevation: 10,
        surfaceTintColor: Colors.grey,
        height: 50,
        backgroundColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
                color: Theme.of(context).colorScheme.onSurface, Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              color: Theme.of(context).colorScheme.onSurface,
              Icons.search_outlined,
              size: 25,
            ),
            icon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(
                color: Theme.of(context).colorScheme.onSurface,
                Icons.bookmarks),
            icon: Icon(Icons.bookmarks_outlined),
            label: 'Library',
          ),
          NavigationDestination(
            selectedIcon: Icon(
                color: Theme.of(context).colorScheme.onSurface, Icons.person),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? NetworkErrorPopup(
                  error: _error,
                  loadProfile: () {
                    _loadProfile();
                  },
                )
              : screens[currentPageIndex],
    );
  }
}
