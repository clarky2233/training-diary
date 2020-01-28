import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  final CollectionReference templateCollection =
      Firestore.instance.collection('templates');

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
    return await eventCollection.document(event.id).setData({
      'userID': event.userID,
      'name': event.name,
      'date': event.date,
      'startTime': event.startTime.toString(),
    });
  }

  Future updateTemplate(TrainingSession ts) async {
    return await templateCollection.document(ts.id).setData({
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

  Future updateTrainingSession(TrainingSession ts) async {
    return await journalCollection.document(ts.id).setData({
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
    return await goalCollection.document(goal.id).setData({
      'userID': goal.userID,
      'title': goal.title,
      'text': goal.text,
    });
  }

  Future<User> getUser() {
    return userDataCollection.document(uid).get().then((doc) {
      return User(
        id: uid ?? uid,
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
        .orderBy("date", descending: true)
        .snapshots()
        .map(_trainingSessionListFromSnapshot);
  }

  Stream<List<TrainingSession>> filtered(DateTime month) {
    if (month == null) {
      return journal;
    }
    return journalCollection
        .where("userID", isEqualTo: uid)
        .where("date", isGreaterThanOrEqualTo: month)
        .where("date",
            isLessThan: DateTime(month.year, month.month + 1, month.day))
        .orderBy("date", descending: true)
        .snapshots()
        .map(_trainingSessionListFromSnapshot);
  }

  Stream<List<TrainingSession>> get templates {
    return templateCollection
        .where("userID", isEqualTo: uid)
        .snapshots()
        .map(_trainingSessionListFromSnapshot);
  }

  Stream<List<Event>> get events {
    return eventCollection
        .where("userID", isEqualTo: uid)
        .orderBy("date", descending: true)
        .snapshots()
        .map(_eventListFromSnapshot);
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

  Future deleteEvent(String docID) {
    return eventCollection.document(docID).delete();
  }

  Future deleteTrainingSession(String docID) {
    return journalCollection.document(docID).delete();
  }

  Future deleteTemplate(String docID) {
    return templateCollection.document(docID).delete();
  }

  Stream<List<Goal>> get goals {
    return goalCollection
        .where("userID", isEqualTo: uid)
        .snapshots()
        .map(_goalListFromSnapshot);
  }

  Stream<User> get user {
    return userDataCollection.document(uid).snapshots().map(_userFromSnapshot);
  }

  User _userFromSnapshot(DocumentSnapshot snapshot) {
    return User(
      name: snapshot.data['name'] ?? '',
      username: snapshot.data['username'] ?? '',
      weight: snapshot.data['weight'] ?? 0.0,
      height: snapshot.data['height'] ?? 0,
      restingHeartRate: snapshot.data['restingHeartRate'] ?? 0,
    );
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

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return Event(
          id: doc.documentID,
          userID: doc.data['userID'],
          name: doc.data['name'] ?? '',
          date: doc.data['date'].toDate(),
          startTime: TimeOfDay(
              hour: int.parse(
                  doc.data['startTime'].substring(10, 15).split(":")[0]),
              minute: int.parse(
                  doc.data['startTime'].substring(10, 15).split(":")[1])),
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<TrainingSession> _trainingSessionListFromSnapshot(
      QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        DateTime date;
        doc.data['date'] == null
            ? date = null
            : date = doc.data['date'].toDate();
        return TrainingSession(
          id: doc.documentID,
          userID: doc.data['userID'],
          title: doc.data['title'] ?? '',
          duration: doc.data['duration'] ?? 0.0,
          description: doc.data['description'] ?? '',
          activity: Activities.fromString(doc.data['activity']) ?? '',
          difficulty: doc.data['difficulty'] ?? 0,
          enjoymentRating: doc.data['enjoymentRating'] ?? 0,
          date: date,
          heartRate: doc.data['heartRate'],
          rpe: doc.data['rpe'],
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

  Future<List<BarDataModel>> getWeekData(String dataColumn) async {
    List<TrainingSession> sessions = await journalCollection
        .where("userID", isEqualTo: uid)
        .getDocuments()
        .then(_trainingSessionListFromSnapshot);
    List<BarDataModel> data = List<BarDataModel>();
    data.add(BarDataModel(yValue: 0.0, xValue: "Mon"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Tues"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Wed"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Thur"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Fri"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Sat"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Sun"));
    if (sessions == null || sessions.length == 0) {
      return data;
    }
    for (TrainingSession session in sessions) {
      for (BarDataModel day in data) {
        if (day.xValue == getDayOfWeek(session.date.weekday)) {
          if (dataColumn == 'duration' && session.duration != null) {
            day.yValue += (session.duration / 60);
          } else if (dataColumn == 'difficulty' && session.difficulty != null) {
            difficultyTotal += x['$dataColumn'];
            difficultyCount++;
            day.yValue =
                difficultyTotal.toDouble() / difficultyCount.toDouble();
          } else if (dataColumn == 'enjoymentRating') {
            enjoymentTotal += x['$dataColumn'];
            enjoymentCount++;
            day.yValue = enjoymentTotal.toDouble() / enjoymentCount.toDouble();
          } else if (dataColumn == 'hydration') {
            day.yValue += x['$dataColumn'].toDouble();
          } else {
            day.yValue = x['$dataColumn'].toDouble();
          }
        }
      }
    }
  }

  String getDayOfWeek(int i) {
    if (i == 1) {
      return "Mon";
    } else if (i == 2) {
      return "Tues";
    } else if (i == 3) {
      return "Wed";
    } else if (i == 4) {
      return "Thur";
    } else if (i == 5) {
      return "Fri";
    } else if (i == 6) {
      return "Sat";
    } else if (i == 7) {
      return "Sun";
    }
    return "NULL";
  }
}

class TSDataModel {
  DateTime xValue;
  double yValue;

  TSDataModel({this.xValue, this.yValue});

  String toString() {
    return "$xValue ($yValue)";
  }
}

class BarDataModel {
  final String xValue;
  double yValue;

  BarDataModel({this.xValue, this.yValue});

  static BarDataModel fromMap(Map<String, dynamic> map, String dataColumn) {
    return BarDataModel(
        xValue: map['date'] ?? null, yValue: map['$dataColumn']);
  }
}

class PieDataModel {
  String name;
  int total;

  PieDataModel({this.name, this.total});
}
