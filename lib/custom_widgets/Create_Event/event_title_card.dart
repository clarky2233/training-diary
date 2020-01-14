import 'package:flutter/material.dart';
import 'package:training_journal/event.dart';

class EventTitleCard extends StatefulWidget {
  final Event event;
  final bool isEdit;
  const EventTitleCard({this.event, this.isEdit});
  
  @override
  _EventTitleCardState createState() => _EventTitleCardState();
}

class _EventTitleCardState extends State<EventTitleCard> {

  String titleValue;
  String original;

  final TextEditingController textController = new TextEditingController();

    @override
    void initState() {
      if (widget.isEdit) {
        textController.text = widget.event.name;
        original = widget.event.name;
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
                  widget.event.name = titleValue;
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