import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/main.dart';
import 'package:meet_me/src/auth/bloc/auth_cubit.dart';
import 'package:meet_me/src/call/ui/video_call_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String _channelId;

  @override
  void initState() {
    super.initState();
    _channelId = getIt<DotEnv>().env[keyChannelName] ?? "";
    [Permission.microphone, Permission.camera].request();
  }

  void _signOut() async {
    context.read<AuthCubit>().signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VideoCallScreen(channelId: _channelId)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.call, color: Colors.white),
                const SizedBox(width: 30),
                Text(
                  "Meet to $_channelId channel",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
