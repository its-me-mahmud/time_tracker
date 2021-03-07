import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String assetPath,
    required String text,
    Color? color,
    Color? textColor,
    required VoidCallback? onPressed,
  }) : super(
          onPressed: onPressed,
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetPath),
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 15,
                ),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset(assetPath),
              ),
            ],
          ),
        );
}
