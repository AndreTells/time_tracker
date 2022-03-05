import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/blocs/time_log_list_bloc/time_log_list_bloc.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/time_log_model.dart';
import 'package:time_tracker/src/data/activity_model.dart';

class TimeLogListPage extends StatelessWidget {
  const TimeLogListPage({Key? key}) : super(key: key);
  Widget itemTemplate(TimeLog log, Project project, Activity activity) {
    return Row(
      children: [
        Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: project.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        Text(activity.name),
        const Spacer(),
        Text(log.time.toString())
      ],
    );
  }

  List<Widget> getItems(BuildContext context, List<TimeLog> timeLogs,
      List<Project> projects, List<Activity> activities) {
    return List.generate(timeLogs.length, (i) {
      Activity activity = activities
          .where((element) => element.id == timeLogs[i].activityId)
          .first;
      Project project =
          projects.where((element) => element.id == activity.id).first;
      return itemTemplate(timeLogs[i], project, activity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimeLogListBloc>(
      create: (context) => TimeLogListBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: StreamBuilder<TimeLogListState>(
              stream: BlocProvider.of<TimeLogListBloc>(context).stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      child: ListView(
                        children: getItems(context, snapshot.data!.timeLogs,
                            snapshot.data!.projects, snapshot.data!.activities),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.timer),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      }),
    );
  }
}
