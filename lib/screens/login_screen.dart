import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/buttonWidgets.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id='loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String pass;
  bool spinner=false;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value;
                },
                decoration: kInputtextDecoration.copyWith(
                  hintText: 'Enter your E-mail'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  pass=value;
                  //Do something with the user input.
                },
                decoration: kInputtextDecoration.copyWith(
                  hintText: 'Enter your password'
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              buttonWidgets(lable: 'Log in',colors: Colors.lightBlueAccent,onTap: ()async {
                setState(() {
                  spinner=true;
                });
                try{
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);
                    if(user!=null)
                      {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    setState(() {
                      spinner=false;
                    });
                  }
                  catch(e)
                {
                  print(e);
                }
                },),
            ],
          ),
        ),
      ),
    );
  }
}
