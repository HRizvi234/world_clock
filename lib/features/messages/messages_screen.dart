import 'package:flutter/material.dart';
import 'package:world_clock/global/constants/appcolors.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Text(
          'Messages Page',
          style: TextStyle(fontSize: 20, color: AppColors.primary),
        ),
      ),
    ));
  }
}
