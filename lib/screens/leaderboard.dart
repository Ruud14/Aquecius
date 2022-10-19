import 'package:Aquecius/constants.dart';
import 'package:Aquecius/objects/userstat.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:Aquecius/widgets/dropdowns.dart';
import 'package:Aquecius/widgets/leaderboard_tile.dart';
import 'package:Aquecius/widgets/nav_bar.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  String selectedKind = "Consumption";
  String selectedGroup = "All";
  // Data for the leaderBoard.
  List<UserStat>? data;

  // Populates 'data' with data from the backend.
  void getLeaderBoardData() async {
    final dataFetchResult = await SupaBaseDatabaseService.getLeaderBoardData(kind: selectedKind, group: selectedGroup);
    if (dataFetchResult.isSuccessful) {
      if (mounted) {
        setState(() {
          data = dataFetchResult.data;
        });
      }
    } else {
      if (mounted) {
        context.showErrorSnackBar(message: "Could not load leaderboard data: " + dataFetchResult.message.toString());
      }
    }
  }

  @override
  void initState() {
    getLeaderBoardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      bottomNavigationBar: BottomCardsNavigationBar(),
      child: Column(
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
                "Leaderboard",
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
          // Dropdown row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kind dropdown
              SizedBox(
                width: 190.sp,
                child: CustomDropdown(
                  items: <String>['Points', 'Consumption', 'Temperature', 'Time'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.substring(0, 1).toUpperCase() + value.substring(1),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  value: selectedKind,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedKind = value;
                        data = null;
                      });
                      getLeaderBoardData();
                    }
                  },
                ),
              ),
              // Group dropdown
              SizedBox(
                width: 190.sp,
                child: CustomDropdown(
                  items: <String>['All', 'Family'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.substring(0, 1).toUpperCase() + value.substring(1),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  value: selectedGroup,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedGroup = value;
                        data = null;
                      });
                      getLeaderBoardData();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.sp,
          ),
          data == null
              ? const CircularProgressIndicator()
              :
              // Trophy row
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50.sp,
                          backgroundColor: data!.length > 1 ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                          child: data!.length > 1
                              ? Image.asset(
                                  "assets/images/trophy2.png",
                                  width: 90.sp,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data!.length > 1 ? data![1].username : ""),
                        Text(data!.length > 1 ? data![1].stat.toStringAsFixed(1) : ""),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 70.sp,
                          backgroundColor: data!.length > 0 ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                          child: data!.length > 0
                              ? Image.asset(
                                  "assets/images/trophy1.png",
                                  width: 135.sp,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data!.length > 0 ? data![0].username : ""),
                        Text(data!.length > 0 ? data![0].stat.toStringAsFixed(1) : ""),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50.sp,
                          backgroundColor: data!.length > 2 ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                          child: data!.length > 2
                              ? Image.asset(
                                  "assets/images/trophy3.png",
                                  width: 90.sp,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data!.length > 2 ? data![2].username : ""),
                        Text(data!.length > 2 ? data![2].stat.toStringAsFixed(1) : ""),
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: 20.h,
          ),
          data != null && data!.length > 3
              ? Column(
                  children: data!.sublist(3).map((e) => LeaderBoardTile(stat: e, index: data!.indexOf(e))).toList(),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
