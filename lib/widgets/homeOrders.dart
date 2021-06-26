import 'package:flutter/material.dart';
import 'package:job_test/utilities/main_config.dart';

class HomeOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: textColor),
          bottom: BorderSide(color: textColor),
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              color: Colors.grey[800],
            ),
            Text(
              "  2990+ orders placed to make people smile",
              style: TextStyle(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
