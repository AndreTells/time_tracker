part of 'activity_selector_bloc.dart';

//TODO: use equitable for states and events
class ActivitySelectorState {
  List<Activity> activities;
  int projectId;
  ActivitySelectorState({required this.projectId, this.activities = const []});
}

abstract class ActivitySelectorEvent {}

class NewItem extends ActivitySelectorEvent {
  String name;
  NewItem({required this.name});
}

class DeleteItem extends ActivitySelectorEvent {
  int id;
  DeleteItem({required this.id});
}

class SyncToDB extends ActivitySelectorEvent {
  List<Activity> activities;
  SyncToDB({required this.activities});
}
