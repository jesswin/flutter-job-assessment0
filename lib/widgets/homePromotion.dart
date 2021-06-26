import 'package:flutter/material.dart';
import 'package:job_test/utilities/main_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePromotion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 25),
            child: Container(
                child: Text(
              "Promotion",
              style: TextStyle(fontSize: text_md),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Container(
              height: 100,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Promotion")
                    .snapshots(),
                builder: (context, snap) => ListView.builder(
                    itemCount: snap.hasData ? snap.data.docs.length : 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 7,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snap.data.docs[index]["imgId"],
                                    height: 65,
                                    width: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snap.data.docs[index]["promoName"],
                                      style: TextStyle(color: textColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "\$${snap.data.docs[index]["promoPrice"]}",
                                      style: TextStyle(color: textColor),
                                    )
                                  ])
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
