import 'package:flutter/material.dart';

class Event {
  int id;
  String userID;
  String name;
  DateTime date;
  TimeOfDay startTime;

  Event({
    this.id,
    this.userID,
    this.name,
    this.date,
    this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'date': date.toIso8601String(),
      'startTime': startTime.toString().substring(10, 14),
    };
  }

  static Event fromMap(Map map) {
    return Event(
      id: map['id'],
      userID: map['userID'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      startTime: TimeOfDay(
          hour: int.parse(map['startTime'].split(":")[0]),
          minute: int.parse(map['startTime'].split(":")[1])),
    );
  }
}
