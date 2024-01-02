import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final ValueChanged? onchange;
  const MySearchBar(
      {super.key, required this.text, required this.controller, this.onchange});

  @override
  // this is the search bar. it is used to search clients and projects
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      //const EdgeInsets.only(right: 5, left: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 172, 170, 170)
                  .withOpacity(0.3), // Shadow color
              offset: const Offset(2, 2), // Offset of the shadow
              blurRadius: 4.0, // Blur radius
              spreadRadius: 2.0,
              blurStyle: BlurStyle.outer // Spread radius
              ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // this is the textfiels which will take user's search value as input
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onchange,
              decoration: InputDecoration(
                  hintText: text,
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      EneftyIcons.search_normal_outline,
                      size: 20,
                    ),
                    onPressed: () {},
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
