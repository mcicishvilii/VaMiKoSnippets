import 'package:flutmisho/widgets/drawer.dart';
import 'package:flutmisho/widgets/home_page_body.dart';
import 'package:flutmisho/widgets/network_error_popup.dart';
import 'package:flutmisho/widgets/user_settings_popup.dart';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/api_service.dart';
import 'login/login_page.dart';

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
        if (result['message'].contains('authentication')) {
          _handleLogout();
        }
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
        child: CustomDrawer(),
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
              : HomePageBody(),
    );
  }
}
