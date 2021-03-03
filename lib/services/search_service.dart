import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';

class SearchIndex {
  serachByName(String serachfeild) {
    print(auth.currentUser.uid);
    Firestore.instance
        .collection('Users')
        .document(auth.currentUser.uid)
        .collection("followers")
        .where('searchkey',
            isEqualTo: serachfeild.substring(0, 1).toUpperCase())
        .get()
        .then((value) => print(value.docs.length));
  }
}
