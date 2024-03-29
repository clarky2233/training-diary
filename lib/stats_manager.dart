import 'package:date_util/date_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/activities.dart';

class StatsManager {
  DBHelper dbhelper;

  int totalSessions;
  int totalDuration;
  List<BarDataModel> recentTenDuration;

  StatsManager({this.dbhelper});

  Future<void> setTotalSessions() async {
    final database = await dbhelper.database;
    totalSessions = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM journal'));
  }

  Future<void> setTotalDuration() async {
    final database = await dbhelper.database;
    totalDuration = Sqflite.firstIntValue(
        await database.rawQuery("SELECT SUM(duration) FROM journal"));
  }

  Future<List<List<BarDataModel>>> getSummaryData() async {
    List<List<BarDataModel>> data = List<List<BarDataModel>>();
    final database = await dbhelper.database;
    List<Map<String, dynamic>> maps;
    List<Map<String, dynamic>> maps2;
    if (DateTime.now().weekday == 1) {
      maps = await database.rawQuery(
          "SELECT date, duration FROM journal WHERE DATE(date) >= (SELECT DATE('now', 'start of day')) AND DATE(date) <= (SELECT DATE('now', 'start of day', '+7 days')) ORDER BY date ASC");
      maps2 = await database.rawQuery(
          "SELECT date, difficulty FROM journal WHERE DATE(date) >= (SELECT DATE('now', 'start of day')) AND DATE(date) <= (SELECT DATE('now', 'start of day', '+7 days')) ORDER BY date ASC");
    } else {
      maps = await database.rawQuery(
          "SELECT date, duration FROM journal WHERE DATE(date) > (SELECT DATE('now', 'weekday 0', 'start of day', '-7 days')) AND date < (SELECT DATE('now', 'start of day', 'weekday 0', '+1 days')) ORDER BY date ASC");
      maps2 = await database.rawQuery(
          "SELECT date, difficulty FROM journal WHERE DATE(date) > (SELECT DATE('now', 'weekday 0', 'start of day', '-7 days')) AND date < (SELECT DATE('now', 'start of day', 'weekday 0', '+1 days')) ORDER BY date ASC");
    }
    data.add(weekBarData(maps, 'duration'));
    data.add(weekBarData(maps2, 'difficulty'));
    return data;
  }

  Future<List<BarDataModel>> getWeekData(String dataColumn) async {
    final database = await dbhelper.database;
    List<Map<String, dynamic>> maps;
    if (DateTime.now().weekday == 1) {
      maps = await database.rawQuery(
          "SELECT date, $dataColumn FROM journal WHERE DATE(date) >= (SELECT DATE('now', 'start of day')) AND DATE(date) <= (SELECT DATE('now', 'start of day', '+7 days')) ORDER BY date ASC");
    } else {
      maps = await database.rawQuery(
          "SELECT date, $dataColumn FROM journal WHERE DATE(date) > (SELECT DATE('now', 'weekday 0', 'start of day', '-7 days')) AND date < (SELECT DATE('now', 'start of day', 'weekday 0', '+1 days')) ORDER BY date ASC");
    }
    if (dataColumn == 'activity') {
      return pieChartData(maps, dataColumn);
    } else {
      return weekBarData(maps, dataColumn);
    }
  }

  Future<List<TSDataModel>> getMonthData(String dataColumn) async {
    final database = await dbhelper.database;
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT date, $dataColumn FROM journal WHERE date >= DATETIME('now', 'start of month') AND date <= DATETIME('now','start of month','+1 month') ORDER BY date ASC");
    return monthTSData(maps, dataColumn);
  }

  Future<List<TSDataModel>> getYearData(String dataColumn) async {
    final database = await dbhelper.database;
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT date, $dataColumn FROM journal WHERE date >= DATETIME('now', 'start of year') AND date <= DATETIME('now','start of year','+1 year') ORDER BY date ASC");
    return monthTSData(maps, dataColumn);
  }

  List<BarDataModel> pieChartData(
      List<Map<String, dynamic>> maps, String dataColumn) {
    List<BarDataModel> data = List<BarDataModel>();
    for (Activity act in Activities.activities) {
      data.add(BarDataModel(xValue: act.name, yValue: 0.0));
    }
    for (Map<String, dynamic> x in maps) {
      for (BarDataModel day in data) {
        if (day.xValue == x['$dataColumn']) {
          day.yValue++;
        }
      }
    }
    return data;
  }

  List<TSDataModel> monthTSData(
      List<Map<String, dynamic>> maps, String dataColumn) {
    int difficultyCount = 0;
    int difficultyTotal = 0;
    int enjoymentCount = 0;
    int enjoymentTotal = 0;
    List<TSDataModel> data = List<TSDataModel>();
    for (Map<String, dynamic> x in maps) {
      TSDataModel tsdm = TSDataModel(yValue: 0.0);
      for (TSDataModel y in data) {
        if (y.xValue.day == DateTime.parse(x['date']).day &&
            y.xValue.month == DateTime.parse(x['date']).month &&
            y.xValue.year == DateTime.parse(x['date']).year) {
          tsdm = y;
          break;
        } else {}
      }
      if (tsdm.xValue == null) {
        tsdm.xValue = DateTime.parse(x['date']);
      }
      if (x['$dataColumn'] != null) {
        if (dataColumn == 'duration') {
          tsdm.yValue += (x['$dataColumn'] / 60);
        } else if (dataColumn == 'hydration') {
          tsdm.yValue += x['$dataColumn'].toDouble();
        } else if (dataColumn == 'difficulty') {
          difficultyTotal += x['$dataColumn'];
          difficultyCount++;
          tsdm.yValue = difficultyTotal.toDouble() / difficultyCount.toDouble();
        } else if (dataColumn == 'enjoymentRating') {
          enjoymentTotal += x['$dataColumn'];
          enjoymentCount++;
          tsdm.yValue = enjoymentTotal.toDouble() / enjoymentCount.toDouble();
        } else {
          tsdm.yValue = x['$dataColumn'].toDouble();
        }
      }
      if (tsdm.yValue != 0.0) {
        data.add(tsdm);
      }
    }

    return data;
  }

  List<BarDataModel> weekBarData(
      List<Map<String, dynamic>> maps, String dataColumn) {
    List<BarDataModel> data = List<BarDataModel>();
    data.add(BarDataModel(yValue: 0.0, xValue: "Mon"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Tues"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Wed"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Thur"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Fri"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Sat"));
    data.add(BarDataModel(yValue: 0.0, xValue: "Sun"));
    if (maps == null || maps.length == 0) {
      return data;
    }
    for (Map<String, dynamic> x in maps) {
      for (BarDataModel day in data) {
        int difficultyCount = 0;
        int difficultyTotal = 0;
        int enjoymentCount = 0;
        int enjoymentTotal = 0;
        if (day.xValue == getDayOfWeek(DateTime.parse(x['date']).weekday) &&
            x['$dataColumn'] != null) {
          if (dataColumn == 'duration') {
            day.yValue += (x['$dataColumn'] / 60);
          } else if (dataColumn == 'difficulty') {
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
    return data;
  }

  List<BarDataModel> monthBarData(
      List<Map<String, dynamic>> maps, String dataColumn) {
    List<BarDataModel> data = List<BarDataModel>();
    DateUtil dateUtil = DateUtil();
    int days = dateUtil.daysInMonth(DateTime.now().month, DateTime.now().year);
    for (int i = 0; i < days; i++) {
      data.add(BarDataModel(yValue: 0.0, xValue: i.toString()));
    }
    for (Map<String, dynamic> x in maps) {
      for (BarDataModel day in data) {
        if (day.xValue == DateTime.parse(x['date']).day.toString() &&
            x['$dataColumn'] != null) {
          if (dataColumn == 'duration') {
            day.yValue += x['$dataColumn'] / 60;
          } else if (dataColumn == 'hydration') {
            day.yValue += x['$dataColumn'].toDouble();
          } else {
            day.yValue = x['$dataColumn'].toDouble();
          }
        }
      }
    }
    return data;
  }

  List<BarDataModel> yearBarData(
      List<Map<String, dynamic>> maps, String dataColumn) {
    List<BarDataModel> data = List<BarDataModel>();
    int days = 365;
    for (int i = 0; i < days; i++) {
      data.add(BarDataModel(yValue: 0.0, xValue: i.toString()));
    }
    for (Map<String, dynamic> x in maps) {
      for (BarDataModel day in data) {
        if (day.xValue == DateTime.parse(x['date']).day.toString() &&
            x['$dataColumn'] != null) {
          if (dataColumn == 'duration') {
            day.yValue += x['$dataColumn'] / 60;
          } else if (dataColumn == 'hydration') {
            day.yValue += x['$dataColumn'].toDouble();
          } else {
            day.yValue = x['$dataColumn'].toDouble();
          }
        }
      }
    }
    return data;
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

  TSDataModel containsDate(List<TSDataModel> data, Map<String, dynamic> x) {
    for (TSDataModel y in data) {
      if (y.xValue == DateTime.parse(x['date'])) {
        return y;
      }
    }
    return TSDataModel(yValue: 0.0);
  }

  List<double> barGraphStats(List<BarDataModel> data) {
    List<double> stats = [0.0, 0.0, 0.0];
    if (data == null || data.length == 0) {
      return stats;
    }
    int today = DateTime.now().weekday - 1; // Monday is 1
    double sum = 0.0;
    double count = 0.0;
    double max = data[0].yValue;
    double min = data[0].yValue;
    for (BarDataModel value in data) {
      if (data.indexOf(value) > today) {
        break;
      }
      sum += value.yValue;
      count++;
      if (value.yValue > max) {
        max = value.yValue;
      }
      if (value.yValue < min) {
        min = value.yValue;
      }
    }
    double average = sum / count;
    stats[0] = average;
    stats[1] = max;
    stats[2] = min;
    return stats;
  }

  List<double> tsGraphStats(List<TSDataModel> data) {
    List<double> stats = [0.0, 0.0, 0.0];
    if (data == null || data.length == 0) {
      return stats;
    }
    double sum = 0.0;
    double max = data[0].yValue;
    double min = data[0].yValue;
    for (TSDataModel value in data) {
      sum += value.yValue;
      if (value.yValue > max) {
        max = value.yValue;
      }
      if (value.yValue < min) {
        min = value.yValue;
      }
    }
    double average = sum / data.length;
    stats[0] = average;
    stats[1] = max;
    stats[2] = min;
    return stats;
  }
}

// class TSDataModel {
//   DateTime xValue;
//   double yValue;

//   TSDataModel({this.xValue, this.yValue});

//   String toString() {
//     return "$xValue ($yValue)";
//   }
// }

// class BarDataModel {
//   final String xValue;
//   double yValue;

//   BarDataModel({this.xValue, this.yValue});
// }

// class PieDataModel {
//   String name;
//   int total;

//   PieDataModel({this.name, this.total});
// }
