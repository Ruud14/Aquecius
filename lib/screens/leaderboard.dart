import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Text("Leaderboard"),
      bottomNavigationBar: BottomCardsNavigationBar(),
    );
  }
}
