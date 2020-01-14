import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/date_card.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/description_card.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/duration_card.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/rating_card.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/title_card.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/activity_card.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';


class StandardSessionSettings extends StatefulWidget {

  final DBHelper db;
  final User user;
  final TrainingSession ts;
  final bool isEdit;
  const StandardSessionSettings({this.db, this.user, this.ts, this.isEdit,});

  @override
  _StandardSessionSettingsState createState() => _StandardSessionSettingsState();
}

class _StandardSessionSettingsState extends State<StandardSessionSettings> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TitleCard(ts: widget.ts, isEdit: widget.isEdit,),
              DateCard(ts: widget.ts, isEdit: widget.isEdit,),
              DurationCard(ts: widget.ts, isEdit: widget.isEdit,),
              ActivityCard(ts: widget.ts, isEdit: widget.isEdit,),
              DescriptionCard(ts: widget.ts, isEdit: widget.isEdit,),
              RatingCard(name: "Intensity", ts: widget.ts, isEdit: widget.isEdit,),
            ],
          ),
        ),
      ),
    );
  }
}