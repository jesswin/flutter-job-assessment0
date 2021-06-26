import 'package:flutter/material.dart';
import 'package:job_test/utilities/main_config.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 25),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Starbucks Coffee",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(children: [
                Icon(
                  Icons.location_on,
                  color: textColor,
                ),
                Text(
                  "Avenue St. 187",
                  style: TextStyle(fontSize: text_md, color: textColor),
                ),
              ]),
            ),
          ]),
          Spacer(),
          Container(
            height: 50,
            width: 50,
            child: Image.asset("lib/assets/images/location.jpg"),
          )
        ]),
      ),
    );
  }
}
