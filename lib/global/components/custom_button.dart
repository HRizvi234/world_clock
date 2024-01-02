import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color containerColor;
  final ImageProvider<Object>? image;
  final IconData? icon; // Use ImageProvider instead
  final VoidCallback?
      onPressed; // Function to be called when the button is pressed

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.containerColor,
    this.image,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    final MainAxisAlignment m;
    if (icon == null && image == null) {
      m = MainAxisAlignment.center;
    } else {
      m = MainAxisAlignment.spaceBetween;
    }
    return GestureDetector(
      onTap: onPressed, // Call the onPressed function when tapped
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // width: double.infinity,
        // height: 60,
        decoration: BoxDecoration(
          color: containerColor,
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
            mainAxisAlignment: m,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                // label text of the button
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (image != null) // Check if an image is provided
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 20),
                  child: Image(
                    image: image!,
                  ),
                ),
              if (icon != null) // check if an icon is provided
                Padding(
                  padding: const EdgeInsets.only(top: 1, right: 20),
                  child: Icon(
                    icon!,
                    color: textColor,
                  ),
                ),
            ]),
      ),
    );
  }
}
