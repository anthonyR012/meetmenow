
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool isWaiting = true;

  @override
  void initState() {
    super.initState();
    [Permission.microphone, Permission.camera].request();
    _checkForParticipants();
  }

  void _checkForParticipants() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isWaiting = false;
    });
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
      body: Center(
        child: isWaiting
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Waiting for another user to join..."),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoCallScreen(),
                    ),
                  );
                },
                child: const Text("Join Video Call"),
              ),
      ),
    );
  }
}
