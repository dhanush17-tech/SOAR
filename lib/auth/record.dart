import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DbService {
  final String uid;
  DbService({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection(
    'Users',
  );

  Future updateuserdata(String name, String tagline, String websiteurl,
      String uid, String usertype, String location) async {
    List<String> spiltList = name.split(" ");
    List<String> indexList = [];
    for (int i = 0; i < spiltList.length; i++) {
      for (int j = 0; j < spiltList[i].length + i; j++) {
        indexList.add(spiltList[i].substring(0, j).toLowerCase());
      }
    }
    return await users.document(uid).setData({
      "name": name,
      "tagline": tagline,
      "websiteurl": websiteurl,
      "usertype": usertype,
      "location": location,
      "uid": uid,
      "searchkey": indexList
    }).then((value) => print("donee!"));
  }
}
