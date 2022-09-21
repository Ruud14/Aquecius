import 'dart:math';
import 'package:flutter/material.dart';
import 'package:showerthing/constants.dart';
import 'package:showerthing/models/session.dart';
import 'package:showerthing/services/supabase_auth.dart';
import 'package:showerthing/services/supabase_database.dart';
import 'package:showerthing/states/auth_required_state.dart';
import 'package:showerthing/wrappers/scrollable_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AuthRequiredState<HomeScreen> {
  late final Stream<List<ShowerSession>> sessionsStream;

  @override
  void initState() {
    sessionsStream =
        supabase.from('sessions').stream(['id']).order('started_at').execute().map((maps) => maps.map((map) => ShowerSession.fromJson(map)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      appBar: AppBar(
        title: const Text("Shower Thing App Test"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/account");
              },
              icon: const Icon(Icons.person))
        ],
      ),
      child: Column(
        children: [
          const Text("Realtime view of database"),
          Container(
            height: 500,
            width: 1000,
            color: Colors.green,
            child: StreamBuilder<List<ShowerSession>>(
              stream: sessionsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final sessions = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sessions
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Shower session"),
                                      Text("Consumption: ${e.consumption} Liters "),
                                      Text("Duration: ${DateTime.parse(e.endedAt).difference(DateTime.parse(e.startedAt)).inMinutes} Minutes")
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                } else {
                  return const FittedBox(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              /// Random number generator.
              Random _rnd = Random();

              DateTime startTime = DateTime.now().add(Duration(minutes: -20 + _rnd.nextInt(40)));
              DateTime endTime = startTime.add(Duration(minutes: _rnd.nextInt(50)));

              final session = ShowerSession(
                id: null,
                startedAt: startTime.toIso8601String(),
                endedAt: endTime.toIso8601String(),
                consumption: _rnd.nextInt(100).toDouble(),
                userId: SupaBaseAuthService.auth.currentUser!.id,
              );

              final response = await SupaBaseDatabaseService.insertSession(session);
              if (mounted) {
                if (response.isSuccessful) {
                  context.showSnackBar(message: "Successfully created shower session!");
                } else {
                  context.showErrorSnackBar(message: response.message ?? "Creating shower session failed.");
                }
              }
            },
            child: const Text("Add random shower session to the database"),
          ),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {
              SupaBaseDatabaseService.deleteAllSessionsFromCurrentUser();
            },
            child: const Text("Clear all sessions from the database"),
          )
        ],
      ),
    );
  }
}
