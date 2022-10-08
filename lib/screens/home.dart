import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/states/auth_required_state.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AuthRequiredState<HomeScreen> {
  late final Stream<List<ShowerSession>> sessionsStream;

  @override
  void initState() {
    super.initState();
  }

  void startShower() {
    // TODO: Implement shower starting.
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.sp, vertical: 25.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Profile icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FourDotsButton(),
              CircleAvatar(
                radius: 30.sp,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 29,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          // Welcome text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi Peter 👋",
                style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w900, fontSize: 36.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Welcome to Aquecius",
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          // Shower summary card
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              color: Theme.of(context).colorScheme.primary,
            ),
            height: 138.h,
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                // Stats
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Last shower",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Consumption
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/waterdrop.png",
                                        width: 22.sp,
                                        height: 22.sp,
                                      ),
                                      const Text(
                                        "69L",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Temperature
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/fire.png",
                                        width: 22.sp,
                                        height: 22.sp,
                                      ),
                                      const Text(
                                        "34 °C ",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/time.png",
                                        width: 22.sp,
                                        height: 22.sp,
                                      ),
                                      const Text(
                                        "14 min",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              // Consumption percentage
                              Text(
                                "+20%",
                                style: TextStyle(color: Colors.red),
                              ),
                              // Temperature percentage
                              Text(
                                "-2%",
                                style: TextStyle(color: Colors.green),
                              ),
                              // Time percentage
                              Text(
                                "+12%",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Start shower button
                GestureDetector(
                  onTap: startShower,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/shower.png",
                            width: 49.sp,
                            height: 49.sp,
                            color: Colors.white,
                          ),
                          const Text(
                            "Start",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30.sp,
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          // Your statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(text: 'Your '),
                    TextSpan(text: 'Statistics', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PurpleButton(text: "Details"),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          // Cards
          GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            mainAxisSpacing: 25.sp,
            crossAxisSpacing: 25.sp,
            children: const [
              HomePageCard(image: "assets/images/waterdrop.png", text: "62 L", subscript: "Past 7 days"),
              HomePageCard(image: "assets/images/time.png", text: "12 min", subscript: "Average"),
              HomePageCard(image: "assets/images/fire.png", text: "35 °C", subscript: "Average"),
              HomePageCard(image: "assets/images/flag.png", text: "#31", subscript: "In Family"),
            ],
          ),
        ]),
      ),
    );
  }
}
