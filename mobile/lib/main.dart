import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/splash_page.dart';
import 'pages/loading_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticatedState) {
              return const HomePage();
            }

            if (state is AuthenticationUnauthenticatedState) {
              return const LoginPage();
            }

            if (state is AuthenticationLoadingState) {
              return const LoadingPage();
            }

            return const SplashPage();
          }
        )
      )
    );
  }
}