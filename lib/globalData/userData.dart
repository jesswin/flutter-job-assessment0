import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:job_test/models/user.dart';
import '../models/cart.dart';

class CartData with ChangeNotifier {
  var total = 0;
  List<Cart> cartListToAdd = [];
  var user;
  addToCart(itemId, itemQuantity, price) {
    var index;
    if (cartListToAdd.any((element) {
      return element.itemId == itemId;
    })) {
      index = cartListToAdd.indexWhere((element) {
        return element.itemId == itemId;
      });
      cartListToAdd[index].quantity =
          cartListToAdd[index].quantity + itemQuantity;
      print(cartListToAdd[index].quantity);
    } else {
      cartListToAdd.add(Cart(itemId, itemQuantity));
      notifyListeners();
    }
    total += price;
    notifyListeners();
    return total;
  }

  onCheckOut() async {
    print("object");
    for (var i = 0; i < cartListToAdd.length; i++) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("Cart")
          .doc(cartListToAdd[i].itemId)
          .set({
        "cartItem": cartListToAdd[i].itemId,
        "itemQuantity": cartListToAdd[i].quantity
      });
    }
  }

  fetchCartItems() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("Cart")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          cartListToAdd.add(Cart(element["cartItem"], element["itemQuantity"]));
        });
      });
    } catch (err) {
      print(err);
    }
    print(cartListToAdd);
    notifyListeners();
    return cartListToAdd;
  }

  storeUser(name, dob, age) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dob);
    user = MyUser(name: name, dob: formatted, age: int.parse(age));
    print(user);
    print(user.age);
  }

  storeUserToDB(uid) async {
    await FirebaseFirestore.instance.collection("Users").doc(uid).set({
      "id": uid,
      "name": user.name,
      "age": user.age,
      "dobYear": user.dob,
    });
  }
}
