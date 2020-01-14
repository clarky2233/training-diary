import 'package:flutter/material.dart';

class Activity {

  String name;
  IconData icon;

  Activity({this.name, this.icon});

  String toString() {
    return name;
  }
}

class Activities {
  static List<Activity> activities = [
    Activity(name: "Strength", icon: Icons.fitness_center),
    Activity(name: "Running", icon: Icons.directions_run),
    Activity(name: "Swimming", icon: Icons.pool),
    Activity(name: "Biking", icon: Icons.directions_bike),
    Activity(name: "Cardio", icon: Icons.timer),
    Activity(name: "Technical", icon: Icons.gps_fixed),
    Activity(name: "Rowing", icon: Icons.rowing),
    Activity(name: "Game Day", icon: Icons.games),
    Activity(name: "Pilates", icon: Icons.spa),
    Activity(name: "Stretching", icon: Icons.hourglass_empty),
    Activity(name: "Other", icon: Icons.tag_faces),
  ];

  static Activity fromString(String name) {
    for (Activity act in activities) {
      if (act.name == name) {
        Activity newAct = act;
        return newAct;
      }
    }
    return null;
  }

  // static int getIndex(String name) {
  //   for (Activity act in activities) {
  //     if (act.name == name) {
  //       Activity newAct = act;
  //       return newAct;
  //     }
  //   }
  //   return null;
  // }

}