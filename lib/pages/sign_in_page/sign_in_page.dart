import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/sign_in_button.dart';
import 'widgets/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInAnonymously() async {
    try {
      final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      print('${userCredentials.user.uid}');
    } catch (e) {
      print(e.toString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey.shade200,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 48),
          SocialSignInButton(
            onPressed: () {},
            assetPath: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
          ),
          const SizedBox(height: 8),
          SocialSignInButton(
            onPressed: () {},
            assetPath: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xFF443D92),
            textColor: Colors.white,
          ),
          const SizedBox(height: 8),
          SignInButton(
            onPressed: () {},
            text: 'Sign in with Email',
            color: Colors.teal.shade700,
            textColor: Colors.white,
          ),
          const SizedBox(height: 8),
          const Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SignInButton(
            onPressed: _signInAnonymously,
            text: 'Go Anonymous',
            color: Colors.lime.shade300,
          ),
        ],
      ),
    );
  }
}
