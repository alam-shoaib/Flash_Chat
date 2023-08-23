import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/buttonWidgets.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id='resgistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String pass;
  final _auth=FirebaseAuth.instance;
  bool spinner=false;
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
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
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
                  //Do something with the user input.
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
              buttonWidgets(lable: 'Register',colors: Colors.blueAccent,onTap: () async {
                setState(() {
                  spinner=true;
                });
                try{

                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: pass);
                    if(newUser!=null)
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
