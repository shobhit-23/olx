import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:olx/authenti/google_auth.dart';
import 'package:olx/authenti/phone_auth.dart';
import 'package:olx/screens/home_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:olx/services/firebase_services.dart';

class auth extends StatelessWidget {
  @override
  facebookLogin() async {
    print("FaceBook");
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);

        FirebaseService _service = FirebaseService();
        _service.addUser(userData['id']);
      }
    } catch (error) {
      print(error);
    }
  }

  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 90.0, right: 90.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new phoneauthscreen()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_android_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Continue with Phone'),
                    ],
                  )),
            ),
            SignInButton(Buttons.Google, text: "Sign in with Google",
                onPressed: () async {
              User? user = await GoogleAuth.signInWithGoogle(context: context);

              print('user $user');

              if (user != null) {
                print('googlee successfulll');

                FirebaseService _service = FirebaseService();
                _service.addUser(user.uid);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => home_screen()));
                // OTPScreen();
              } else {
                print('Ram');
              }
              //signInWithGoogle(context);
            }),
            SignInButton(Buttons.FacebookNew, text: "Sign in with Facebook",
                onPressed: () {
              print("ram");
              facebookLogin();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => home_screen()));
            }),
          ],
        ),
      ),
    );
  }
}
