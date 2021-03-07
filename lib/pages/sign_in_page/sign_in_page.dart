import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/services/auth_service.dart';
import 'package:time_tracker/widgets/show_exception_alert_dialog.dart';

import 'email_sign_in_page.dart';
import 'widgets/sign_in_button.dart';
import 'widgets/social_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') return;

    showExceptionAlertDialog(
      context: context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => _isLoading = true);

      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
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
          SizedBox(height: 50, child: _buildHeader()),
          const SizedBox(height: 48),
          SocialSignInButton(
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
            assetPath: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
          ),
          const SizedBox(height: 8),
          SocialSignInButton(
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
            assetPath: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xFF443D92),
            textColor: Colors.white,
          ),
          const SizedBox(height: 8),
          SignInButton(
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
            text: 'Go Anonymous',
            color: Colors.lime.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
