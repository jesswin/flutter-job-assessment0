import 'package:flutter/material.dart';

class AppbarIcon extends StatelessWidget {
  Widget content;
  var height;
  var width;
  var color;
  AppbarIcon(this.content, this.height, this.width, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(right: 10, top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          height: height,
          width: width,
          child: content,
        ),
      ),
    );
  }
}
