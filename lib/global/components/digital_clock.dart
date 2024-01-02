import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockScreen extends StatefulWidget {
  final String offset;

  const ClockScreen({super.key, required this.offset});
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  String _userProvidedTime = '';
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // _userProvidedTime = '';
    _updateClock();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateClock();
    });
  }

  void _updateClock() {
    DateTime now = DateTime.now();
    if (widget.offset.isNotEmpty) {
      DateTime userTime = DateFormat.Hms().parse(widget.offset);
      now = DateTime(now.year, now.month, now.day, userTime.hour,
          userTime.minute, userTime.second);
    }
    setState(() {
      _currentTime = now;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.Hms().format(_currentTime);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter time (HH:mm:ss)'),
            onChanged: (value) {
              setState(() {
                _userProvidedTime = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          Text(
            'Current Time: $formattedTime',
            style: TextStyle(fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
