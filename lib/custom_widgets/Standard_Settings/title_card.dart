import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class TitleCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const TitleCard({this.ts, this.isEdit});
  
  @override
  _TitleCardState createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {

  String titleValue;
  String original;

  final TextEditingController textController = new TextEditingController();

    @override
    void initState() {
      if (widget.isEdit) {
        textController.text = widget.ts.title;
        original = widget.ts.title;
      }
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Title",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),              
            ),
            TextField(
              maxLines: 1,
              cursorColor: Colors.pink[400],
              controller: textController,
              onSubmitted: (text) {
                setState(() {
                  titleValue = text;
                });
              },
              onChanged: (text) {
                setState(() {
                  titleValue = text;
                  widget.ts.title = titleValue;
                });
              },
              style: TextStyle(
                fontSize: 22,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[400]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[400]),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}