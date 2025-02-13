import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_me/src/auth/bloc/auth_cubit.dart';
import 'package:meet_me/src/home/ui/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to meet me!")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(username: state.user.email)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthInitial) {
                  return const SizedBox.shrink();
                } else if (state is AuthFailure) {
                  return Text(state.failure.message,
                      style: const TextStyle(color: Colors.red));
                }
                return const LinearProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().signIn(
                    userName: _emailController.text.trim(),
                    password: _passwordController.text.trim());
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().signUp(
                    userName: _emailController.text.trim(),
                    password: _passwordController.text.trim());
              },
              child: const Text("Create an account"),
            ),
          ],
        ),
      ),
    );
  }
}
