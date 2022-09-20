import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:showerthing/states/auth_required_state.dart';
import 'package:showerthing/wrappers/scrollable_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AuthRequiredState<HomeScreen> {
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
            color: Colors.red,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add random database entry"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Remove random database entry"),
          )
        ],
      ),
    );
  }
}
