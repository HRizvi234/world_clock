import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/bottom_navigation/bottom_nav_provider.dart';
import 'package:world_clock/features/clocks/clock_list_provider.dart';
import 'package:world_clock/features/clocks/clocks_provider.dart';
import 'package:world_clock/features/home/home_provider.dart';
import 'package:world_clock/features/home/screen/home_screen.dart';
import 'package:world_clock/features/onboarding_screen.dart/onboarding_screen.dart';
import 'package:world_clock/features/search/search_provider.dart';
import 'package:world_clock/features/settings/settings_provider.dart';
import 'package:world_clock/features/settings/settings_screen.dart';
import 'package:world_clock/features/splashscreen/spalsh_screen.dart';
import 'package:world_clock/global/constants/appcolors.dart';
import 'package:flutter/services.dart';
import 'package:world_clock/global/providers/map_provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
      ChangeNotifierProvider<SettingsProvider>(
          create: (context) => SettingsProvider()),
      ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider()),
      ChangeNotifierProvider<ClocksProvider>(
          create: (context) => ClocksProvider()),
      ChangeNotifierProvider<BottomNavProvider>(
          create: (context) => BottomNavProvider()),
      ChangeNotifierProvider<MapProvider>(create: (context) => MapProvider()),
      ChangeNotifierProvider<ClockListProvider>(
          create: (context) => ClockListProvider()),
    ], child: MyApp()),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
