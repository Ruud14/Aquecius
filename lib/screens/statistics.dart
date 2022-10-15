import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Text("Statistics"),
      bottomNavigationBar: BottomCardsNavigationBar(),
    );
  }
}
