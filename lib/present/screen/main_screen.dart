import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portal_hotel/data/live/auth_provider.dart';
import 'package:portal_hotel/present/screen/import_data/import_data_screen.dart';
import 'package:portal_hotel/res/images.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String _nextPage = "Import dữ liệu";
  String version = 'Loading...';
  int contractID = 0;
  String contractCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getVersion();
    });
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  void _onTabTapped(int index, String nextPage) {
    setState(() {
      selectedIndex = index;
      _nextPage = nextPage;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final menuItems = [
    ('', 0, 'Import dữ liệu', Icons.category_sharp),
  ];
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;
    final authProvider = Provider.of<AuthProvider>(context);
    String fullName = authProvider.username??'';
    String apiPermissions = authProvider.role??'';
    return Scaffold(
      body: Row(
        children: [
          if (!isSmallScreen) ...[
            Container(
              width: 250,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(NSGImages.logo),
                  ),
                  ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0),
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(NSGImages.avatar)),
                    title: Text(fullName),
                    subtitle: Text(apiPermissions ?? ""),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  // Danh mục
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'DANH MỤC',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  ...menuItems.map((item) {
                    return menuWidget(item.$2, item.$3, item.$4);// Return an empty container if permission not granted
                  }),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text('Đăng xuất'),
                    onTap: () {
                      // deleteUsername();
                      // deletePassword();
                      // deleteToken();
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
          // Nội dung chính
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              color: const Color(0xFFF2F3F5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _nextPage,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212B36),
                        ),
                      ),
                      Text(
                        'Phiên bản: $version',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF212B36),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Dashboard'),
                      const Icon(Icons.arrow_right),
                      Text(_nextPage),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if(selectedIndex == 0)...[
                    const Expanded(child: ImportDataScreen())
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuWidget(int index, String menuName,IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selectedIndex == index ? Colors.green[50] : Colors.white,
        border: Border.all(
          color: selectedIndex == index
              ? const Color(0x00ab5514)
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: selectedIndex == index
                ? Colors.green
                : const Color(0xFF637381)),
        title: Text(
          menuName,
          style: TextStyle(
            color:
            selectedIndex == index ? Colors.green : const Color(0xFF637381),
          ),
        ),
        onTap: () {
          _onTabTapped(index, menuName);
        },
      ),
    );
  }
}
