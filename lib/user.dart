class User {
  int id;
  String username;
  String name;
  DateTime dob;
  double weight;
  int height;
  int restingHeartRate;

  User({
    this.id,
    this.username,
    this.name,
    this.dob,
    this.weight,
    this.restingHeartRate,
    this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'dob': dob.toIso8601String(),
      'weight': weight,
      'height': height,
      'restingHeartRate': restingHeartRate,
    };
  }

  static User fromMap(Map map) {
    return User(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      dob: DateTime.parse(map['dob']),
      weight: map['weight'],
      height: map['height'],
      restingHeartRate: map['restingHeartRate'],
    );
  }

  String toString() {
    return "$name [$id] ($username) + $weight";
  }

  void setWeight(String text) {
    if (text == "") {
      weight = null;
      return;
    }
    try {
      weight = double.parse(text);
    } catch (e) {
      weight = -1234.0;
    }
  }

  static bool isValid(User user) {
    if (user.name == null ||
        user.username == null ||
        user.dob == null ||
        user.name == "" ||
        user.username == "" ||
        user.weight == -1234.0 ||
        user.height == -1234 ||
        user.restingHeartRate == -1234) {
      return false;
    } else {
      return true;
    }
  }
}

class Goal {
  int id;
  int userID;
  String title;
  String text;

  Goal({this.id, this.userID, this.text, this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'title': title,
      'text': text,
    };
  }

  static Goal fromMap(Map map) {
    return Goal(
      id: map['id'],
      userID: map['userID'],
      title: map['title'],
      text: map['text'],
    );
  }

  String toString() {
    return "$title: $text";
  }
}
