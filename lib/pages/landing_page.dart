import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth_service.dart';

import 'home_page.dart';
import 'sign_in_page/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage(auth: auth);
          }
          return HomePage(auth: auth);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
