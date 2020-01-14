import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/activities.dart';
import 'package:training_journal/user.dart';

class DBHelper {
  Future<Database> database;

  void setup() async {
    database = createDatabase();
    final Database db = await database;
    createTables(db);
  }

  Future<Database> createDatabase() async {
    Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'journal_database.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS journal(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userID INTEGER NOT NULL,
            title TEXT NOT NULL,
            date Text NOT NULL,
            duration INTEGER NOT NULL,
            description TEXT,
            activity TEXT NOT NULL,
            difficulty INTEGER NOT NULL,
            heartRate INTEGER,
            rpe INTEGER,
            hoursOfSleep REAL,
            sleepRating INTEGER,
            hydration REAL,
            mood TEXT,
            FOREIGN KEY(userID) REFERENCES users(id)
            )''');
      },
      version: 1,
    );
    return database;
  }

  void createTables(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username type UNIQUE NOT NULL,
        name TEXT NOT NULL,
        dob TEXT NOT NULL,
        weight REAL,
        height INTEGER,
        restingHeartRate INTEGER
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userID INTEGER NOT NULL,
        title TEXT,
        text TEXT,
        FOREIGN KEY(userID) REFERENCES users(id)
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userID INTEGER NOT NULL,
        name TEXT,
        date TEXT,
        startTime TEXT,
        FOREIGN KEY(userID) REFERENCES users(id)
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS templates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userID INTEGER NOT NULL,
            title TEXT NOT NULL,
            date Text,
            duration INTEGER,
            description TEXT,
            activity TEXT,
            difficulty INTEGER,
            heartRate INTEGER,
            rpe INTEGER,
            hoursOfSleep REAL,
            sleepRating INTEGER,
            hydration REAL,
            mood TEXT,
            FOREIGN KEY(userID) REFERENCES users(id)
            )''');
  }

  Future<void> insertSession(TrainingSession ts) async {
    final Database db = await database;
    await db.insert(
      'journal',
      ts.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTemplate(TrainingSession ts) async {
    final Database db = await database;
    await db.insert(
      'templates',
      ts.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertEvent(Event event) async {
    final Database db = await database;
    await db.insert('events', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TrainingSession>> getJournal() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM journal ORDER BY date DESC');
    return List.generate(maps.length, (i) {
      return generateSession(maps, i);
    });
  }

  Future<List<Map<String, dynamic>>> getRawJournal() async {
    final db = await database;
    return await db.query('journal');
  }

  Future<List<Map<String, dynamic>>> getRawUser() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getRawLastMonth() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM journal WHERE date >= DATETIME('now', 'start of month', '-1 month') AND date < DATETIME('now','start of month') ORDER BY date ASC");
    return maps;
  }

  Future<List<Map<String, dynamic>>> getRawLastYear() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM journal WHERE date >= DATETIME('now', 'start of year', '-1 year') AND date < DATETIME('now','start of year') ORDER BY date ASC");
    return maps;
  }

  Future<List<TrainingSession>> getTemplates() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM templates');
    List<TrainingSession> x = List.generate(maps.length, (i) {
      return generateTemplate(maps, i);
    });
    return x.reversed.toList();
  }

  Future<List<Event>> getEvents() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM events ORDER BY date');
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        userID: maps[i]['userID'],
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date']),
        startTime: TimeOfDay(
            hour: int.parse(maps[i]['startTime'].split(":")[0]),
            minute: int.parse(maps[i]['startTime'].split(":")[1])),
      );
    });
  }

  Future<void> updateJournalEntry(TrainingSession ts) async {
    final db = await database;
    await db.update(
      'journal',
      ts.toMap(),
      where: "id = ?",
      whereArgs: [ts.id],
    );
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: "id = ?",
      whereArgs: [event.id],
    );
  }

  Future<void> deleteJournalEntry(int id) async {
    final db = await database;
    await db.delete(
      'journal',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteTemplate(int id) async {
    final db = await database;
    await db.delete(
      'templates',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      'events',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<TrainingSession> getJournalEntry(int id) async {
    final db = await database;
    try {
      List<Map> results = await db.query(
        'journal',
        columns: [
          "id",
          "userID",
          "title",
          "date",
          "duration",
          "description",
          "activity",
          "difficulty",
          "heartRate",
          "rpe",
          "hoursOfSleep",
          "sleepRating",
          "hydration",
          "mood"
        ],
        where: "id = ?",
        whereArgs: [id],
      );
      return TrainingSession.fromMap(results[0]);
    } catch (e) {
      return null;
    }
  }

  Future<void> insertUser(User user) async {
    final Database db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        dob: DateTime.parse(maps[i]['dob']),
        name: maps[i]['name'],
        weight: maps[i]['weight'],
        height: maps[i]['height'],
        restingHeartRate: maps[i]['restingHeartRate'],
      );
    });
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<User> getUser(int id) async {
    final db = await database;
    try {
      List<Map> results = await db.query(
        'users',
        columns: [
          "id",
          "username",
          "name",
          "dob",
          "weight",
          "height",
          "restingHeartRate"
        ],
        where: "id = ?",
        whereArgs: [id],
      );
      return User.fromMap(results[0]);
    } catch (e) {
      print("NO SUCH ENTRY");
      return null;
    }
  }

  Future<int> getUsersCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM users'));
  }

  Future<int> getEventCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM events'));
  }

  Future<List<TrainingSession>> lastTenSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM journal ORDER BY date DESC Limit 10');
    return List.generate(maps.length, (i) {
      return generateSession(maps, i);
    });
  }

  Future<List<TrainingSession>> getFiltered(DateTime date) async {
    final db = await database;
    String dateStr = date.toIso8601String().substring(0, 7);
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from journal where strftime('%Y-%m', date) = '$dateStr' ");
    return List.generate(maps.length, (i) {
      return generateSession(maps, i);
    });
  }

  Future<void> insertGoal(Goal goal) async {
    final Database db = await database;
    await db.insert(
      'goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Goal>> getGoals() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    List<Goal> x = List.generate(maps.length, (i) {
      return Goal(
        id: maps[i]['id'],
        userID: maps[i]['userID'],
        title: maps[i]['title'],
        text: maps[i]['text'],
      );
    });
    return x.reversed.toList();
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await database;
    await db.update(
      'goals',
      goal.toMap(),
      where: "id = ?",
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(int id) async {
    final db = await database;
    await db.delete(
      'goals',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  TrainingSession generateSession(List<Map<String, dynamic>> maps, int i) {
    return TrainingSession(
      id: maps[i]['id'],
      userID: maps[i]['userID'],
      title: maps[i]['title'],
      date: DateTime.parse(maps[i]['date']),
      duration: maps[i]['duration'],
      description: maps[i]['description'],
      activity: Activities.fromString(maps[i]['activity']),
      difficulty: maps[i]['difficulty'],
      heartRate: maps[i]['heartRate'],
      rpe: maps[i]['rpe'],
      hoursOfSleep: maps[i]['hoursOfSleep'],
      sleepRating: maps[i]['sleepRating'],
      hydration: maps[i]['hydration'],
      mood: maps[i]['mood'],
    );
  }

  TrainingSession generateTemplate(List<Map<String, dynamic>> maps, int i) {
    DateTime datetime;
    try {
      datetime = DateTime.parse(maps[i]['date']);
    } catch (e) {
      datetime = null;
    }
    return TrainingSession(
      id: maps[i]['id'],
      userID: maps[i]['userID'],
      title: maps[i]['title'],
      date: datetime,
      duration: maps[i]['duration'],
      description: maps[i]['description'],
      activity: Activities.fromString(maps[i]['activity']),
      difficulty: maps[i]['difficulty'],
      heartRate: maps[i]['heartRate'],
      rpe: maps[i]['rpe'],
      hoursOfSleep: maps[i]['hoursOfSleep'],
      sleepRating: maps[i]['sleepRating'],
      hydration: maps[i]['hydration'],
      mood: maps[i]['mood'],
    );
  }
}
