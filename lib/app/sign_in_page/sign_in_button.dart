import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    required String text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
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
