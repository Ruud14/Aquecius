import 'dart:math';

import 'package:Aquecius/objects/datestat.dart';
import 'package:flutter/material.dart';

class StatisticsGraph extends StatefulWidget {
  final String period;
  final String kind;
  final List<DateStat> data;
  const StatisticsGraph({
    super.key,
    required this.period,
    required this.kind,
    required this.data,
  });

  @override
  State<StatisticsGraph> createState() => _StatisticsGraphState();
}

class _StatisticsGraphState extends State<StatisticsGraph> {
  @override
  Widget build(BuildContext context) {
    final graphColor = widget.kind == "Temperature"
        ? Colors.red
        : widget.kind == "Time"
            ? Colors.green
            : Theme.of(context).colorScheme.secondary;
    final now = DateTime.now();
    final durationPeriodStart = (widget.period == "Week"
        ? now.subtract(const Duration(days: 7))
        : widget.period == "Month"
            ? DateTime(now.year, now.month - 1, now.day)
            : DateTime(now.year - 1, now.month, now.day));
    final daysCount = now.toUtc().difference(durationPeriodStart.toUtc()).inDays;
    // Compute a list of all days to be shown in the graph.
    final List<DateTime> days = [];
    for (int i = 1; i <= daysCount; i++) {
      days.add(durationPeriodStart.add(Duration(days: i)));
    }
    final List<DateStat> averagePerDay = [];

    // Get the average of all stats from per day.
    for (final day in days) {
      List<DateStat> dateStatsOnThisDay = widget.data
          .where(
            (element) => element.dateTime.year == day.year && element.dateTime.month == day.month && element.dateTime.day == day.day,
          )
          .toList();

      double y = -1;
      if (dateStatsOnThisDay.isNotEmpty) {
        y = dateStatsOnThisDay.reduce((a, b) => DateStat(dateTime: day, stat: a.stat + b.stat)).stat / dateStatsOnThisDay.length;
      }
      averagePerDay.add(DateStat(dateTime: day, stat: y));
    }

    // Compute the graph scale.
    final stats = averagePerDay.where((element) => element.stat >= 0).map((e) => e.stat);
    final yMin = (stats.reduce(min) - 1).toDouble();
    final yMax = (stats.reduce(max) + 1).toDouble();
    const height = 140.0;
    final yScale = height / (yMax - yMin);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // The actual graph
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List<Widget>.from(
                    averagePerDay.map(
                      (e) {
                        return Container(
                          width: 200 / daysCount,
                          height: e.stat >= 0 ? ((e.stat - yMin) * yScale) : 1,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(22)),
                            color: graphColor,
                          ),
                        );
                      },
                    ).toList(),
                  )),
            ),

            // Y - axis
            SizedBox(
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [yMax, yMin + 0.75 * (yMax - yMin), yMin + 0.25 * (yMax - yMin), yMin].map((e) => Text(e.toStringAsFixed(1))).toList(),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // Time axis
        generateXAxis()
      ],
    );
  }

  // Generates the x-axis
  Widget generateXAxis() {
    final weekDays = ["M", "T", "W", "T", "F", "S", "S"];
    final monthDays = ["3", "6", "9", "12", "15", "18", "21", "24", "27", "30"];
    final months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
    List<String> timelineItems = [];
    if (widget.period == "Week") {
      timelineItems = rotate(weekDays, DateTime.now().weekday);
    } else if (widget.period == "Year") {
      timelineItems = rotate(months, DateTime.now().month);
    } else if (widget.period == "Month") {
      timelineItems = rotate(monthDays, (DateTime.now().day / 3).round());
    }
    // Create the timeline
    final timeline = List<Widget>.from(timelineItems
        .map((e) => Text(
              e,
              style: const TextStyle(color: Colors.white),
            ))
        .toList());
    timeline[timeline.length - 1] = Text(
      timelineItems.last,
      style: TextStyle(color: widget.period != "Month" || DateTime.now().day.toString() == timelineItems.last ? Colors.yellow : Colors.white),
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, widget.period == "Week" ? 40 : 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: timeline),
      ),
    );
  }

  // Rotate a list by v.
  List<String> rotate(List<String> list, int v) {
    if (list.isEmpty) return list;
    var i = v % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }
}
