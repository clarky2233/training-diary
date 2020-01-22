import 'package:training_journal/activities.dart';

class TrainingSession {
  int id;
  String userID;
  // Standard Settings //
  String title;
  int duration; // this is in minutes
  String description;
  Activity activity;
  int difficulty; // out of 5
  int enjoymentRating;
  DateTime date; // ISO8601
  // Advanced Settings //
  int heartRate;
  int rpe;
  double hoursOfSleep;
  int sleepRating;
  double hydration;
  String mood;

  TrainingSession({
    this.id,
    this.userID,
    this.title,
    this.duration,
    this.description,
    this.activity,
    this.difficulty,
    this.enjoymentRating,
    this.date,
    this.heartRate,
    this.hoursOfSleep,
    this.rpe,
    this.sleepRating,
    this.hydration,
    this.mood,
  });

  Map<String, dynamic> toMap() {
    String dateStr;
    String activityStr;
    if (date == null) {
      dateStr = null;
    } else {
      dateStr = date.toIso8601String();
    }
    if (activity == null) {
      activityStr = null;
    } else {
      activityStr = activity.name;
    }

    return {
      'id': id,
      'title': title,
      'userID': userID,
      'date': dateStr,
      'duration': duration,
      'description': description,
      'activity': activityStr,
      'difficulty': difficulty,
      'enjoymentRating': enjoymentRating,
      'heartRate': heartRate,
      'hoursOfSleep': hoursOfSleep,
      'rpe': rpe,
      'sleepRating': sleepRating,
      'hydration': hydration,
      'mood': mood,
    };
  }

  static TrainingSession fromMap(Map map) {
    return TrainingSession(
      id: map['id'],
      title: map['title'],
      userID: map['userID'],
      date: DateTime.parse(map['date']),
      duration: map['duration'],
      description: map['description'],
      activity: Activities.fromString(map['activity']),
      difficulty: map['difficulty'],
      enjoymentRating: map['enjoymentRating'],
      heartRate: map['heartRate'],
      hoursOfSleep: map['hoursOfSleep'],
      rpe: map['rpe'],
      sleepRating: map['sleeprating'],
      hydration: map['hydration'],
      mood: map['mood'],
    );
  }

  String toString() {
    return '''Id: $id
    UserID: $userID
    Title: $title
    Date: $date
    Duration: $duration
    Description: $description
    Activity: $activity
    Difficulty: $difficulty/5''';
  }

  static bool isValid(TrainingSession ts) {
    if (ts.title == null ||
        ts.duration == null ||
        ts.activity == null ||
        ts.difficulty == null ||
        ts.difficulty == 0 ||
        ts.enjoymentRating == null ||
        ts.enjoymentRating == 0) {
      return false;
    } else {
      return true;
    }
  }

  static bool isValidTemplate(TrainingSession ts) {
    if (ts.title == null || ts.title == "") {
      return false;
    } else {
      return true;
    }
  }
}
