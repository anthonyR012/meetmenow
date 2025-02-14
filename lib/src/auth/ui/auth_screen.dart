import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_me/src/auth/bloc/auth_cubit.dart';
import 'package:meet_me/src/auth/ui/widgets/button_primary_widget.dart';
import 'package:meet_me/src/auth/ui/widgets/text_field_primary_widget.dart';
import 'package:meet_me/src/home/ui/home_screen.dart';



class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset("assets/images/signup_illustration.svg", height: 180),
            const SizedBox(height: 20),
            const Text(
              "Get Started Free",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "Free Forever. No Credit Card Needed",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),
            TextFieldPrimary(hint: "user@example.com",controller: _emailController,),
            const SizedBox(height: 20),
            TextFieldPrimary(
              hint: "Password",
              hasObscure: true,
              controller: _passwordController,
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
            const SizedBox(height: 10),
            ButtonPrimaryWidget(onPressed: () {
                context.read<AuthCubit>().signIn(
                    userName: _emailController.text.trim(),
                    password: _passwordController.text.trim());
            },title: "Sign In",),

            const SizedBox(height: 20),
            ButtonPrimaryWidget(
              onPressed: () {
                 context.read<AuthCubit>().signUp(
                    userName: _emailController.text.trim(),
                    password: _passwordController.text.trim());
              },
              title: "Sing Up",
              textColor: Colors.white,
              buttonColor: Colors.purple.withOpacity(0.5),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
