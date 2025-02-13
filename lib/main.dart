import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/helper/service_locator.dart';
import 'package:meet_me/src/auth/bloc/auth_cubit.dart';
import 'package:meet_me/src/auth/ui/auth_screen.dart';
import 'package:meet_me/src/call/bloc/call_cubit.dart';

import 'firebase_options.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => getIt<AuthCubit>(), lazy: true),
        BlocProvider<CallCubit>(
            create: (context) => getIt<CallCubit>(), lazy: true),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meet me',
        theme: ligthTheme,
        home: const AuthScreen(),
      ),
    );
  }
}
