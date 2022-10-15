import 'package:Aquecius/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomCardsNavigationBar extends StatelessWidget {
  const BottomCardsNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // Spacer line
      Container(
        color: Theme.of(context).colorScheme.secondary,
        height: 1,
        width: 1000.w,
      ),
      SizedBox(
        height: 20.sp,
      ),
      // Bottom cards
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          BottomCard(
            image: "assets/images/waterdrop.png",
            route: "/statistics",
          ),
          BottomCard(
            image: "assets/images/time.png",
            route: "/statistics",
          ),
          BottomCard(
            image: "assets/images/fire.png",
            route: "/statistics",
          ),
          BottomCard(
            image: "assets/images/flag.png",
            route: "/leaderboard",
          )
        ],
      )
    ]);
  }
}
