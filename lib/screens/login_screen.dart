import 'package:chatapp/components/Rounded_button.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/Rounded_button.dart';
import 'package:chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class LoginScreen extends StatefulWidget {
  static const String id="login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth=FirebaseAuth.instance;
  bool checkSpinner=false;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:checkSpinner ,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),

              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    email=value;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    password=value;
                  });
                },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(
               title: 'Log In',
               colour: Colors.lightBlueAccent,
               onPressed: () async{
                 try {
                   setState(() {
                     checkSpinner=true;
                   });
                final user=   await _auth.signInWithEmailAndPassword(
                       email: email!, password: password!);
                if(user!=null){
                  Navigator.pushNamed(context, ChatScreen.id);
                }
                setState(() {
                  checkSpinner=false;
                });
                 }
                 catch(e)
                 {
                   print(e);
                 }
               },
             ),
            ],
          ),
        ),
      ),
    );
  }
}
