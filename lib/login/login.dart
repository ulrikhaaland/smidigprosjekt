import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/uidata.dart';
import 'dart:async';
import '../objects/user.dart';

class Login extends StatefulWidget {
  Login(
      {Key key,
      this.title,
      this.auth,
      this.onSignIn,
      this.currentUser,
      this.messagingToken})
      : super(key: key);
  final String messagingToken;
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;
  final String currentUser;

  @override
  LoginState createState() => new LoginState();
}

enum FormType { login, register, forgotPassword }

class LoginState extends State<Login> {
  static final formKey = new GlobalKey<FormState>();

  final myController = new TextEditingController();

  final CollectionReference collectionReference =
      Firestore.instance.collection('users');

  String finalUsername;

  String uid;
  String _username;
  String _email;
  String _resetEmail;
  String _password;
  String _doubleCheckPassword;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool firstTime;

  bool passwordsMatch = false;
  bool usernameAvailable = false;
  bool loading = false;
  bool passwordVisible = false;
  IconData passwordVisibleIcon = Icons.visibility;

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      loading = false;
    });
    return false;
  }

  duration() {
    Duration duration = new Duration(
      seconds: 4,
    );

    new Timer(duration, () {
      setState(() {
        _authHint = "";
      });
    });
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          uid = userId;
          widget.onSignIn();
        } else if (usernameAvailable == true &&
            _formType == FormType.register) {
          String userId = await widget.auth.createUser(_email, _password);
          uid = userId;
          widget.onSignIn();
          saveUserData();
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error${e.toString()}';
          duration();

          loading = false;
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
        loading = false;
      });
    }
  }

  void saveUserData() {
    User user = new User(_email, uid, _username, widget.messagingToken, true);
    DocumentReference docRef = Firestore.instance.document("users/$uid");
    Firestore.instance.runTransaction((Transaction tx) async {
      await docRef.setData(user.toJson());
    });
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  void moveToForgotPassword() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.forgotPassword;
      _authHint = '';
    });
  }

  sendResetEmail() {
    try {
      if (_formType == FormType.forgotPassword) {
        widget.auth.resetPassword(_resetEmail);
        setState(() {
          _authHint = "Check your email";
          duration();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String getFinalUsername() {
    return finalUsername;
  }

  void checkUsername() async {
    _username = myController.text.trim().toLowerCase();
    Firestore.instance
        .collection("users")
        .where("username", isEqualTo: _username)
        .getDocuments()
        .then((string) {
      if (string.documents.isEmpty) {
        setState(() {
          debugPrint("true");
          usernameAvailable = true;
          _authHint = "";
          validateAndSubmit();
          finalUsername = _username;
        });
      } else {
        setState(() {
          _authHint = "Username is taken";
          duration();
          loading = false;
          debugPrint("false");
          usernameAvailable = false;
        });
      }
    });
  }

  List<Widget> usernameAndPassword() {
    switch (_formType) {
      case FormType.register:
        return [
          new ListTile(
            title: padded(
                child: new TextFormField(
              maxLengthEnforced: true,
              style: new TextStyle(
                  color: Colors.black, fontSize: UIData.fontSize18),
              key: new Key('username'),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brukernavn (maksimum 18 tegn)',
                  fillColor: Colors.black,
                  labelStyle: new TextStyle(
                      color: Colors.grey[600], fontSize: UIData.fontSize16)),
              autocorrect: false,
              validator: (val) {
                if (val.isEmpty) {
                  return "Brukernavnet kan ikke være tomt";
                }
                if (val.length > 18) {
                  return "Brukernavnet er for langt";
                } else {
                  return null;
                }
              },
              onSaved: (val) => _username = val.trim().toLowerCase(),
              controller: myController,
            )),
          ),
          new ListTile(
            title: padded(
                child: new TextFormField(
              style: new TextStyle(
                  color: Colors.black, fontSize: UIData.fontSize18),
              key: new Key('email'),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  fillColor: Colors.black,
                  labelStyle: new TextStyle(
                      color: Colors.grey[600], fontSize: UIData.fontSize16)),
              autocorrect: false,
              validator: (val) =>
                  val.isEmpty ? 'Emailen kan ikke være tom' : null,
              onSaved: (val) => _email = val.trim().toLowerCase(),
            )),
          ),
          new ListTile(
            title: padded(
                child: new TextFormField(
              style: new TextStyle(
                  color: Colors.black, fontSize: UIData.fontSize18),
              key: new Key('password'),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Passord (8+ tegn)',
                  fillColor: Colors.black,
                  labelStyle: new TextStyle(
                      color: Colors.grey[600], fontSize: UIData.fontSize16)),
              obscureText: passwordVisible,
              autocorrect: false,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Passordet kan ikke være tomt';
                }
                if (val.length < 8) {
                  return "Passordet er for kort";
                } else {
                  return null;
                }
              },
              onSaved: (val) => _password = val,
            )),
            trailing: new IconButton(
              icon: new Icon(
                passwordVisibleIcon,
                color: Colors.black,
              ),
              onPressed: () {
                if (passwordVisible == false) {
                  setState(() {
                    passwordVisible = true;
                    passwordVisibleIcon = Icons.visibility_off;
                  });
                } else {
                  setState(() {
                    passwordVisible = false;
                    passwordVisibleIcon = Icons.visibility;
                  });
                }
              },
            ),
          ),
        ];
      case FormType.login:
        return [
          new ListTile(
            title: padded(
                child: new TextFormField(
              style: new TextStyle(
                  color: Colors.black, fontSize: UIData.fontSize18),
              key: new Key('email'),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: new TextStyle(color: Colors.grey[600])),
              autocorrect: false,
              validator: (val) =>
                  val.isEmpty ? 'Emailen kan ikke være tom' : null,
              onSaved: (val) => _email = val.trim().toLowerCase(),
            )),
          ),
          new ListTile(
            title: padded(
                child: new TextFormField(
              style: new TextStyle(
                  color: Colors.black, fontSize: UIData.fontSize18),
              key: new Key('password'),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Passord',
                  labelStyle: new TextStyle(color: Colors.grey[600])),
              obscureText: true,
              autocorrect: false,
              validator: (val) =>
                  val.isEmpty ? 'Passordet kan ikke være tomt' : null,
              onSaved: (val) => _password = val,
            )),
            trailing: new IconButton(
              icon: Icon(Icons.visibility),
            ),
          ),
        ];
      case FormType.forgotPassword:
        return [
          new ListTile(
            title: padded(
                child: new TextField(
                    style: new TextStyle(
                        color: Colors.black, fontSize: UIData.fontSize18),
                    key: new Key('typelostpassword'),
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Skriv inn din email',
                        fillColor: Colors.black,
                        labelStyle: new TextStyle(color: Colors.grey[600])),
                    autocorrect: false,
                    onChanged: (String str) {
                      _resetEmail = str;
                    })),
          ),
        ];
    }
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          padded(),
          new PrimaryButton(
              key: new Key('login'),
              text: 'Logg inn',
              color: Colors.lightBlueAccent,
              padding: 84,
              onPressed: () {
                setState(() {
                  loading = true;
                });
                validateAndSubmit();
              }),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          ),
          new FlatButton(
            key: new Key('register'),
            child: new Text("Har du ikke en konto? Registrer deg",
                style: new TextStyle(color: Colors.black)),
            onPressed: moveToRegister,
          ),
          new FlatButton(
            key: new Key('resetpassword'),
            child: new Text("Glemt passord?",
                style: new TextStyle(color: Colors.black)),
            onPressed: moveToForgotPassword,
          ),
        ];
      case FormType.register:
        return [
          padded(),
          new PrimaryButton(
            key: new Key('createaccount'),
            text: 'Lag konto',
            padding: 84,
            color: Colors.lightBlueAccent,
            onPressed: () {
              setState(() {
                loading = true;
              });
              checkUsername();
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          ),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text(
                "Har du en bruker? Logg inn",
                style: new TextStyle(color: Colors.black),
              ),
              onPressed: moveToLogin),
        ];
      case FormType.forgotPassword:
        return [
          padded(),
          new PrimaryButton(
            key: new Key('reset'),
            text: 'Tilbakestill',
            padding: 84,
            color: Colors.lightBlueAccent,
            onPressed: sendResetEmail,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          ),
          new FlatButton(
              key: new Key('movetologin'),
              child: new Text(
                "Gå til logg inn",
                style: new TextStyle(color: Colors.black),
              ),
              onPressed: moveToLogin),
        ];
    }
    return null;
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(_authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            textAlign: TextAlign.center));
  }

  Widget material() {
    return new SingleChildScrollView(
        child: new Container(
            child: new Column(children: [
      new Container(
          color: Colors.white,
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Form(
                    key: formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: usernameAndPassword() + submitWidgets(),
                    ))),
          ])),
      hintText()
    ])));
  }

  Widget circular() {
    if (loading == true) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: new AppBar(
        //   centerTitle: true,
        //   title: new Text(
        //     "Smidig Prosjekt",
        //     style: new TextStyle(
        //         color: Colors.yellow[700], fontSize: UIData.fontSize24),
        //   ),
        //   backgroundColor: UIData.darkest,
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.lightBlue,
                height: 300,
              ),
              material(),
            ],
          ),
          // material(),
          // circular(),
        ));
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
