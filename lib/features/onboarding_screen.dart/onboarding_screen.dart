import 'package:flutter/material.dart';
import 'package:world_clock/features/bottom_navigation/bottom_navigation_screen.dart';
import 'package:world_clock/features/home/screen/home_screen.dart';
import 'package:world_clock/global/components/custom_button.dart';
import 'package:world_clock/global/constants/appcolors.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'World Clock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/onboard.png'),
                            fit: BoxFit.fill)),
                  ),
                  Text(
                    'The world Clock in one tap away',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry'
                    's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type  Lorem Ipsum',
                    textAlign: TextAlign.center,
                    maxLines: null,
                    softWrap: true,
                  )
                ],
              ),
              Column(
                children: [
                  CustomButton(
                      text: 'Continue',
                      textColor: Colors.white,
                      containerColor: AppColors.primary,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen()));
                      }),
                  // Spacer(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Please read our'), // text can be changed
                      const SizedBox(
                        width: 3,
                      ),
                      // this is to make text clickable and will open a browser page that contains privacy policy
                      GestureDetector(
                        child: Text(
                          'Terms & Conditions', // text can be changed
                          style: TextStyle(
                              decoration: TextDecoration
                                  .underline, // style and color can be changed
                              color: AppColors.primary),
                        ),
                        onTap: () async {
                          // this will open the company's privacy policy web page in browser.
                          final Uri url = Uri.parse(
                              'http://elabdisb.com/privacy-policy.html'); // url can be changed
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
