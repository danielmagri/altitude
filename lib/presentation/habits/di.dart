import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/presentation/habits/domain/usecases/add_habit_usecase.dart';
import 'package:altitude/presentation/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:altitude/presentation/habits/domain/usecases/get_calendar_days_done_usecase.dart';
import 'package:altitude/presentation/habits/domain/usecases/has_competition_by_habit_usecase.dart';
import 'package:altitude/presentation/habits/domain/usecases/update_habit_usecase.dart';
import 'package:altitude/presentation/habits/domain/usecases/update_reminder_usecase.dart';
import 'package:altitude/presentation/habits/presentation/controllers/add_habit_controller.dart';
import 'package:altitude/presentation/habits/presentation/controllers/edit_alarm_controller.dart';
import 'package:altitude/presentation/habits/presentation/controllers/edit_cue_controller.dart';
import 'package:altitude/presentation/habits/presentation/controllers/edit_habit_controller.dart';
import 'package:altitude/presentation/habits/presentation/controllers/habit_details_controller.dart';

void setupHabits() {
  // USECASES
  serviceLocator.registerFactory(() => AddHabitUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => DeleteHabitUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => GetCalendarDaysDoneUsecase(
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => HasCompetitionByHabitUsecase(
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => UpdateHabitUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => UpdateReminderUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  // CONTROLLERS

  serviceLocator.registerLazySingleton(() => AddHabitController(
        serviceLocator.get(),
      ));

  serviceLocator.registerLazySingleton(() => EditAlarmController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerLazySingleton(() => EditCueController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerLazySingleton(() => EditHabitController(
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerLazySingleton(() => HabitDetailsController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));
}
