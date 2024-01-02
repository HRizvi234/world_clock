import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/bottom_navigation/bottom_nav_provider.dart';
import 'package:world_clock/features/clocks/clocks_list.dart';
import 'package:world_clock/features/clocks/clocks_screen.dart';
import 'package:world_clock/features/home/screen/home_screen.dart';
import 'package:world_clock/features/messages/messages_screen.dart';
import 'package:world_clock/features/search/search_provider.dart';
import 'package:world_clock/features/search/search_screen.dart';
import 'package:world_clock/features/settings/settings_screen.dart';
import 'package:world_clock/global/constants/appcolors.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  List<Widget> screenlist = [
    HomeScreen(),
    ClockList(),
    SearchScreen(),
    MessagesScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    SearchProvider sp = Provider.of<SearchProvider>(context);
    return SafeArea(
        child: Scaffold(
      body: Consumer<BottomNavProvider>(builder: (context, p, index) {
        return screenlist[p.currentPage];
      }),
      bottomNavigationBar:
          Consumer<BottomNavProvider>(builder: (context, provider, child) {
        return BottomNavigationBar(
            unselectedFontSize: 10,
            selectedFontSize: 12,
            iconSize: 20,
            type: BottomNavigationBarType.fixed,
            //bottom navigation bar that will navigate to the screens provided in the screenlist
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                  icon: Icon(EneftyIcons.home_2_outline),
                  label:
                      'Home'), // Home Screen icon. Label and icon can be changed
              const BottomNavigationBarItem(
                  icon: Icon(EneftyIcons.timer_2_outline),
                  label:
                      'Clocks'), // payments screen icon. Label and icon can be changed
              BottomNavigationBarItem(
                  //this is custom icon that has '+' sign. This will navigate user to add project page. Custom icon can be changed.
                  icon: Icon(EneftyIcons.search_normal_outline),
                  label: 'Search'),
              const BottomNavigationBarItem(
                icon: Icon(EneftyIcons.message_circle_outline),
                label: 'Message',
              ), //Projects screen icon. Label and icon can be changed
              const BottomNavigationBarItem(
                  icon: Icon(EneftyIcons.setting_outline),
                  label:
                      'Settings'), //Profile screen icon, Label and icon can be changed
            ],
            currentIndex: provider.currentPage,
            selectedItemColor: AppColors.primary,
            onTap: (index) {
              // function of UI provider class that changes index of bottom navigation

              provider.setcurrentPage(index);
              sp.setcityname('');
              // sp.setlatitude(0);
              // sp.setlongitude(0);
              // uiProvider.setCurrentPage(widget.page);
            });
      }),
    ));
  }
}
