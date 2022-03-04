import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';
part 'home_state.dart';
part 'home_exceptions.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is SetProject) {
      if (state.selectedProject == null) {
        yield HomeState(selectedProject: event.project, selectedActivity: null);
      }
      if (state.selectedProject!.id == event.project.id) {
        yield HomeState(
            selectedProject: state.selectedProject,
            selectedActivity: state.selectedActivity);
      }
      yield HomeState(selectedProject: event.project, selectedActivity: null);
    } else if (event is SetActivity) {
      yield HomeState(
          selectedProject: state.selectedProject,
          selectedActivity: event.activity);
    }
  }
}
