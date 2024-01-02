import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/clocks/clocks_provider.dart';
import 'package:world_clock/global/components/map_screen.dart';
import 'package:world_clock/global/constants/appcolors.dart';

class ClockDetails extends StatefulWidget {
  final double latitude, longitude;
  final String city, country, currency;
  final double gmt;
  const ClockDetails(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.city,
      required this.country,
      required this.currency,
      required this.gmt});

  @override
  State<ClockDetails> createState() => _ClockDetailsState();
}

class _ClockDetailsState extends State<ClockDetails> {
  DateTime current = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ClocksProvider>(context, listen: false)
        .getdailyweather(widget.city);
    Provider.of<ClocksProvider>(context, listen: false).getCurrentLocation();
    Provider.of<ClocksProvider>(context, listen: false)
        .fetchExchangeRate(widget.currency);
    Provider.of<ClocksProvider>(context, listen: false).getweather(widget.city);
    // Provider.of<ClocksProvider>(context, listen: false)
    //     .fetchExchangeRate(widget.currency);

    Provider.of<ClocksProvider>(context, listen: false)
        .getCurrentTime(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Consumer<ClocksProvider>(builder: (context, provider, child) {
            Provider.of<ClocksProvider>(context, listen: false)
                .fetchExchangeRate(provider.currency);
            Timer.periodic(Duration(minutes: 1), (timer) {
              //provider.setcurrentTime('');
              provider.getCurrentTime(provider.latitude, provider.longitude);
            });
            return Center(
              child: provider.forecast.isEmpty
                  ? CircularProgressIndicator(
                      color: AppColors.primary,
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.city + ' , ' + widget.country,
                                  maxLines: null,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(widget.gmt.toString() + ' | GMT')
                              ],
                            ),

                            Text(provider.currentTime)
                            // Container(
                            //   height: 50,
                            //   width: 50,
                            //   child: AnalogClock(
                            //     secondHandColor: AppColors.primary,
                            //     datetime: provider.time,
                            //   ),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            provider.weathericon.isEmpty
                                ? Text('Loading')
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                              image: NetworkImage(
                                                  'http://openweathermap.org/img/w/${provider.weathericon}.png',
                                                  scale: 1.2)),
                                          Text(provider.weatherdescription
                                              .toString())
                                        ],
                                      ),
                                      Text(
                                        provider.weathertemp,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        provider.minmax,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('1 ' + widget.currency),
                                Text(
                                  provider.exchangeRate.toString() +
                                      ' ' +
                                      provider.home,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.forecast.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        //  DateFormat.DAY().
                                        DateFormat('EEE').format(
                                            provider.forecast[index].date!),
                                        style: TextStyle(fontSize: 13),
                                        // provider.forecast[index].date
                                        //     .toString()
                                      ),
                                      Image(
                                          image: NetworkImage(
                                              'http://openweathermap.org/img/w/${provider.forecast[index].weatherIcon!}.png',
                                              scale: 1.2)),
                                      Text(
                                        provider.forecast[index].tempMax!
                                                .celsius!
                                                .round()
                                                .toString() +
                                            '°C' +
                                            ' / ' +
                                            provider.forecast[index].tempMin!
                                                .celsius!
                                                .round()
                                                .toString() +
                                            '°C'.toString(),
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: double.infinity,
                                child: FlutterMapPage(
                                    latitude: widget.latitude,
                                    longitude: widget.longitude))),
                      ],
                    ),
            );
          })),
    ));
  }
}
