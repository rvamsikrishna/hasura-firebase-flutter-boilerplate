import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/models/user/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Auth {
  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  final ValueNotifier<User> currentUser;
  IdTokenResult tokenResult;
  StreamSubscription<FirebaseUser> _onAuthChange;
  StreamSubscription<DocumentSnapshot> _onUserTokenRefresh;

  //will be called to create an Auth instance.
  static Future<Auth> create() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    return Auth._(currentUser);
  }

  //Used to refer to the created Auth instance from anywhere in the widget tree.
  static Auth of(BuildContext context) {
    return Provider.of<Auth>(context, listen: false);
  }

  //Internal constructor which set the currentUser feild.
  Auth._(
    FirebaseUser currentUser,
  ) : this.currentUser = ValueNotifier<User>(
          currentUser != null ? User(currentUser) : User.empty(),
        );

  //Add a listener on the currentUser ValueNotifier.
  //Also listens for the authentication status of the user i.e logged in or logged out.
  FirebaseUser init(VoidCallback onUserChange) {
    currentUser.addListener(onUserChange);
    _onAuthChange =
        _firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) async {
      if (user != null) {
        tokenResult = await user.getIdToken(refresh: true);
        //checks if custom claims are set via cloud function that is
        //triggered on user create
        final hasuraClaims = tokenResult.claims['https://hasura.io/jwt/claims'];

        if (hasuraClaims == null) {
          //runs only once for new user
          final DocumentReference userMetaRef =
              Firestore.instance.collection('user-meta').document(user.uid);

          _onUserTokenRefresh =
              userMetaRef.snapshots().listen((DocumentSnapshot snap) async {
            //once we get the confirmation that user onCreate cloud function
            //is executed and custom claims are set, assign new token id
            //and cancel the subscription.
            if (snap.exists) {
              tokenResult = await user.getIdToken();
              _onUserTokenRefresh.cancel();
            } else {
              print('wait');
            }
          });
        }

        setAuthTokenForGraphQLServer(tokenResult.token);
        currentUser.value = User(user);
      } else {
        currentUser.value = User.empty();
      }
    });
    return currentUser.value.when((u) => u, empty: () => null);
  }

  Future<void> signUpWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e, st) {
      throw _throwAuthException(e, st);
    }
  }

  Future<void> loginWithEmail(
      {@required String email, @required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e, st) {
      throw _throwAuthException(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw AuthException.cancelled;
      }
      final auth = await account.authentication;
      await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: auth.idToken, accessToken: auth.accessToken),
      );
    } catch (e, st) {
      _throwAuthException(e, st);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      setAuthTokenForGraphQLServer(null);
    } catch (e, st) {
      _throwAuthException(e, st);
    }
  }

  void dispose(VoidCallback onUserChange) {
    _onAuthChange?.cancel();
    currentUser?.removeListener(onUserChange);
    _onUserTokenRefresh?.cancel();
  }

  AuthException _throwAuthException(dynamic e, StackTrace st) {
    print(e.runtimeType);
    print(e.toString());
    if (e is AuthException) {
      throw e;
    }
    FlutterError.reportError(FlutterErrorDetails(exception: e, stack: st));
    if (e is PlatformException) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw const AuthException(
              'The email address is already in use. check your email address.');
        case 'ERROR_INVALID_EMAIL':
          throw const AuthException('Please check your email address.');
        case 'ERROR_WRONG_PASSWORD':
          throw const AuthException('Please check your password.');
        case 'ERROR_USER_NOT_FOUND':
          throw const AuthException(
              'User not found. Is that the correct email address?');
        case 'ERROR_USER_DISABLED':
          throw const AuthException(
              'Your account has been disabled. Please contact support');
        case 'ERROR_TOO_MANY_REQUESTS':
          throw const AuthException(
              'You have tried to login too many times. Please try again later.');
      }
    }
    throw const AuthException('Sorry, an error occurred. Please try again.');
  }

  void setAuthTokenForGraphQLServer(String token) {
    Application().setGraphQLClient(token: token);
  }
}

class AuthException implements Exception {
  static const cancelled = AuthException('No account');

  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
