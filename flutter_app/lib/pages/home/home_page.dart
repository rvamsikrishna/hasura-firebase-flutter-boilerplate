import 'package:flutter/material.dart';
import 'package:flutter_app/state/auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home Page'),
            SizedBox(height: 15.0),
            RaisedButton(
              onPressed: Auth.of(context).logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
