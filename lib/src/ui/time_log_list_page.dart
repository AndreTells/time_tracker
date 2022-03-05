import 'package:flutter/material.dart';
import 'package:time_tracker/src/data/time_log_model.dart';

class TimeLogListPage extends StatelessWidget {
  const TimeLogListPage({Key? key}) : super(key: key);
  Widget itemTemplate(TimeLog log) {
    return Row(
      children: [
        Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            //color: log.project.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        //Text(log.activity.name),
        const Spacer(),
        Text(log.time.toString())
      ],
    );
  }

  List<Widget> getTimeLogs(BuildContext context) {
    TimeLogTable table = TimeLogTable.getTable();
    List<TimeLog> timeLogs = table.getTimeLogs();
    return List.generate(timeLogs.length, (i) => itemTemplate(timeLogs[i]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(child: Column(children: [...getTimeLogs(context)])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.timer),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
