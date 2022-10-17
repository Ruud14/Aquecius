import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StatisticsGraph extends StatefulWidget {
  final String period;
  final String kind;
  const StatisticsGraph({
    super.key,
    required this.period,
    required this.kind,
  });

  @override
  State<StatisticsGraph> createState() => _StatisticsGraphState();
}

class _StatisticsGraphState extends State<StatisticsGraph> {
  @override
  Widget build(BuildContext context) {
    final data = [34, 36, 35, 40, 38, 36, 38];
    final yMin = data.reduce(min) - 1;
    final yMax = data.reduce(max) + 1;
    const height = 140.0;
    final yScale = height / (yMax - yMin);
    final graphColor = widget.kind == "Temperature"
        ? Colors.red
        : widget.kind == "Time"
            ? Colors.amber
            : Theme.of(context).colorScheme.secondary;
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
                    data
                        .map(
                          (e) => Container(
                            width: 10,
                            height: ((e - yMin) * yScale),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(22)),
                              color: graphColor,
                            ),
                          ),
                        )
                        .toList(),
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(22)),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["M", "T", "W", "T", "F", "S", "S"]
                      .map((e) => Text(
                            e,
                            style: const TextStyle(color: Colors.white),
                          ))
                      .toList() +
                  [Text("")]),
        )
      ],
    );
  }
}
