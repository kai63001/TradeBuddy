import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:trade_buddy_app/components/custom_navbar.dart';
import 'package:trade_buddy_app/components/dashboard/dashboard.dart';
import 'package:trade_buddy_app/page/create_profile/create_profile_page.dart';
import 'package:trade_buddy_app/store/profile_store.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';
import 'package:unicons/unicons.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileStore()),
        BlocProvider(create: (_) => SelectProfileStore()),
        BlocProvider(create: (_) => TradeStore()),
      ],
      child: MaterialApp(
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
        initialRoute: "/home",
        routes: {
          "/home": (context) => const MyHomePage(),
          "/interactive": (context) => const Dashboard(),
          "/create-profile-page": (context) => const CreateProfilePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> profiles = [];
  bool loading = true;

  //init
  @override
  void initState() {
    super.initState();
    checkHaveAnyProfileOrNot();
  }

  Future<void> checkHaveAnyProfileOrNot() async {
    await context.read<ProfileStore>().initProfileList();
    await context.read<SelectProfileStore>().initSelectedProfile();
    final profileStore = context.read<ProfileStore>();
    if (profileStore.state.isNotEmpty) {
      setState(() {
        profiles = profileStore.state;
      });
    }
    setState(() {
      loading = false;
    });
  }

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(
              FeatherIcons.grid,
              size: 22,
            ),
            title: "Dashboard",
          ),
        ),
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(
              UniconsLine.dashboard,
              size: 25,
            ),
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
    if (loading) {
      return Scaffold(
          body: Center(
        child: LoadingAnimationWidget.beat(
          color: Colors.white,
          size: 50,
        ),
      ));
    }
    if (profiles.isEmpty) return const CreateProfilePage();
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => CustomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
