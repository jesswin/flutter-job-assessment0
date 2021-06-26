import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appbarIcons.dart';

class HomeAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            "lib/assets/images/cafe.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 270,
          ),
          Row(
            children: [
              AppbarIcon(
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      }),
                  40.0,
                  40.0,
                  Colors.grey[700]),
              Spacer(),
              AppbarIcon(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      Text(
                        " 4",
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
                  ),
                  40.0,
                  55.0,
                  Colors.deepOrange[300])
            ],
          ),
        ],
      ),
    );
  }
}
