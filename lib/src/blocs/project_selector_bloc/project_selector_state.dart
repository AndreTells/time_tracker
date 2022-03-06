part of 'project_selector_bloc.dart';

//TODO: use equatable for states and events
class ProjectSelectorState {
  List<Project> projects;
  ProjectSelectorState({this.projects = const []});
}

abstract class ProjectSelectorEvent {}

class NewItem extends ProjectSelectorEvent {
  String name;
  Color color;
  NewItem({required this.name, required this.color});
}

class DeleteItem extends ProjectSelectorEvent {
  int id;
  DeleteItem({required this.id});
}

class SyncToDB extends ProjectSelectorEvent {
  List<Project> projects;
  SyncToDB({required this.projects});
}
