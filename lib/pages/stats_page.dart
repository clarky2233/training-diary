import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_month_stats.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_week_stats.dart';
import 'package:training_journal/custom_widgets/Stats_Page/this_year_stats.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/user.dart';

class StatsPage extends StatefulWidget {
  final User user;
  const StatsPage({this.user});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DatabaseService firestore;
  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

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
            backgroundColor: Colors.redAccent,
            elevation: 0,
            title: Text(
              "My Statistics",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                color: Colors.white,
                iconSize: 30,
                onPressed: () async {
                  await _createFile();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getDropDown(),
                getStats(),
              ],
            ),
          ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user: widget.user,
                            )));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home2(
                              user: widget.user,
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
            user: widget.user,
          );
        } else if (dropdownValue == "This Year") {
          return ThisYearStats(
            user: widget.user,
          );
        } else if (dropdownValue == "This Month") {
          return ThisMonthStats(
            user: widget.user,
          );
        }
        return ThisWeekStats(
          user: widget.user,
        );
      },
    );
  }

  Future<void> sendData() async {
    final directory = await getTemporaryDirectory();
    String localPath = directory.path;
    final file = File('$localPath/all_training_sessions.csv');

    var result = await firestore.getRawJournal();
    var csv = mapListToCsv(result);

    IOSink sink = file.openWrite();
    sink.writeln(csv);
    sink.close();

    final directory2 = await getTemporaryDirectory();
    String localPath2 = directory2.path;
    final file2 = File('$localPath2/user_data.csv');

    var result2 = await firestore.getRawUser();
    var csv2 = mapListToCsv(result2);

    IOSink sink2 = file2.openWrite();
    sink2.writeln(csv2);
    sink2.close();

    final MailOptions mailOptions = MailOptions(
      body:
          '''Open these files using Microsoft Excel to view the data. To format the date select the column then the format tab and select your desired format.''',
      subject: 'Training Diary Data',
      isHTML: true,
      attachments: [
        file.path,
        file2.path,
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  Widget getDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        iconSize: 30,
        elevation: 0,
        style: TextStyle(
          color: Colors.white,
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
            child: Center(
                child: Text(
              value,
              style: TextStyle(color: Colors.black),
            )),
          );
        }).toList(),
      ),
    );
  }
}
