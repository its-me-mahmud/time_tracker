import 'package:flutter/material.dart';

import 'package:time_tracker/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({@required this.onSignOut, @required this.auth});

  final VoidCallback onSignOut;
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
