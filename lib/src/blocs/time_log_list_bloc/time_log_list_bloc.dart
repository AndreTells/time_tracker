import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';
import 'package:time_tracker/src/data/time_log_model.dart';
part 'time_log_list_state.dart';

class TimeLogListBloc extends Bloc<TimeLogListEvent, TimeLogListState> {
  TimeLogListBloc() : super(TimeLogListState()) {
    syncWithDB();
  }

  @override
  Stream<TimeLogListState> mapEventToState(TimeLogListEvent event) async* {
    if (event is DeleteItem) {
      await DBProvider.db.deleteTimeLog(event.id);
      syncWithDB();
      yield TimeLogListState(timeLogs: state.timeLogs);
    } else if (event is SyncToDB) {
      yield TimeLogListState(
          timeLogs: event.timeLogs,
          projects: event.projects,
          activities: event.activities);
    }
  }

  void syncWithDB() async {
    List<TimeLog> timeLogs = await DBProvider.db.getAllTimeLogs();
    List<Project> projects = await DBProvider.db.getAllProjects();
    List<Activity> activities = await DBProvider.db.getAllActivities();
    add(SyncToDB(
        timeLogs: timeLogs, projects: projects, activities: activities));
  }
}
