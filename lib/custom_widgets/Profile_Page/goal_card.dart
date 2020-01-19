import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/user.dart';

class GoalCard extends StatefulWidget {
  final DBHelper db;
  final User user;
  final Goal goal;

  const GoalCard({this.db, this.user, this.goal});

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  String goalValue;
  String titleStr;

  final TextEditingController textController = new TextEditingController();
  final TextEditingController titleController = new TextEditingController();

  void initState() {
    textController.text = widget.goal.text;
    titleController.text = widget.goal.title;
    super.initState();
  }

  bool isValid(Goal goal) {
    if (goal.text == null || goal.title == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _moreInfo();
      },
      child: Container(
        height: 120,
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${widget.goal.title}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _confirmDelete();
                    },
                    icon: Icon(Icons.delete),
                    iconSize: 15,
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      editGoal();
                    },
                    icon: Icon(Icons.edit),
                    iconSize: 15,
                    color: Colors.black,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  "${widget.goal.text}",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Goal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you would like to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.blue[800]),
              ),
              onPressed: () async {
                await widget.db.deleteGoal(widget.goal.id);
                Navigator.pop(context);
                List<Goal> x = await widget.db.getGoals();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              db: widget.db,
                              user: widget.user,
                              goals: x,
                            )));
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.blue[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editGoal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Edit Goal',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(5),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: 1,
                cursorColor: Colors.pink[400],
                controller: titleController,
                onChanged: (text) {
                  setState(() {
                    titleStr = text;
                    widget.goal.title = titleStr;
                  });
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    hintText: "Title",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 10,
                cursorColor: Colors.redAccent[400],
                controller: textController,
                onChanged: (text) {
                  setState(() {
                    goalValue = text;
                    widget.goal.text = goalValue;
                  });
                },
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent[400])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent[400]))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    onPressed: () async {
                      if (isValid(widget.goal)) {
                        await widget.db.updateGoal(widget.goal);
                        List<Goal> goals = await widget.db.getGoals();
                        //Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      db: widget.db,
                                      user: widget.user,
                                      goals: goals,
                                    )));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _moreInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Text(
              '${widget.goal.title}',
              style: TextStyle(fontSize: 26),
            ),
            contentPadding: EdgeInsets.all(25),
            children: <Widget>[
              Text("${widget.goal.text}"),
            ]);
      },
    );
  }
}
