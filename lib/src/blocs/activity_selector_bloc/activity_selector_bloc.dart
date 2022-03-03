import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/activity_model.dart';

part 'activity_selector_state.dart';

class ActivitySelectorBloc
    extends Bloc<ActivitySelectorEvent, ActivitySelectorState> {
  ActivitySelectorBloc({required projectId})
      : super(ActivitySelectorState(projectId: projectId));

  @override
  Stream<ActivitySelectorState> mapEventToState(
      ActivitySelectorEvent event) async* {
    if (event is NewItem) {
      ActivityTable table = ActivityTable.getTable();
      table.addActivity(event.name, state.projectId);
      yield ActivitySelectorState(projectId: state.projectId);
    }
  }
}
