import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/components/Rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id="welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation? animation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=AnimationController(duration: Duration(seconds: 1),vsync: this);

    controller?.forward();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.png'),
                  height: 60.0,
                ),
                AnimatedTextKit(
                  repeatForever: true,

                  animatedTexts:[TypewriterAnimatedText(
                    'Flash Chat',
                    speed: Duration(milliseconds: 130),
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87
                  ),
                  ),
                  ],

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
           SizedBox(
             height: 24,
           ),
           RoundedButton(
               colour: Colors.blueAccent,
               title: 'Register',
               onPressed: (){
                 Navigator.pushNamed(context, RegistrationScreen.id);
               })
          ],
        ),
      ),
    );
  }
}


