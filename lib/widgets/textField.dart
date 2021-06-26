import 'package:flutter/material.dart';
import 'package:job_test/utilities/main_config.dart';

class TextField2 extends StatelessWidget {
  var txt;
  var controller;

  TextField2(this.txt, {this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: primaryColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: txt,
            hintStyle: TextStyle(color: primaryColor)),
      ),
    );
  }
}
