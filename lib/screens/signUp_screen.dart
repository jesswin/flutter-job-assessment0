import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_test/globalData/userData.dart';
import 'package:job_test/screens/otp_screen.dart';
import 'package:job_test/utilities/main_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:job_test/widgets/textField.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var mobileNumber = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var name = TextEditingController();
  var age = TextEditingController();
  DateTime date;
  var dob = TextEditingController();
  var indexMain = 0;

  var isLoading = false;

  signUpWithEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
    context.read<CartData>().storeUser(name.text, date, age.text);
    await context
        .read<CartData>()
        .storeUserToDB(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      isLoading = false;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    var credential;
    GoogleSignInAccount googleUser;
    if (age.text == "" || date == null) {
      print("Enter Age and Date");
      Fluttertoast.showToast(
          msg: 'Enter Age and Date',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: accentColor,
          textColor: primaryColor);
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        googleUser = await GoogleSignIn().signIn();
        setState(() {});
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (err) {
        print(err);
        setState(() {
          isLoading = false;
        });
      }
      print("goole");
      print(googleUser.displayName);

      context
          .read<CartData>()
          .storeUser(googleUser.displayName, date, age.text);
      await context
          .read<CartData>()
          .storeUserToDB(FirebaseAuth.instance.currentUser.uid);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: 700,
            child: Image.asset(
              "lib/assets/images/coffee.png",
              height: 700,
              width: 700,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Container(
                child: Text(
                  "Sign up with",
                  style:
                      TextStyle(fontSize: text_xl, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 290,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 7,
                  child: Container(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: FlutterToggleTab(
                          width: 90,
                          borderRadius: 25,
                          height: 50,
                          initialIndex: 0,
                          selectedBackgroundColors: [primaryColor],
                          unSelectedBackgroundColors: [accentColor],
                          selectedTextStyle: TextStyle(
                              color: accentColor,
                              fontSize: text_xl,
                              fontWeight: FontWeight.w700),
                          unSelectedTextStyle: TextStyle(
                            color: primaryColor,
                            fontSize: text_sm,
                          ),
                          labels: ["Phone", "E-mail"],
                          selectedLabelIndex: (index) {
                            print("Selected Index $index");
                            setState(() {
                              indexMain = index;
                            });
                          },
                        ),
                      ),
                      isLoading
                          ? CircularProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                  child: Column(
                                children: [
                                  indexMain == 0
                                      ? Column(children: [
                                          TextField2("Mobile",
                                              controller: mobileNumber),
                                          TextField2("Name", controller: name),
                                          TextField2("Age", controller: age),
                                          TextFormField(
                                            controller: dob,
                                            readOnly: true,
                                            style:
                                                TextStyle(color: primaryColor),
                                            decoration: InputDecoration(
                                                suffixIcon: GestureDetector(
                                                  onTap: () async {
                                                    date = await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1990),
                                                        lastDate:
                                                            DateTime(2030));
                                                    dob.text =
                                                        date.toIso8601String();
                                                  },
                                                  child: Icon(
                                                    Icons.calendar_today,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Date of Birth",
                                                hintStyle: TextStyle(
                                                    color: primaryColor)),
                                          ),
                                          FlatButton(
                                              onPressed: () {
                                                context
                                                    .read<CartData>()
                                                    .storeUser(name.text, date,
                                                        age.text);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OTPScreen(
                                                                mobileNumber
                                                                    .text)));
                                              },
                                              child: Text("Generate OTP",
                                                  style: TextStyle(
                                                      color: primaryColor)))
                                        ])
                                      : Column(children: [
                                          TextField2("E-mail",
                                              controller: email),
                                          TextField2("Password",
                                              controller: password),
                                          TextField2("Name", controller: name),
                                          TextField2("Age", controller: age),
                                          TextFormField(
                                            controller: dob,
                                            readOnly: true,
                                            style:
                                                TextStyle(color: primaryColor),
                                            decoration: InputDecoration(
                                                suffixIcon: GestureDetector(
                                                  onTap: () async {
                                                    date = await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1990),
                                                        lastDate:
                                                            DateTime(2030));
                                                    dob.text =
                                                        date.toIso8601String();
                                                  },
                                                  child: Icon(
                                                    Icons.calendar_today,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Date of Birth",
                                                hintStyle: TextStyle(
                                                    color: primaryColor)),
                                          ),
                                          FlatButton(
                                              onPressed: () {
                                                signUpWithEmail();
                                              },
                                              child: Text("Sign Up",
                                                  style: TextStyle(
                                                      color: primaryColor)))
                                        ]),
                                ],
                              )),
                            )
                    ]),
                  ),
                ),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  signInWithGoogle();
                },
                elevation: 5,
              )
            ],
          ),
        ]),
      ),
    );
  }
}
