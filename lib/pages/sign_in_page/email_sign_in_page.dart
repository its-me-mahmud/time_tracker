import 'package:flutter/material.dart';
import 'package:time_tracker/pages/sign_in_page/widgets/email_sign_in_form_bloc_based.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: EmailSignInFormBlocBased.create(context),
          ),
        ),
      ),
    );
  }
}
