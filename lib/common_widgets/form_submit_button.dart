import 'package:flutter/material.dart';

import 'custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required VoidCallback? onPressed,
    required String text,
  }) : super(
          onPressed: onPressed,
          height: 44,
          borderRadius: 4,
          color: Colors.indigo,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
}
