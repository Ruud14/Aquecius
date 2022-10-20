import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom wrapper for every page.
/// Includes safeArea, Scaffold, and Scrollability.
class ScrollablePage extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  const ScrollablePage({
    Key? key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hPadding = 12 + 20.sp;
    final vPadding = 18 + 25.sp;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding - 10),
            child: bottomNavigationBar,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: appBar,
          body: RefreshIndicator(
            onRefresh: onRefresh ?? () async {},
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
