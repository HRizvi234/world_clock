import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:world_clock/features/home/home_provider.dart';
import 'package:world_clock/features/home/weather_model.dart';
import 'package:world_clock/global/constants/appcolors.dart';
import 'package:world_clock/global/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getCurrentLocation();

    // Provider.of<HomeProvider>(context, listen: false)
    //     .getCurrencyName('United States of America');
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider hp = Provider.of<HomeProvider>(context);
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.black45,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 214, 212, 212),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 25)
                  ], shape: BoxShape.circle, color: AppColors.mywhite),
                  width: double.infinity,
                  child: AnalogClock(
                    //   datetime: DateTime.now(),
                    secondHandColor: AppColors.primary,
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${hp.city} ',
                    style: TextStyle(fontSize: 24, color: AppColors.primary),
                  ),
                  Text(hp.country,
                      style: TextStyle(fontSize: 24, color: AppColors.primary)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                hp.timezone,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              hp.iconUrl.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 2),
                                  child: hp.iconUrl.isNotEmpty
                                      ? Image(
                                          image: NetworkImage(hp.iconUrl,
                                              scale: 1.2),
                                        )
                                      : Text('loading'),
                                ),
                                Text(
                                  '${hp.weather?.condition.toString()}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              '${hp.weather?.temperature.round().toString()}°C',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              '1 ${hp.currency}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              hp.exchangeRate.toString() + ' ' + hp.currentcode,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
