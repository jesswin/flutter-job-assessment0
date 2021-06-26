import 'package:flutter/material.dart';
import 'package:job_test/globalData/userData.dart';
import 'package:job_test/widgets/homeAppBar.dart';
import 'package:job_test/widgets/homeHeader.dart';
import 'package:job_test/widgets/homeMenu.dart';
import 'package:job_test/widgets/homeOrders.dart';
import 'package:job_test/widgets/homePromotion.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          HomeAppbar(),
          HomeHeader(),
          HomeOrders(),
          HomePromotion(),
          HomeMenu(),
        ],
      ),
    ));
  }
}
