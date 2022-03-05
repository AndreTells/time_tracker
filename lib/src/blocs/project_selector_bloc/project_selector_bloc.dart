import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';

part 'project_selector_state.dart';

class ProjectSelectorBloc
    extends Bloc<ProjectSelectorEvent, ProjectSelectorState> {
  ProjectSelectorBloc() : super(ProjectSelectorState()) {
    syncWithDB();
  }

  @override
  Stream<ProjectSelectorState> mapEventToState(
      ProjectSelectorEvent event) async* {
    if (event is NewItem) {
      await DBProvider.db
          .newProject(Project(id: 0, name: event.name, color: event.color));
      syncWithDB();
      yield ProjectSelectorState(projects: state.projects);
    } else if (event is DeleteItem) {
      await DBProvider.db.deleteProject(event.id);
      syncWithDB();
    } else if (event is SyncToDB) {
      yield ProjectSelectorState(projects: event.projects);
    }
  }

  void syncWithDB() async {
    List<Project> projects = await DBProvider.db.getAllProjects();
    add(SyncToDB(projects: projects));
  }
}
