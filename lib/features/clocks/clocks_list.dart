import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_clock/features/clocks/clock_details.dart';
import 'package:world_clock/features/clocks/clock_list_provider.dart';
import 'package:world_clock/features/clocks/clocks_provider.dart';
import 'package:world_clock/global/constants/appcolors.dart';
import 'package:world_clock/global/sqflite/data_model.dart';

class ClockList extends StatefulWidget {
  const ClockList({super.key});

  @override
  State<ClockList> createState() => _ClockListState();
}

class _ClockListState extends State<ClockList> {
  late bool res;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ClockListProvider>(context, listen: false).getlist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Consumer<ClockListProvider>(builder: (context, provider, chid) {
          return FutureBuilder<bool>(
              future: provider.checklist(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                if (snapshot.data == true) {
                  return ListView.builder(
                      itemCount: provider.datamodel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            tileColor: AppColors.mywhite,
                            title: Text(
                              provider.datamodel[index].city +
                                  ', ' +
                                  provider.datamodel[index].country,
                              maxLines: null,
                              softWrap: true,
                            ),
                            titleTextStyle: TextStyle(color: AppColors.primary),
                            trailing: Icon(
                              EneftyIcons.arrow_right_3_outline,
                              size: 15,
                            ),
                            onTap: () {
                              Provider.of<ClocksProvider>(context,
                                      listen: false)
                                  .setlatitude(
                                      provider.datamodel[index].latitude);
                              Provider.of<ClocksProvider>(context,
                                      listen: false)
                                  .setlongitude(
                                      provider.datamodel[index].longitude);
                              Provider.of<ClocksProvider>(context,
                                          listen: false)
                                      .currency =
                                  provider.datamodel[index].currency;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClockDetails(
                                        latitude:
                                            provider.datamodel[index].latitude,
                                        longitude:
                                            provider.datamodel[index].longitude,
                                        city: provider.datamodel[index].city,
                                        country:
                                            provider.datamodel[index].country,
                                        currency:
                                            provider.datamodel[index].currency,
                                        gmt: provider.datamodel[index].gmt)),
                              );
                            },
                          ),
                        );
                      });
                }
                if (snapshot.data == false) {
                  return Center(
                    child: Text(
                      'No Cities Added',
                      style: TextStyle(fontSize: 20, color: AppColors.primary),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Error Occurred',
                    style: TextStyle(fontSize: 20, color: AppColors.primary),
                  ),
                );
              });
        }),
      ),
    ));
  }
}
