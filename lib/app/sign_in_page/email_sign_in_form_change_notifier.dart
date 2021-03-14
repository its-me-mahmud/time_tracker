import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_change_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _submit() async {
    try {
      await model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      await showExceptionAlertDialog(
        context: context,
        title: 'Sign In Failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    final nextFocusNode = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 8),
      FormSubmitButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryText,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        style: TextButton.styleFrom(primary: Colors.black),
        child: Text(model.secondaryText),
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      enabled: model.isLoading == false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      enabled: model.isLoading == false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '********',
        errorText: model.passwordErrorText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
