import 'package:Aquecius/objects/userstat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderBoardTile extends StatefulWidget {
  final UserStat stat;
  final int index;
  const LeaderBoardTile({
    super.key,
    required this.stat,
    required this.index,
  });

  @override
  State<LeaderBoardTile> createState() => _LeaderBoardTileState();
}

class _LeaderBoardTileState extends State<LeaderBoardTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(widget.index.toString()),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.stat.username,
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
            const Expanded(child: SizedBox()),
            Text(
              widget.stat.stat.toStringAsFixed(1),
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
