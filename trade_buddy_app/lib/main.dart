import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:trade_buddy_app/components/custom_navbar.dart';
import 'package:trade_buddy_app/components/dashboard/dashboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 0, 0, 0),
          secondary: Color(0xff00D6BF),
          // ignore: deprecated_member_use
          background: Color(0xff222222),
          surface: Color(0xff2B2B2F),
          brightness: Brightness.dark,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const MyHomePage(),
      routes: {
        "/home": (context) => const MyHomePage(),
        "/interactive": (context) => const Dashboard(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Dashboard",
          ),
        ),
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Performance",
          ),
        ),
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "action",
          ),
        ),
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Messages1",
          ),
        ),
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => CustomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
