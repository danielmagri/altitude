

import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../init_config.dart';

@usecaseTest
@Singleton(as: CompetitionUseCase)
class MockCompetitionUseCase extends Mock implements CompetitionUseCase {}

@usecaseTest
@Singleton(as: HabitUseCase)
class MockHabitUseCase extends Mock implements HabitUseCase {}

@usecaseTest
@Singleton(as: PersonUseCase)
class MockPersonUseCase extends Mock implements PersonUseCase {}