part of 'activity_selector_bloc.dart';

class ActivitySelectorState {
  List<Activity> items = [];
  int projectId;
  ActivitySelectorState({required this.projectId}) {
    updateItems();
  }

  List<Activity> getActivities() {
    return items;
  }

  void updateItems() {
    ActivityTable table = ActivityTable.getTable();
    items = table.getActivitiesOfProject(projectId);
  }
}

abstract class ActivitySelectorEvent {}

class NewItem extends ActivitySelectorEvent {
  String name;
  NewItem({required this.name});
}
