part of 'home_bloc.dart';

abstract class HomeExceptions implements Exception {
  String cause;
  String solveInstruncitons;
  HomeExceptions({required this.cause, required this.solveInstruncitons});
}

class NoSelectedProjectException extends HomeExceptions {
  NoSelectedProjectException()
      : super(
            cause: 'no project was selected in a scenario where one is needed',
            solveInstruncitons: 'please select a project');
}

class NoSelectedActivityException extends HomeExceptions {
  NoSelectedActivityException()
      : super(
            cause: 'no activity was selected in a scenario where one is needed',
            solveInstruncitons: 'please select an activity');
}
