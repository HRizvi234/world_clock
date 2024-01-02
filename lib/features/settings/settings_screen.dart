import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/settings/settings_provider.dart';
import 'package:world_clock/features/settings/settings_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Consumer<SettingsProvider>(
                  builder: (context, p, child) => SettingsWidget(
                    text: 'Notifications',
                    flag: true,
                    switchFlag: p.check,
                    onChanged: (value) {
                      p.setcheck(value);
                    },
                  ),
                ),
                Consumer<SettingsProvider>(
                    builder: (context, p, child) => SettingsWidget(
                          text: '24-Hour Time',
                          flag: true,
                          switchFlag: p.check2,
                          onChanged: (value) {
                            p.setcheck2(value);
                            return;
                          },
                        )),
                SettingsWidget(
                  text: 'ShareApp',
                  flag: false,
                ),
                SettingsWidget(
                  text: 'Privacy Policy',
                  flag: false,
                ),
              ],
            ),
          )
        ],
      ),
    )));
  }
}
