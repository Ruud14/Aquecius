import 'package:Aquecius/constants.dart';
import 'package:Aquecius/objects/datestat.dart';
import 'package:Aquecius/services/supabase_database.dart';
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
  String? initialKind;

  // The actual data.
  List<DateStat>? data;

  // Gets the data for the graph from the database.
  void getData() async {
    final dataFetchResult = await SupaBaseDatabaseService.getGraphData(kind: kind, period: period);
    if (dataFetchResult.isSuccessful) {
      data = dataFetchResult.data;
      print(data!.map((e) => e.stat));
      if (mounted) {
        setState(() {});
      }
    } else {
      context.showErrorSnackBar(message: "Could not fetch graph data.");
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Get the kind of page to be shown.
    if (initialKind == null) {
      initialKind = ModalRoute.of(context)!.settings.arguments as String;
      if (kinds.contains(initialKind)) {
        kind = initialKind!;
      }
    }
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
            initialItem: kind,
            items: kinds,
            onChanged: (String value) {
              setState(() {
                data = null;
                kind = value;
              });
              getData();
            },
          ),
          SizedBox(
            height: 10.sp,
          ),
          // Period selector
          Selector(
            initialItem: period,
            items: periods,
            onChanged: (String value) {
              setState(() {
                data = null;
                period = value;
              });
              getData();
            },
          ),
          SizedBox(
            height: 50.sp,
          ),
          data != null
              ?
              // Statistics graph
              StatisticsGraph(
                  period: period,
                  kind: kind,
                  data: data!,
                )
              : const CircularProgressIndicator(),
          SizedBox(
            height: 30.h,
          ),
          (data != null && data!.length >= 2) ? generateTotalWidget() : const SizedBox(),
        ],
      ),
    );
  }

  Widget generateTotalWidget() {
    if (data == null) {
      return const SizedBox();
    }
    if (kind == "Consumption") {
      return Column(
        children: [
          Text("Total consumption:  ${data!.map((e) => e.stat).toList().reduce((a, b) => a + b)} L"),
          const SizedBox(
            height: 5,
          ),
          Text("Average temperature:  ${(data!.map((e) => e.stat).toList().reduce((a, b) => a + b) / data!.length).toStringAsFixed(1)} L")
        ],
      );
    }
    if (kind == "Temperature") {
      return Text("Average temperature:  ${(data!.map((e) => e.stat).toList().reduce((a, b) => a + b) / data!.length).toStringAsFixed(1)} °C");
    }
    if (kind == "Time") {
      return Column(
        children: [
          Text("Total time:  ${data!.map((e) => e.stat).toList().reduce((a, b) => a + b)} minutes"),
          const SizedBox(
            height: 5,
          ),
          Text("Average time:  ${(data!.map((e) => e.stat).toList().reduce((a, b) => a + b) / data!.length).toStringAsFixed(1)} minutes"),
        ],
      );
    }
    return const SizedBox();
  }
}
