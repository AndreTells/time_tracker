import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';

part 'activity_selector_state.dart';

class ActivitySelectorBloc
    extends Bloc<ActivitySelectorEvent, ActivitySelectorState> {
  ActivitySelectorBloc({required projectId})
      : super(ActivitySelectorState(projectId: projectId)) {
    syncWithDB();
  }

  @override
  Stream<ActivitySelectorState> mapEventToState(
      ActivitySelectorEvent event) async* {
    if (event is NewItem) {
      await DBProvider.db.newActivity(Activity(
          id: 0,
          name: event.name,
          totalTime: Duration.zero,
          projectId: state.projectId));
      syncWithDB();
      yield ActivitySelectorState(projectId: state.projectId);
    } else if (event is DeleteItem) {
      await DBProvider.db.deleteActivity(event.id);
      syncWithDB();
      yield ActivitySelectorState(projectId: state.projectId);
    } else if (event is SyncToDB) {
      yield ActivitySelectorState(
          projectId: state.projectId, activities: event.activities);
    }
  }

  void syncWithDB() async {
    List<Activity> activities =
        await DBProvider.db.getActivitiesFromProject(state.projectId);
    add(SyncToDB(activities: activities));
  }
}
