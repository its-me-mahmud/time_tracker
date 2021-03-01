import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
          onPressed: onPressed,
          color: color,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: 15,
            ),
          ),
        );
}
