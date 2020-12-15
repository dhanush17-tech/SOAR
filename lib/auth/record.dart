import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SOAR/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class DbService {
  final String uid;
  DbService({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection(
    'Users',
  );

  Future updateuserdata(String name, String tagline, String websiteurl,
      String uid, String usertype) async {
    return await users.document(uid).setData({
      "name": name,
      "tagline": tagline,
      "websiteurl": websiteurl,
      "usertype": usertype,
      "uid": uid
    }).then((value) => print("donee!"));
  }
}
