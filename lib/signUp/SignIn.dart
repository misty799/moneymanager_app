import 'package:flutter/material.dart';
import 'package:money_management_app/services/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

enum FormType { login, register }

class _SignInPageState extends State<SignInPage> {
  FormType _formType = FormType.login;

  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.register) {
          String userId = await Provider.of(context)
              .createUserWithEmailAndPassword(_name, _email, _password);
          print(userId);
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          String userId = await Provider.of(context)
              .signInWithEmailAndPassword(_email, _password);
          print(userId);
                    Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void moveToRegister() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: formkey,
          child: ListView(
              children:
                  buildImage() + buildInputs() + buildName() + buildButtons()),
        ),
      ),
    );
  }

  List<Widget> buildImage() {
    if (_formType == FormType.login) {
      return [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/money.jpg',
            height: 250,
            fit: BoxFit.fill,
          ),
        ),
      ];
    } else {
      return [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/money.jpg',
            height: 250,
            fit: BoxFit.fill,
          ),
        ),
      ];
    }
  }

  List<Widget> buildInputs() {
    return [
      Container(
          padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Column(children: <Widget>[
            TextFormField(
              validator: (value) =>
                  value.isEmpty ? "email can't be empty" : null,
              onSaved: (newValue) => _email = newValue,
              decoration: InputDecoration(
                  labelText: 'EMAIL',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              validator: (value) =>
                  value.isEmpty ? "password can't be empty" : null,
              onSaved: (newValue) => _password = newValue,
              decoration: InputDecoration(
                  labelText: 'PASSWORD ',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
              obscureText: true,
            ),
          ]))
    ];
  }

  List<Widget> buildName() {
    if (_formType == FormType.register) {
      return [
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
              validator: (value) =>
                  value.isEmpty ? "name can't be empty" : null,
              onSaved: (newValue) => _name = newValue,
              decoration: InputDecoration(
                labelText: 'NICK NAME ',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              )),
        ),
        SizedBox(height: 20.0)
      ];
    } else {
      return [Container()];
    }
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 20.0,
        ),
        Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.greenAccent,
              color: Colors.green,
              elevation: 7.0,
              child: GestureDetector(
                onTap: validateAndSubmit,
                child: Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )),
        SizedBox(height: 20.0),
        Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            height: 40.0,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1.0),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0)),
                child: InkWell(
                  onTap: moveToRegister,
                  child: Center(
                    child: Text("don't have an account ? Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                )))
      ];
    } else {
      return [
        Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.greenAccent,
              color: Colors.green,
              elevation: 7.0,
              child: GestureDetector(
                onTap: validateAndSubmit,
                child: Center(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )),
        SizedBox(height: 20.0),
        Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            height: 40.0,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1.0),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0)),
                child: InkWell(
                  onTap: moveToLogin,
                  child: Center(
                    child: Text("already have an account? Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat')),
                  ),
                )))
      ];
    }
  }
}
