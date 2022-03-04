part of 'home_bloc.dart';

class HomeState {
  Project? selectedProject;
  Activity? selectedActivity;
  HomeState({this.selectedActivity, this.selectedProject});

  String getProjectText() {
    if (selectedProject == null) {
      return 'Select a Project';
    } else {
      return selectedProject!.name;
    }
  }

  String getActivityText() {
    if (selectedActivity == null) {
      return 'Select an Activity';
    } else {
      return selectedActivity!.name;
    }
  }

  void validateProject() {
    if (selectedProject == null) {
      throw NoSelectedProjectException();
    }
  }

  void validateActivity() {
    if (selectedActivity == null) {
      throw NoSelectedActivityException();
    }
  }
}

abstract class HomeEvent {}

class SetProject extends HomeEvent {
  final Project project;
  SetProject({required this.project});
}

class SetActivity extends HomeEvent {
  final Activity activity;
  SetActivity({required this.activity});
}
