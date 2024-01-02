import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:world_clock/global/constants/appcolors.dart';

class Clock extends StatelessWidget {
  const Clock({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalogClock(
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.black),
          color: Colors.transparent,
          shape: BoxShape.circle),
      width: 150.0,
      isLive: true,
      hourHandColor: Colors.black,
      minuteHandColor: Colors.black,
      showSecondHand: true,
      secondHandColor: AppColors.primary,
      numberColor: Colors.black87,
      showNumbers: true,
      showAllNumbers: false,
      textScaleFactor: 1.4,
      showTicks: false,
      showDigitalClock: false,
      datetime: DateTime(2019, 1, 1, 9, 12, 15),
    );
  }
}
