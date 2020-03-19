import 'package:flutter/material.dart';
import 'package:flutter_app/state/auth.dart';

class AuthForm extends StatefulWidget {
  final bool isSignup;

  const AuthForm({
    Key key,
    this.isSignup = false,
  }) : super(key: key);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Auth _auth;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _input = {
    'email': '',
    'password': '',
  };
  Future _authenticateFuture;
  bool _socialLogin = false;

  @override
  void initState() {
    super.initState();
    _auth = Auth.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Form(
              key: _formKey,
              child: FutureBuilder(
                future: _authenticateFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  bool loading = false;
                  String error;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    error = null;
                    loading = true;
                  }
                  if (snapshot.hasError) {
                    loading = false;
                    error = snapshot.error.toString();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _authTypeString(),
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(height: 15.0),
                      Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: error != null &&
                                      error.toLowerCase().contains('email')
                                  ? error
                                  : null,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String text) {
                              _input['email'] = text;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: error != null &&
                                      error.toLowerCase().contains('password')
                                  ? error
                                  : null,
                            ),
                            obscureText: true,
                            onChanged: (String text) {
                              _input['password'] = text;
                            },
                            validator: (value) {
                              if (value.isEmpty || value.length < 8) {
                                return 'Password should have atleast 8 chars.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      if (error != null &&
                          !error.toLowerCase().contains('email') &&
                          !error.toLowerCase().contains('password'))
                        Column(
                          children: <Widget>[
                            Text(
                              error,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      RaisedButton(
                        child: (loading && !_socialLogin)
                            ? SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              )
                            : Text(_authTypeString()),
                        onPressed: _authenticate,
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        child: (loading && _socialLogin)
                            ? SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              )
                            : Text('Login with Google'),
                        onPressed: () {
                          setState(() {
                            _socialLogin = true;
                            _authenticateFuture = _auth.loginWithGoogle();
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _authTypeString() => widget.isSignup ? 'Signup' : 'Login';

  void _authenticate() {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _socialLogin = false;
      if (widget.isSignup) {
        _authenticateFuture = _auth.signUpWithEmailAndPassword(
          email: _input['email'],
          password: _input['password'],
        );
      } else {
        _authenticateFuture = _auth.loginWithEmail(
          email: _input['email'],
          password: _input['password'],
        );
      }
    });
  }
}
