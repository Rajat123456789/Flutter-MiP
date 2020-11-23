import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  addActivity(String uid, String activity, int duration) async {
    FirebaseFirestore.instance
        .collection('activities')
        .add({'uid': uid, 'activity': activity, 'duration': duration});
  }

  Future<QuerySnapshot> getActivities(String uid) async {
    return FirebaseFirestore.instance
        .collection('activities')
        .where('uid', isEqualTo: uid)
        .get();
  }

  deleteActivity(String uid, String activity, int duration) async {
    var docId;
    await FirebaseFirestore.instance
        .collection('activities')
        .where('uid', isEqualTo: uid)
        .where('activity', isEqualTo: activity)
        .where('duration', isEqualTo: duration)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        docId = doc.id;
      });
    });
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(docId)
        .delete();
  }

  Future<QuerySnapshot> getCompletedActivities(String uid) async {
    return await FirebaseFirestore.instance
        .collection('completed')
        .where('uid', isEqualTo: uid)
        .get();
  }

  addCompletedActivity(
      List<String> activities, List<int> time, String uid) async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    await FirebaseFirestore.instance.collection('completed').add({
      'activities': activities,
      'time': time,
      'uid': uid,
      'date': formatter.format(DateTime.now())
    });
  }
}
