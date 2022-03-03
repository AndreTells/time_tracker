import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/project_model.dart';

part 'project_selector_state.dart';

class ProjectSelectorBloc
    extends Bloc<ProjectSelectorEvent, ProjectSelectorState> {
  ProjectSelectorBloc() : super(ProjectSelectorState());

  @override
  Stream<ProjectSelectorState> mapEventToState(
      ProjectSelectorEvent event) async* {
    if (event is NewItem) {
      ProjectTable table = ProjectTable.getTable();
      table.addProject(event.name, event.color);
      yield ProjectSelectorState();
    }
  }
}
