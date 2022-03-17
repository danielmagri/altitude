import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/enums/StateType.dart';
import 'package:altitude/core/model/result.dart';
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mockito/mockito.dart';
import '../../config/init_config.dart';

HomeController get logic => GetIt.I.get<HomeController>();

void main() {
  setUp(() {
    initConfig(mockUseCase: true);
  });

  group('getUser', () {
    test('returns person data success', () async {
      final personUseCase = PersonUseCase.getI;
      final Person data = Person();

      expect(logic.user.state, StateType.INITIAL);

      when(personUseCase.getPerson()).thenAnswer((_) => Future.value(Result.success(data)));

      logic.getUser();

      await mobx.asyncWhen((_) => logic.user.state != StateType.INITIAL);

      expect(logic.user.state, StateType.SUCESS);
      expect(logic.user.data, data);
    });

    test('returns person data error', () async {
      final personUseCase = PersonUseCase.getI;
      final dynamic error = "error";

      expect(logic.user.state, StateType.INITIAL);

      when(personUseCase.getPerson()).thenAnswer((_) => Future.value(Result.error(error)));

      logic.getUser();

      await mobx.asyncWhen((_) => logic.user.state != StateType.INITIAL);

      expect(logic.user.state, StateType.ERROR);
      expect(logic.user.error, error);
    });
  });

  group('getHabits', () {
    test('returns habits list', () async {
      final habitUseCase = HabitUseCase.getI;
      final List<Habit> data = [Habit()];

      expect(logic.habits.state, StateType.INITIAL);

      when(habitUseCase.getHabits()).thenAnswer((_) => Future.value(Result.success(data)));

      logic.getHabits();

      await mobx.asyncWhen((_) => logic.habits.state != StateType.INITIAL);

      expect(logic.habits.state, StateType.SUCESS);
      expect(logic.habits.data, data);
    });

    test('returns empty list', () async {
      final habitUseCase = HabitUseCase.getI;
      final List<Habit> data = [];

      expect(logic.habits.state, StateType.INITIAL);

      when(habitUseCase.getHabits()).thenAnswer((_) => Future.value(Result.success(data)));

      logic.getHabits();

      await mobx.asyncWhen((_) => logic.habits.state != StateType.INITIAL);

      expect(logic.habits.state, StateType.SUCESS);
      expect(logic.habits.data, data);
    });

    test('returns error', () async {
      final habitUseCase = HabitUseCase.getI;
      final dynamic error = "error";

      expect(logic.habits.state, StateType.INITIAL);

      when(habitUseCase.getHabits()).thenAnswer((_) => Future.value(Result.error(error)));

      logic.getHabits();

      await mobx.asyncWhen((_) => logic.habits.state != StateType.INITIAL);

      expect(logic.habits.state, StateType.ERROR);
      expect(logic.habits.error, error);
    });
  });

  group('fetchPendingStatus', () {
    test('returns true to pending friend status', () async {
      final personUseCase = PersonUseCase.getI;
      final competitionUseCase = CompetitionUseCase.getI;

      expect(logic.pendingFriendStatus, false);

      when(personUseCase.pendingFriendsStatus).thenReturn(true);
      when(competitionUseCase.pendingCompetitionsStatus).thenReturn(false);

      logic.fetchPendingStatus();

      expect(logic.pendingFriendStatus, true);
      expect(logic.pendingCompetitionStatus, false);
    });

    test('returns true to pending competition status', () {
      final personUseCase = PersonUseCase.getI;
      final competitionUseCase = CompetitionUseCase.getI;

      expect(logic.pendingCompetitionStatus, false);

      when(competitionUseCase.pendingCompetitionsStatus).thenReturn(true);
      when(personUseCase.pendingFriendsStatus).thenReturn(false);

      logic.fetchPendingStatus();

      expect(logic.pendingCompetitionStatus, true);
      expect(logic.pendingFriendStatus, false);
    });
  });

  group('swipeSkyWidget', () {
    test('returns true to sky visibility', () async {
      expect(logic.visibilty, false);

      logic.swipeSkyWidget(true);

      expect(logic.visibilty, true);
    });

    test('returns false to sky visibility', () async {
      logic.swipeSkyWidget(false);

      expect(logic.visibilty, false);
    });
  });

  group('completeHabit', () {
    test('returns complete habit success with 2 points', () async {
      final personUseCase = PersonUseCase.getI;
      final habitUseCase = HabitUseCase.getI;

      final List<Habit> dataHabits = [Habit()];
      final Person dataPerson = Person(score: 2);

      when(habitUseCase.completeHabit("", DateTime.now().today)).thenAnswer((_) => Future.value(Result.success(null)));
      when(habitUseCase.getHabits()).thenAnswer((_) => Future.value(Result.success(dataHabits)));
      when(personUseCase.getPerson()).thenAnswer((_) => Future.value(Result.success(dataPerson)));

      expect(await logic.completeHabit(""), 2);
    });
  });

  group('checkLevelUp', () {
    test('returns has level up', () async {
      final personUseCase = PersonUseCase.getI;

      when(personUseCase.getScore()).thenAnswer((_) async => 0);

      bool res = await logic.checkLevelUp(20);

      expect(res, true);
    });

    test('returns hasn\'t level up', () async {
      final personUseCase = PersonUseCase.getI;

      when(personUseCase.getScore()).thenAnswer((_) async => 19);

      bool res = await logic.checkLevelUp(20);

      expect(res, false);
    });
  });

  group('canAddHabit', () {
    test('returns true to add a habit', () async {
      final habitUseCase = HabitUseCase.getI;

      when(habitUseCase.maximumNumberReached()).thenAnswer((_) async => true);

      expect(await logic.canAddHabit(), true);
    });

    test('returns false to add a habit', () async {
      final habitUseCase = HabitUseCase.getI;

      when(habitUseCase.maximumNumberReached()).thenAnswer((_) async => false);

      expect(await logic.canAddHabit(), false);
    });
  });
}
