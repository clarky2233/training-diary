import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_journal/Services/auth.dart';
import 'package:training_journal/activities.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userDataCollection =
      Firestore.instance.collection('users');

  final CollectionReference goalCollection =
      Firestore.instance.collection('goals');

  final CollectionReference journalCollection =
      Firestore.instance.collection('journal');

  final CollectionReference eventCollection =
      Firestore.instance.collection('events');

  Future updateUserData(String name, String username, double weight, int height,
      int restingHeartRate) async {
    return await userDataCollection.document(uid).setData({
      'username': username,
      'name': name,
      'weight': weight,
      'height': height,
      'restingHeartRate': restingHeartRate,
    });
  }

  Future updateEvent(Event event) async {
    return await eventCollection.document(uid).setData({
      'userID': event.userID,
      'name': event.name,
      'date': event.date,
      'startTime': event.startTime,
    });
  }

  Future updateTrainingSession(TrainingSession ts) async {
    return await journalCollection.document().setData({
      //'id': ts.id,
      'title': ts.title,
      'userID': ts.userID,
      'date': ts.date,
      'duration': ts.duration,
      'description': ts.description,
      'activity': ts.activity.name,
      'difficulty': ts.difficulty,
      'enjoymentRating': ts.enjoymentRating,
      'heartRate': ts.heartRate,
      'hoursOfSleep': ts.hoursOfSleep,
      'rpe': ts.rpe,
      'sleepRating': ts.sleepRating,
      'hydration': ts.hydration,
    });
  }

  Future updateGoal(Goal goal) async {
    return await goalCollection.document().setData({
      'userID': goal.userID,
      'title': goal.title,
      'text': goal.text,
    });
  }

  Future<User> getUser() {
    return userDataCollection.document(uid).get().then((doc) {
      return User(
        id: uid ?? '',
        name: doc.data['name'] ?? '',
        username: doc.data['username'] ?? '',
        height: doc.data['height'] ?? 0,
        weight: doc.data['weight'] ?? 0.0,
        restingHeartRate: doc.data['restingHeartRate'] ?? 0,
      );
    });
  }

  Stream<QuerySnapshot> get users {
    return userDataCollection.snapshots();
  }

  Stream<List<TrainingSession>> get journal {
    return journalCollection
        .where("userID", isEqualTo: uid)
        .snapshots()
        .map(_trainingSessionListFromSnapshot);
  }

  Stream<List<TrainingSession>> get recent {
    return journalCollection
        .where("userID", isEqualTo: uid)
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .map(_trainingSessionListFromSnapshot);
  }

  Future deleteGoal(String docID) {
    return goalCollection.document(docID).delete();
  }

  Stream<List<Goal>> get goals {
    return goalCollection
        .where("userID", isEqualTo: uid)
        .snapshots()
        .map(_goalListFromSnapshot);
  }

  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Goal(
        id: doc.documentID,
        userID: doc.data['userID'],
        title: doc.data['title'] ?? '',
        text: doc.data['text'] ?? '',
      );
    }).toList();
  }

  List<TrainingSession> _trainingSessionListFromSnapshot(
      QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return TrainingSession(
          id: doc.documentID,
          userID: doc.data['userID'],
          title: doc.data['title'] ?? '',
          duration: doc.data['duration'] ?? 0.0,
          description: doc.data['description'] ?? '',
          activity: Activities.fromString(doc.data['activity']) ?? '',
          difficulty: doc.data['difficulty'] ?? 0,
          enjoymentRating: doc.data['enjoymentRating'] ?? 0,
          date: doc.data['date'].toDate(),
          heartRate: doc.data['heartRate'] ?? 0,
          rpe: doc.data['rpe'] ?? 0,
          hoursOfSleep: doc.data['hoursOfSleep'] ?? 0.0,
          sleepRating: doc.data['sleepRating'] ?? 0,
          hydration: doc.data['hydration'] ?? 0.0,
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
