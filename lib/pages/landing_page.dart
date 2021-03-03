import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'sign_in_page/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  void _updatedUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _updatedUser(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(onSignIn: _updatedUser);
    }
    return HomePage(onSignOut: () => _updatedUser(null));
  }
}
