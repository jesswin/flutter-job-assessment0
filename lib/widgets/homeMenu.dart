import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:job_test/globalData/userData.dart';
import 'package:job_test/models/cart.dart';
import 'package:job_test/utilities/main_config.dart';
import 'package:provider/provider.dart';

import 'homeCheckout.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  var gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 0.0),
    colors: <Color>[
      Color(0xfffbad50),
      Color(0xffe95950),
    ],
  );

  List<Cart> cartList = [];
  var total = 0;
  var isLoading = false;
  fetchItemsFromCart() async {
    setState(() {
      isLoading = true;
    });
    cartList = await context.read<CartData>().fetchCartItems();
    setState(() {
      isLoading = false;
    });
  }

  addToCart(itemId, itemQuantity, price) {
    total = context.read<CartData>().addToCart(itemId, itemQuantity, price);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Item added to Cart"),
      duration: Duration(milliseconds: 350),
    ));
  }

  @override
  void initState() {
    super.initState();
    cartList.clear();
    fetchItemsFromCart();
  }

  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 25),
                child: Container(
                    child: Text(
                  "Menu",
                  style: TextStyle(fontSize: text_md),
                )),
              ),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Container(
                      width: 82,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: gradient,
                      ),
                      child: Container()),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Container(
                    margin: EdgeInsets.all(2.5),
                    width: 77,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("All"), Icon(Icons.arrow_drop_down)],
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Menu")
                        .snapshots(),
                    builder: (context, snap) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.3),
                            crossAxisSpacing: 10),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snap.hasData ? snap.data.docs.length : 0,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 250,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 7,
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        child: Image.network(
                                          snap.data.docs[index]["imgId"],
                                          height: 125,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 0,
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Color(0xffffc594),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                            child: Text(
                                          "Popular",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    )
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            "${snap.data.docs[index]["orders"]}+ ordered",
                                            style: TextStyle(color: textColor),
                                          ),
                                        ),
                                        Text(
                                          snap.data.docs[index]["itemName"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: text_md),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Consumer<CartData>(
                                          builder: (context, cartData, _) =>
                                              Row(
                                            children: [
                                              Text(
                                                  "\$${snap.data.docs[index]["itemPrice"]}"),
                                              Spacer(),
                                              context
                                                      .read<CartData>()
                                                      .cartListToAdd
                                                      .any((element) {
                                                return element.itemId ==
                                                    snap.data.docs[index]
                                                        ["itemId"];
                                              })
                                                  ? Stack(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5.0),
                                                        child: Container(
                                                            width: 82,
                                                            height: 33,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              gradient:
                                                                  gradient,
                                                            ),
                                                            child: Container()),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          addToCart(
                                                              snap.data.docs[
                                                                      index]
                                                                  ["itemId"],
                                                              1,
                                                              snap.data.docs[
                                                                      index][
                                                                  "itemPrice"]);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5.0),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    2.5),
                                                            width: 77,
                                                            height: 28,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2)),
                                                            child: Center(
                                                                child:
                                                                    GradientText(
                                                              text: 'Add More',
                                                              colors: <Color>[
                                                                Color(
                                                                    0xfffbad50),
                                                                Color(
                                                                    0xffe95950),
                                                              ],
                                                            )),
                                                          ),
                                                        ),
                                                      ),
                                                    ])
                                                  : GestureDetector(
                                                      onTap: () {
                                                        addToCart(
                                                            snap.data
                                                                    .docs[index]
                                                                ["itemId"],
                                                            1,
                                                            snap.data
                                                                    .docs[index]
                                                                ["itemPrice"]);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5.0),
                                                        child: Container(
                                                          height: 28,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            gradient: gradient,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            "Add",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        ),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              Consumer<CartData>(
                  builder: (context, cartData, _) => HomeCheckout()),
            ],
          ));
  }
}
