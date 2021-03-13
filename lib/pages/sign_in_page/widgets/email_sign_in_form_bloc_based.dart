import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/email_sign_in_model.dart';
import 'package:time_tracker/pages/sign_in_page/blocs/email_sign_in_bloc.dart';
import 'package:time_tracker/services/auth_service.dart';
import 'package:time_tracker/widgets/show_exception_alert_dialog.dart';

import 'form_submit_button.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
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
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final nextFocusNode = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 8),
      _buildPasswordTextField(model),
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

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      onChanged: widget.bloc.updatePassword,
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
    return StreamBuilder<EmailSignInModel>(
      initialData: EmailSignInModel(),
      stream: widget.bloc.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model!),
          ),
        );
      },
    );
  }
}
