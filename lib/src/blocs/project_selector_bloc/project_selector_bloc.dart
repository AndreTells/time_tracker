import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';

part 'project_selector_state.dart';

class ProjectSelectorBloc
    extends Bloc<ProjectSelectorEvent, ProjectSelectorState> {
  ProjectSelectorBloc() : super(ProjectSelectorState()) {
    syncProjectsWithDB();
  }

  @override
  Stream<ProjectSelectorState> mapEventToState(
      ProjectSelectorEvent event) async* {
    if (event is NewItem) {
      await DBProvider.db
          .newProject(Project(id: 0, name: event.name, color: event.color));
      syncProjectsWithDB();
      yield ProjectSelectorState(projects: state.projects);
    } else if (event is SyncToDB) {
      yield ProjectSelectorState(projects: event.projects);
    }
  }

  void syncProjectsWithDB() async {
    List<Project> projects = await DBProvider.db.getAllProjects();
    add(SyncToDB(projects: projects));
  }
}
