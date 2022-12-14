import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/family.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
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
  /// The last session from the current user.
  ShowerSession? lastSession;

  /// The profile of the current user.
  Profile? profile;

  /// The family of the current user.
  Family? family;

  /// Whether data from the database is being loaded.
  bool isLoading = true;

  /// Last session percentage in/decreases
  int? consumptionIncreasePercentage;
  int? durationIncreasePercentage;
  int? temperatureIncreasePercentage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch the last session from the current user form the database.
  Future<void> fetchLastSession() async {
    final lastSessionFetchResult = await SupaBaseDatabaseService.getLastSession();
    if (lastSessionFetchResult.isSuccessful) {
      lastSession = lastSessionFetchResult.data;
      final cons = await SupaBaseDatabaseService.getPastConsumptionAverage(lastSession!);
      final dur = await SupaBaseDatabaseService.getPastDurationAverage(lastSession!);
      final temp = await SupaBaseDatabaseService.getPastTemperatureAverage(lastSession!);
      if (cons.isSuccessful && dur.isSuccessful && temp.isSuccessful) {
        final averageConsumptionOfLastWeek = cons.data.toDouble();
        final averageDurationOfLastWeek = dur.data;
        final averageTemperatureOfLastWeek = temp.data;

        consumptionIncreasePercentage = (((lastSession!.consumption - averageConsumptionOfLastWeek) / averageConsumptionOfLastWeek!) * 100).round();
        durationIncreasePercentage = (((lastSession!.durationMinutes - averageDurationOfLastWeek) / averageDurationOfLastWeek) * 100).round();
        temperatureIncreasePercentage =
            (((lastSession!.averageTemperature - averageTemperatureOfLastWeek!) / averageTemperatureOfLastWeek!) * 100).round();
      }
    }
  }

  // Fetch the family from the database and set 'family'.
  Future<void> fetchFamily() async {
    final familyFetchResult = await SupaBaseDatabaseService.getFamilyFromID(profile!.family!);
    if (familyFetchResult.isSuccessful) {
      family = familyFetchResult.data;
    } else {
      context.showErrorSnackBar(message: "Could not fetch family ${familyFetchResult.message}");
    }
  }

  /// Fetches all necessary data (for this page) from the database.
  Future<void> fetchData() async {
    // Get the user data.
    final profileFetchResult = await SupaBaseDatabaseService.getProfile(SupaBaseAuthService.uid!);
    if (profileFetchResult.isSuccessful) {
      profile = profileFetchResult.data;
    } else {
      if (mounted) {
        // Navigate to the account page to create profile data if no profile data is present.
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/account',
          (route) => false,
        );
        return;
      }
    }

    // Require the user to create/join a family if it hasn't already.
    if (profile!.family == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/join_family', (route) => false, arguments: profile);
      return;
    } else {
      // Fetch the family.
      await fetchFamily();
    }

    // Get the last session data.
    await fetchLastSession();
    // Stop loading.
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Set family.isShowering to the current user id.
  Future<void> setUserAsShoweringUser() async {
    family!.isShowering = SupaBaseAuthService.uid;
    final updateResult = await SupaBaseDatabaseService.updateFamily(family!);
    if (updateResult.isSuccessful) {
      context.showSnackBar(message: "Shower session started!");
    } else {
      context.showErrorSnackBar(message: "Starting shower failed ${updateResult.message}");
    }
    await fetchFamily();
    setState(() {});
  }

  // Seth family.isShowering to null.
  void stopShower() async {
    family!.isShowering = null;
    final updateResult = await SupaBaseDatabaseService.updateFamily(family!);
    if (updateResult.isSuccessful) {
      context.showSnackBar(message: "Shower session stopped!");
    } else {
      context.showErrorSnackBar(message: "Stopping shower failed ${updateResult.message}");
    }
    await fetchFamily();
    setState(() {});
  }

  /// Start a shower session.
  void startShower() async {
    // Make sure we're working with a recent version of the family.
    await fetchFamily();
    // Check if someone else is showering.
    if (![SupaBaseAuthService.uid, null].contains(family!.isShowering)) {
      // Ask user to set him/herself as the showering user.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            'Someone is already taking a shower...',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
              'One of your family members is already taking a shower. Do you want to cancel their shower session and start yours anyway?',
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                await setUserAsShoweringUser();
                Navigator.pop(context);
              },
              child: const Text('Start anyway', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      await setUserAsShoweringUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      onRefresh: fetchData,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Profile icon row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FourDotsButton(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/account").then((value) {
                        fetchData();
                      });
                    },
                    child: CircleAvatar(
                      radius: 25.sp,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.person,
                        size: 29,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 35.h,
              ),
              // Welcome text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi ${profile!.username} ????",
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
              GestureDetector(
                onTap: () {
                  if (lastSession != null) {
                    Navigator.pushNamed(context, "/summary", arguments: lastSession);
                  }
                },
                child: Container(
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
                          lastSession == null
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Expanded(
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
                                                  SizedBox(
                                                    width: 3.sp,
                                                  ),
                                                  Text(
                                                    "${lastSession!.consumption.round()} L",
                                                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                                                  SizedBox(
                                                    width: 3.sp,
                                                  ),
                                                  Text(
                                                    "${lastSession!.averageTemperature} ??C ",
                                                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                                                  SizedBox(
                                                    width: 3.sp,
                                                  ),
                                                  Text(
                                                    "${lastSession!.durationMinutes} min",
                                                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                                      temperatureIncreasePercentage != null ? generateDifferencesTexts() : const SizedBox(),
                                    ],
                                  ),
                                ),
                        ],
                      ),

                      // Start shower button
                      GestureDetector(
                        onTap: family!.isShowering == SupaBaseAuthService.uid ? stopShower : startShower,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                family!.isShowering == SupaBaseAuthService.uid
                                    ? Icon(
                                        Icons.stop_circle_outlined,
                                        color: Colors.red,
                                        size: 49.sp,
                                      )
                                    : Image.asset(
                                        "assets/images/shower.png",
                                        width: 49.sp,
                                        height: 49.sp,
                                        color: Colors.white,
                                      ),
                                Text(
                                  family!.isShowering == SupaBaseAuthService.uid ? "Stop" : "Start",
                                  style: TextStyle(color: family!.isShowering == SupaBaseAuthService.uid ? Colors.red : Colors.white),
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
                  CustomRoundedButton(
                    text: "Details",
                    onPressed: () {
                      Navigator.pushNamed(context, "/statistics", arguments: "Consumption");
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              // Cards
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                mainAxisSpacing: 25.sp,
                crossAxisSpacing: 25.sp,
                children: [
                  HomePageCard(
                    image: "assets/images/waterdrop.png",
                    text: "62 L",
                    subscript: "Past 7 days",
                    onPressed: () {
                      Navigator.pushNamed(context, "/statistics", arguments: "Consumption");
                    },
                  ),
                  HomePageCard(
                    image: "assets/images/time.png",
                    text: "12 min",
                    subscript: "Average",
                    onPressed: () {
                      Navigator.pushNamed(context, "/statistics", arguments: "Time");
                    },
                  ),
                  HomePageCard(
                    image: "assets/images/fire.png",
                    text: "35 ??C",
                    subscript: "Average",
                    onPressed: () {
                      Navigator.pushNamed(context, "/statistics", arguments: "Temperature");
                    },
                  ),
                  HomePageCard(
                    image: "assets/images/flag.png",
                    text: "#31",
                    subscript: "In Family",
                    onPressed: () {
                      Navigator.pushNamed(context, "/leaderboard");
                    },
                  ),
                ],
              ),
            ]),
    );
  }

  /// Generates the text with weekly differences.
  Widget generateDifferencesTexts() {
    const red = Color(0xFFAD0606);
    const green = Color(0xFF008F17);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Consumption percentage
        Text(
          "${consumptionIncreasePercentage! > 0 ? '+' : ''}$consumptionIncreasePercentage%",
          style: TextStyle(color: consumptionIncreasePercentage! < 0 ? Colors.green : Colors.red),
        ),
        // Temperature percentage
        Text(
          "${temperatureIncreasePercentage! > 0 ? '+' : ''}$temperatureIncreasePercentage%",
          style: TextStyle(color: temperatureIncreasePercentage! < 0 ? Colors.green : Colors.red),
        ),
        // Time percentage
        Text(
          "${durationIncreasePercentage! > 0 ? '+' : ''}$durationIncreasePercentage%",
          style: TextStyle(color: durationIncreasePercentage! < 0 ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}
