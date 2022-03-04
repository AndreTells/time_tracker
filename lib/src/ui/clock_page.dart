import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/time_log_model.dart';

class ClockPage extends StatelessWidget {
  final Project project;
  final Activity activity;
  final Stopwatch watch = Stopwatch();
  ClockPage({Key? key, required this.project, required this.activity})
      : super(key: key) {
    watch.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: TextButton(
              onPressed: () {
                watch.stop();
                TimeLogTable table = TimeLogTable.getTable();
                DateTime end = DateTime.now();
                DateTime start = end.add(watch.elapsed * (-1));
                table.addTimeLog(start, end, activity.id);

                Navigator.pop(context);
              },
              child: _TimerText(
                watch: watch,
              )),
        ));
  }
}

class _TimerText extends StatefulWidget {
  final Stopwatch watch;
  const _TimerText({required this.watch});

  @override
  // ignore: no_logic_in_create_state
  _TimerTextState createState() => _TimerTextState(watch: watch);
}

class _TimerTextState extends State<_TimerText> {
  late Timer timer;
  late List<String> time;
  final Stopwatch watch;

  _TimerTextState({required this.watch}) {
    timer = Timer.periodic(const Duration(milliseconds: 30), callback);
    time = getTime();
  }

  void callback(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        time = getTime();
      });
    }
  }

  String formatNumber(int num) {
    if (num >= 10) {
      return num.toString();
    } else {
      return '0' + num.toString();
    }
  }

  List<String> getTime() {
    Duration time = watch.elapsed;
    if (time.inHours == 0) {
      int minutes = time.inMinutes;
      int totalSeconds = time.inSeconds;
      int seconds = totalSeconds - minutes * 60;
      return [formatNumber(minutes), formatNumber(seconds)];
    } else {
      int hours = time.inHours;
      int totalMinutes = time.inMinutes;
      int minutes = totalMinutes - hours * 60;
      return [formatNumber(hours), formatNumber(minutes)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          time[0],
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          time[1],
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
