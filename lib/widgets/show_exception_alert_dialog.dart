import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/show_alert_dialog.dart';

Future<bool?> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required Exception exception,
}) {
  return showAlertDialog(
    context: context,
    title: title,
    content: _message(exception),
    defaultActionText: 'Ok',
  );
}

String? _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}
