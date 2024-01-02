import 'dart:convert';

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:world_clock/features/clocks/clocks_screen.dart';
import 'package:world_clock/features/search/search_provider.dart';
import 'package:world_clock/global/components/custom_button.dart';
import 'package:world_clock/global/components/digital_clock.dart';
import 'package:world_clock/global/components/flutter_open_map.dart';
import 'package:world_clock/global/components/map_screen.dart';

import 'package:world_clock/global/components/search_bar.dart';
import 'package:world_clock/global/components/web_map.dart';
import 'package:world_clock/global/constants/appcolors.dart';
import 'package:world_clock/global/constants/citylist.dart';
import 'package:world_clock/global/providers/map_provider.dart';
import 'package:world_clock/global/sqflite/city_db.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController txtsearch = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).getcitites();
    // Provider.of<SearchProvider>(context, listen: false).findcountry();
  }

  @override
  Widget build(BuildContext context) {
    // List<dynamic> cities = jsonDecode(jsonCity);
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MySearchBar(
                text: 'Search City',
                controller: txtsearch,
                onchange: (value) {
                  Provider.of<SearchProvider>(context, listen: false)
                      .setforecast([]);
                  Provider.of<SearchProvider>(context, listen: false)
                      .setcityname('');
                  Provider.of<SearchProvider>(context, listen: false)
                      .filter(txtsearch.text);
                  Provider.of<SearchProvider>(context, listen: false)
                      .forecast
                      .clear();
                  Provider.of<SearchProvider>(context, listen: false)
                      .setlatitude(0);
                  Provider.of<SearchProvider>(context, listen: false)
                      .setlongitude(0);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<SearchProvider>(builder: (context, provider, child) {
                return provider.cityname.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                            itemCount: provider.filtercities.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(provider.filtercities[index]['name']),
                                onTap: () async {
                                  provider.setcityname(
                                      provider.filtercities[index]['name']);
                                  Provider.of<MapProvider>(context,
                                          listen: false)
                                      .latitude = provider.latitude;
                                  Provider.of<MapProvider>(context,
                                          listen: false)
                                      .longitude = provider.longitude;
                                  provider.setlatitude(provider.latitude);
                                  provider.setlongitude(provider.longitude);
                                  //setState(() {});
                                  // Future.delayed(Duration(seconds: 3));

                                  // await provider.getCurrentTime(
                                  //     provider.filtercities[index].name);
                                  await provider
                                      .getdailyweather(provider.cityname);
                                  provider.forecast.clear();

                                  await provider.getweather(provider.cityname);
                                },
                              );
                            }))
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.cityname +
                                        ' , ' +
                                        provider.countryname,
                                    maxLines: null,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(provider.soffset + ' | GMT')
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
                                  Text('1 ' + provider.currency),
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
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: double.infinity,
                                  child: provider.latitude == 0 &&
                                          provider.longitude == 0
                                      ? Container()
                                      : FlutterMapPage(
                                          latitude: provider.latitude,
                                          longitude: provider.longitude))),
                          CustomButton(
                              text: 'Add',
                              textColor: AppColors.mywhite,
                              containerColor: AppColors.primary,
                              onPressed: () async {
                                await cityDB().create(
                                    city: provider.cityname,
                                    country: provider.countryname,
                                    currency: provider.currency,
                                    latitude: provider.latitude,
                                    longitude: provider.longitude,
                                    gmt: provider.gmt);
                                Fluttertoast.showToast(
                                  msg: 'City Added !',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 12.0,
                                );
                              })
                        ],
                      );
              })
            ],
          ),
        ),
      )),
    );
  }
}
