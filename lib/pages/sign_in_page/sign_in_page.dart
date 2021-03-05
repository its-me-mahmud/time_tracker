import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth_service.dart';

import 'file:///C:/Users/abdullah/flutter_projects/time_tracker/lib/pages/sign_in_page/email_sign_in_page.dart';

import 'widgets/sign_in_button.dart';
import 'widgets/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({required this.auth});

  final AuthBase auth;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString);
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(auth: auth),
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
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
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
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
            onPressed: _signInWithGoogle,
            assetPath: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
          ),
          const SizedBox(height: 8),
          SocialSignInButton(
            onPressed: _signInWithFacebook,
            assetPath: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xFF443D92),
            textColor: Colors.white,
          ),
          const SizedBox(height: 8),
          SignInButton(
            onPressed: () => _signInWithEmail(context),
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
