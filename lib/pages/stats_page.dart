import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_month_stats.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_week_stats.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_year_stats.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class StatsPage extends StatefulWidget {
  final StatsManager sm;
  final User user;
  final DBHelper db;
  const StatsPage({this.sm, this.user, this.db});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String dropdownValue = 'This Week';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            elevation: 0,
            title: Text(
              "My Statistics",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            centerTitle: false,
            actions: <Widget>[
              getDropDown(),
              IconButton(
                icon: Icon(Icons.share),
                color: Colors.black,
                iconSize: 30,
                onPressed: () async {
                  await _createFile();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(child: getStats()),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red[600],
            currentIndex: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.equalizer),
                title: Text("Stats"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
              ),
            ],
            onTap: (index) async {
              if (index == 2) {
                List<Goal> goals = await widget.db.getGoals();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              db: widget.db,
                              user: widget.user,
                              goals: goals,
                            )));
              } else if (index == 1) {
                List<TrainingSession> recentTen =
                    await widget.db.lastTenSessions();
                List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              db: widget.db,
                              user: widget.user,
                              recentTen: recentTen,
                              upcoming: upcoming,
                            )));
              }
            },
          ),
        ),
      ),
    );
  }

  _createFile() async {
    await sendData();
  }

  Widget getStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (dropdownValue == "This Week") {
          return ThisWeekStats(
            sm: widget.sm,
          );
        } else if (dropdownValue == "This Year") {
          return ThisYearStats(
            sm: widget.sm,
          );
        } else if (dropdownValue == "This Month") {
          return ThisMonthStats(
            sm: widget.sm,
          );
        }
        return ThisWeekStats(
          sm: widget.sm,
        );
      },
    );
  }

  Future<void> sendData() async {
    final directory = await getTemporaryDirectory();
    String localPath = directory.path;
    final file = File('$localPath/all_training_sessions.csv');

    var result = await widget.db.getRawJournal();
    var csv = mapListToCsv(result);

    IOSink sink = file.openWrite();
    sink.writeln(csv);
    sink.close();

    final directory2 = await getTemporaryDirectory();
    String localPath2 = directory2.path;
    final file2 = File('$localPath2/user_data.csv');

    var result2 = await widget.db.getRawUser();
    var csv2 = mapListToCsv(result2);

    IOSink sink2 = file2.openWrite();
    sink2.writeln(csv2);
    sink2.close();

    final directory3 = await getTemporaryDirectory();
    String localPath3 = directory3.path;
    final file3 = File('$localPath3/last_month.csv');

    var result3 = await widget.db.getRawLastMonth();
    var csv3 = mapListToCsv(result3);

    IOSink sink3 = file3.openWrite();
    sink3.writeln(csv3);
    sink3.close();

    final directory4 = await getTemporaryDirectory();
    String localPath4 = directory4.path;
    final file4 = File('$localPath4/last_year.csv');

    var result4 = await widget.db.getRawLastYear();
    var csv4 = mapListToCsv(result4);

    IOSink sink4 = file4.openWrite();
    sink4.writeln(csv4);
    sink4.close();

    final MailOptions mailOptions = MailOptions(
      body:
          '''Open these files using Microsoft Excel to view the data. To format the date use, the following Excel formula:\n
      =DATE(LEFT(D2, 4),MID(D2, 6,2),MID(D2,9,2))''',
      subject: 'Training Diary Data',
      isHTML: true,
      attachments: [
        file.path,
        file2.path,
        file3.path,
        file4.path,
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  Widget getDropDown() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 30,
          elevation: 0,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['This Week', 'This Month', 'This Year']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
