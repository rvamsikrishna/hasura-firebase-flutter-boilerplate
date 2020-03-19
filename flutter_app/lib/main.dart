import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/pages/auth/authentication_page.dart';
import 'package:flutter_app/pages/home/home_page.dart';
import 'package:flutter_app/state/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Async main methods show the platform splash screen
  // before runApp is called to show the flutter UI.
  // So this line waits for Auth.create to finish before
  // showing the rest of the app.
  final uri = 'https://hasura-test-learn.herokuapp.com/v1/graphql';
  Application(uri: uri).setGraphQLClient();

  runApp(MyApp(auth: await Auth.create()));
}

class MyApp extends StatefulWidget {
  final Auth auth;

  MyApp({Key key, @required this.auth}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.auth.init(_onUserChanged);
  }

  @override
  void dispose() {
    widget.auth.dispose(_onUserChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>.value(value: widget.auth),
        ProxyProvider<Auth, FirebaseUser>(
          update: (_, Auth auth, __) {
            return auth.currentUser.value
                .maybeWhen((user) => user, orElse: null);
          },
        )
        // ValueListenableProvider<FirebaseUser>.value(
        //   value: widget.auth.currentUser.value
        //       .maybeWhen((user) => user, orElse: null),
        // ),
      ],
      child: MaterialApp(
        home: currentUser == null ? AuthPage() : HomePage(),
        routes: {
          '/home': (context) => HomePage(),
          '/auth': (context) => AuthPage(),
        },
        navigatorKey: _navigatorKey,
      ),
    );
  }

  void _onUserChanged() {
    final user =
        widget.auth.currentUser.value.maybeWhen((u) => u, orElse: () => null);
    // User logged in
    if (currentUser == null && user != null) {
      _navigatorKey.currentState
          .pushNamedAndRemoveUntil('/home', (route) => false);
    }
    // User logged out
    else if (currentUser != null && user == null) {
      _navigatorKey.currentState
          .pushNamedAndRemoveUntil('/auth', (route) => false);
    }
    currentUser = user;
  }
}
