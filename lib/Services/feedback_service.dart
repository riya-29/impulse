import'package:cloud_firestore/cloud_firestore.dart';
import 'package:impulse/Model/UserFeedback.dart';

class FeedbackService{
  CollectionReference feedbackcollection =
  FirebaseFirestore.instance.collection("feedback");
  Future completTask(uid) async {
    await feedbackcollection.doc(uid).update({"read": true});
  }
  Future removeTodo(uid) async {
    await feedbackcollection.doc(uid).delete();
  }
  List<UserFeedback> feedbackFromFirestore(QuerySnapshot snapshot) {

    if (snapshot != null) {
      return snapshot.docs.map((data) {
        return UserFeedback(
        Email: data['Email'],
          Message: data['Message'],
          Name: data['Name'],
          Subject: data['Subject'],
          read: data['read'],
          open: data['open'],
          uid:data.id,
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<UserFeedback>> listFeedbacks() {
    return feedbackcollection.snapshots().map(feedbackFromFirestore);
  }
}
