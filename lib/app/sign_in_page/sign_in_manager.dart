import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

class SignInManager {
  const SignInManager({required this.auth, required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> _signIn(Future<User?> Function() signIn) async {
    try {
      isLoading.value = true;
      return await signIn();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<User?> signInWithFacebook() async => _signIn(auth.signInWithFacebook);

  Future<User?> signInAnonymously() async => _signIn(auth.signInAnonymously);
}
