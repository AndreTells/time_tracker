part of 'project_selector_bloc.dart';

class ProjectSelectorState {
  List<Project> items = [];
  ProjectSelectorState() {
    updateItems();
  }

  List<Project> getProjects() {
    return items;
  }

  void updateItems() {
    ProjectTable table = ProjectTable.getTable();
    items = table.getProjects();
  }
}

abstract class ProjectSelectorEvent {}

class NewItem extends ProjectSelectorEvent {
  String name;
  Color color;
  NewItem({required this.name, required this.color});
}
