import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/widgets/selectors.dart';
import 'package:Aquecius/widgets/statistics_graph.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<String> kinds = ["Consumption", "Temperature", "Time"];
  String kind = "Consumption";
  List<String> periods = ["Week", "Month", "Year"];
  String period = "Week";
  // The actual data.
  // We only want to fetch what is actually shown, so we keep separate lists and load them with data once necessary.
  // Week
  List<double>? weekConsumptions;
  List<double>? weekTemperatures;
  List<double>? weekTimes;
  // Month
  List<double>? monthConsumptions;
  List<double>? monthTemperatures;
  List<double>? monthTimes;
  // Year
  List<double>? yearConsumptions;
  List<double>? yearTemperatures;
  List<double>? yearTimes;

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      bottomNavigationBar: const BottomCardsNavigationBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Page title row with back button.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 36,
                  )),
              Text(
                "Statistics",
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              // Transparent icon for equal spacing.
              InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.logout,
                    size: 36,
                    color: Colors.transparent,
                  ))
            ],
          ),
          SizedBox(
            height: 30.sp,
          ),
          // Kind selector
          Selector(
            items: kinds,
            onChanged: (String value) {
              setState(() {
                kind = value;
              });
            },
          ),
          SizedBox(
            height: 10.sp,
          ),
          // Period selector
          Selector(
            items: periods,
            onChanged: (String value) {
              setState(() {
                period = value;
              });
            },
          ),
          SizedBox(
            height: 50.sp,
          ),
          // Statistics graph
          StatisticsGraph(
            period: period,
            kind: kind,
          )
        ],
      ),
    );
  }
}

class DateStat {
  DateTime dateTime;
  double stat;
  DateStat({
    required this.dateTime,
    required this.stat,
  });

  DateStat.fromJson(Map<String, dynamic> json)
      : dateTime = json['started_at'],
        stat = json['stat'];
}
