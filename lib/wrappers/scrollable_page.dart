import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom wrapper for every page.
/// Includes safeArea, Scaffold, and Scrollability.
class ScrollablePage extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  const ScrollablePage({Key? key, required this.child, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: appBar,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18 + 25.sp, horizontal: 12 + 35.sp),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}