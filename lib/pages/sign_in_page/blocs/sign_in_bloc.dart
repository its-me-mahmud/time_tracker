import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/services/auth_service.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final AuthBase auth;

  final _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() => _isLoadingController.close();

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signIn) async {
    try {
      _setIsLoading(true);
      return await signIn();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<User?> signInWithFacebook() async => _signIn(auth.signInWithFacebook);

  Future<User?> signInAnonymously() async => _signIn(auth.signInAnonymously);
}
