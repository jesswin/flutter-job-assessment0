import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_test/globalData/userData.dart';
import 'package:provider/provider.dart';
import 'package:job_test/utilities/main_config.dart';

class HomeCheckout extends StatefulWidget {
  HomeCheckout();

  @override
  _HomeCheckoutState createState() => _HomeCheckoutState();
}

class _HomeCheckoutState extends State<HomeCheckout> {
  var isLoading = false;

  checkOut() async {
    setState(() {
      isLoading = true;
    });
    await context.read<CartData>().onCheckOut();
    Fluttertoast.showToast(
      msg: 'Pushed to Database',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                checkOut();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 0.0),
                      colors: <Color>[
                        Color(0xfffbad50),
                        Color(0xffe95950),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  height: 60,
                  child: Center(
                      child: Text(
                    "Checkout - \$${context.read<CartData>().total}",
                    style: TextStyle(color: Colors.white, fontSize: text_md),
                  )),
                ),
              ),
            ),
    );
  }
}
