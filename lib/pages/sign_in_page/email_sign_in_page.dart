import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth_service.dart';

import 'widgets/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: EmailSignInForm(auth: auth),
        ),
      ),
    );
  }
}
