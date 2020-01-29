import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/hydration_card.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/recovery_heart_rate_card.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/rpe_card.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/sleep_hours_card.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/sleep_rating_card.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class AdvancedSessionSettings extends StatefulWidget {
  final DBHelper db;
  final User user;
  final TrainingSession ts;
  final bool isEdit;
  const AdvancedSessionSettings({this.db, this.user, this.ts, this.isEdit});

  @override
  _AdvancedSessionSettingsState createState() =>
      _AdvancedSessionSettingsState();
}

class _AdvancedSessionSettingsState extends State<AdvancedSessionSettings>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

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
              HeartRateCard(
                ts: widget.ts,
                isEdit: widget.isEdit,
              ),
              RPECard(
                ts: widget.ts,
                isEdit: widget.isEdit,
              ),
              SleepHoursCard(
                ts: widget.ts,
                isEdit: widget.isEdit,
              ),
              SleepRatingCard(
                ts: widget.ts,
                isEdit: widget.isEdit,
              ),
              HydrationCard(
                ts: widget.ts,
                isEdit: widget.isEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
