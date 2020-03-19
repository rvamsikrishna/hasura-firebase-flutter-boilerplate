import 'package:flutter/material.dart';
import 'package:flutter_app/pages/auth/widgets/auth_form.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final List<Tab> _myTabs = <Tab>[
    Tab(text: 'Signup'),
    Tab(text: 'Login'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Notes"),
          bottom: TabBar(
            tabs: _myTabs,
            onTap: (_) {},
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            AuthForm(
              isSignup: true,
            ),
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
