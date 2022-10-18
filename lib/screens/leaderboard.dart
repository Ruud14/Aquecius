import 'package:Aquecius/widgets/dropdowns.dart';
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
  String selectedGroup = "Friends";

  @override
  Widget build(BuildContext context) {
    Widget thingy = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              child: Text("4"),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              "Some other name",
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
            const Expanded(child: SizedBox()),
            Text(
              "50L",
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );

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
                  items: <String>['Consumption', 'Temperature', 'Time'].map((String value) {
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
                      });
                    }
                  },
                ),
              ),
              // HairTexture dropdown
              SizedBox(
                width: 190.sp,
                child: CustomDropdown(
                  items: <String>['Friends', 'Family'].map((String value) {
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
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.sp,
          ),
          // Trophy row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50.sp,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Image.asset(
                      "assets/images/trophy2.png",
                      width: 90.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Ava Gabriel"),
                  Text("45 L"),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 70.sp,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Image.asset(
                      "assets/images/trophy1.png",
                      width: 135.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Ava Gabriel"),
                  Text("45 L"),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 50.sp,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Image.asset("assets/images/trophy3.png", width: 90.sp),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Ava Gabriel"),
                  Text("45 L"),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
          thingy,
        ],
      ),
    );
  }
}
