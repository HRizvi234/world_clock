// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:world_clock/features/clocks/clocks_provider.dart';
// import 'package:world_clock/global/constants/appcolors.dart';
// import 'package:worldtime/worldtime.dart';

// class ClocksScreen extends StatefulWidget {
//   const ClocksScreen({super.key});

//   @override
//   State<ClocksScreen> createState() => _ClocksScreenState();
// }

// class _ClocksScreenState extends State<ClocksScreen> {
//   String clocktime = '';

//   Future<void> getCurrentTime(double latitude, double longitude) async {
//     Worldtime worldTime = Worldtime();
//     DateTime time = await worldTime.timeByLocation(
//         latitude: latitude, longitude: longitude);

//     clocktime = DateFormat('h:mm a').format(time);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Provider.of<ClocksProvider>(context, listen: false).getlist();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             body: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       child: Consumer<ClocksProvider>(builder: (context, provider, cild) {
//         return provider.datamodel.isEmpty
//             ? Center(
//                 child: Text(
//                   'No cities added',
//                   style: TextStyle(fontSize: 20, color: AppColors.primary),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: provider.datamodel.length,
//                 itemBuilder: (context, index) {
//                   // String time = provider
//                   //     .getCurrentTime(provider.datamodel[index].latitude,
//                   //         provider.datamodel[index].longitude)
//                   //     .toString();
//                   provider.getdailyweather(provider.datamodel[index].city);
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   provider.datamodel[index].city +
//                                       ' , ' +
//                                       provider.datamodel[index].country,
//                                   maxLines: null,
//                                   softWrap: true,
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(provider.datamodel[index].gmt.toString() +
//                                     ' | GMT')
//                               ],
//                             ),
//                             Text(provider.currentTime)
//                             // Container(
//                             //   height: 50,
//                             //   width: 50,
//                             //   child: AnalogClock(
//                             //     secondHandColor: AppColors.primary,
//                             //     datetime: provider.time,
//                             //   ),
//                             // )
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             provider.weathericon.isEmpty
//                                 ? Text('Loading')
//                                 : Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Image(
//                                               image: NetworkImage(
//                                                   'http://openweathermap.org/img/w/${provider.weathericon}.png',
//                                                   scale: 1.2)),
//                                           Text(provider.weatherdescription
//                                               .toString())
//                                         ],
//                                       ),
//                                       Text(
//                                         provider.weathertemp,
//                                         style: TextStyle(fontSize: 20),
//                                       ),
//                                       Text(
//                                         provider.minmax,
//                                         style: TextStyle(fontSize: 12),
//                                       )
//                                     ],
//                                   ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text('1 ' + provider.datamodel[index].currency),
//                                 Text(
//                                   provider.exchangeRate.toString() ??
//                                       '0.0' + ' RS ',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//       }),
//     )));
//   }
// }
