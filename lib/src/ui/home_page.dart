import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/blocs/home_bloc/home_bloc.dart';
import 'package:time_tracker/src/components/notification.dart';
import 'package:time_tracker/src/data/activity_model.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/ui/activity_selector_page.dart';
import 'package:time_tracker/src/ui/clock_page.dart';
import 'package:time_tracker/src/ui/project_selector_page.dart';
import 'package:time_tracker/src/ui/time_log_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
          child: Builder(builder: (context) {
            return Column(
              children: [
                TextButton(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        '00',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text('00', style: Theme.of(context).textTheme.headline1)
                    ],
                  ),
                  onPressed: () {
                    HomeState state = BlocProvider.of<HomeBloc>(context).state;
                    try {
                      state.validateProject();
                      state.validateActivity();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ClockPage(
                                  project: state.selectedProject!,
                                  activity: state.selectedActivity!)));
                    } on HomeExceptions catch (e) {
                      CustomAlertNotification.createNotification(
                          context, e.solveInstruncitons);
                    }
                  },
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) {
                    if (Project.identical(
                        previous.selectedProject, current.selectedProject)) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    return Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                      child: Center(
                          child: TextButton(
                        onPressed: () async {
                          final Project project = await Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      const ProjectSelectorPage()));

                          BlocProvider.of<HomeBloc>(context)
                              .add(SetProject(project: project));
                        },
                        child: Text(
                          state.getProjectText(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) {
                    if (Activity.identical(previous.selectedActivity,
                            current.selectedActivity) &&
                        Project.identical(previous.selectedProject,
                            current.selectedProject)) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    return Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                      child: Center(
                          child: TextButton(
                        onPressed: () async {
                          try {
                            state.validateProject();
                            final Activity activity = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        ActivitySelectorPage(
                                            projectId:
                                                state.selectedProject!.id)));

                            BlocProvider.of<HomeBloc>(context)
                                .add(SetActivity(activity: activity));
                          } on HomeExceptions catch (e) {
                            CustomAlertNotification.createNotification(
                                context, e.solveInstruncitons);
                          }
                        },
                        child: Text(
                          state.getActivityText(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const TimeLogListPage()))
        },
        child: const Icon(Icons.format_list_bulleted),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
