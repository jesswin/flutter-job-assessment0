import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_test/globalData/userData.dart';
import 'package:job_test/utilities/main_config.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  var phone;

  OTPScreen(this.phone);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    border: Border.all(color: accentColor),
    borderRadius: BorderRadius.circular(15.0),
  );

  storeUserToDb() async {
    await context
        .read<CartData>()
        .storeUserToDB(FirebaseAuth.instance.currentUser.uid);
  }

  verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          await storeUserToDb();
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationCode, int resendToken) {
          setState(() {
            _verificationCode = verficationCode;
          });
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: Duration());
  }

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Form(
              child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text("Verify Phone Number"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                  fieldsCount: 6,
                  eachFieldHeight: 40.0,
                  withCursor: true,
                  onSubmit: (String pin) async {
                    try {
                      await FirebaseAuth.instance.signInWithCredential(
                          PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin));
                      await storeUserToDb();
                      Navigator.popUntil(context,
                          ModalRoute.withName(Navigator.defaultRouteName));
                    } catch (err) {
                      _scaffoldkey.currentState
                          .showSnackBar(SnackBar(content: Text('invalid OTP')));
                    }
                  },
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: pinPutDecoration,
                  followingFieldDecoration: pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: accentColor.withOpacity(.5),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
