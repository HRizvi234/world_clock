import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/settings/settings_provider.dart';

class SettingsWidget extends StatelessWidget {
  final String text;
  final bool flag;
  final bool? switchFlag;
  final VoidCallback? onPressed;

  final ValueChanged<bool>? onChanged;

  const SettingsWidget(
      {super.key,
      required this.text,
      required this.flag,
      this.switchFlag,
      this.onChanged,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border(bottom: BorderSide.none),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(211, 172, 170, 170)
                  .withOpacity(0.3), // Shadow color
              offset: const Offset(0, 0), // Offset of the shadow
              blurRadius: 2.0, // Blur radius
              spreadRadius: 2.0,
              blurStyle: BlurStyle.outer,

              // Spread radius
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            flag
                // ? Switch(
                //     value: sp.check,
                //     onChanged: (value) {
                //       sp.setcheck(value);
                //     })
                ? CupertinoSwitch(
                    value: switchFlag!,
                    onChanged: onChanged,
                    activeColor: Colors.green,
                  )
                : GestureDetector(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                    onTap: onPressed,
                  )
          ],
        ),
      ),
    );
  }
}
