import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portal_hotel/data/live/auth_provider.dart';
import 'package:portal_hotel/present/screen/auth/login/login_screen.dart';
import 'package:portal_hotel/present/screen/import_data/controllers/import_data_controller.dart';
import 'package:provider/provider.dart';

void main() async{
  const String.fromEnvironment('API_URL', defaultValue: 'https://api-salesfast-gateway-uat.globalx.com.vn');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const PortalImport(),
    ),
  );
}

class PortalImport extends StatelessWidget {
  const PortalImport({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Portal Import CRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}

