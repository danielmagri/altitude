import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../config/init_config.dart';

void main() {
  setUp(() {
    initConfig();
  });

  group('createPerson', () {
    //TODO
  //   test('returns a Result.success', () async {
  //     expect(await PersonUseCase.getInstance.createPerson(), isA<RSuccess>());
  //   });
  });

  group('getPerson', () {
    test('returns a Person with Result.success from FireDatabase', () async {
      final fireDatabase = GetIt.I.get<IFireDatabase>();
      final fireAuth = GetIt.I.get<IFireAuth>();
      var data = Person();

      when(fireAuth.getPhotoUrl()).thenReturn("url");
      when(fireDatabase.getPerson()).thenAnswer((_) async => data);

      expect(await PersonUseCase.getI.getPerson(fromServer: true), isA<RSuccess<Person>>());
      expect(data.photoUrl, "url");
      expect(Memory.getI.person, data);
    });

    test('returns a Person with Result.success from memory', () async {
      final memory = Memory.getI;
      var data = Person();

      memory.person = data;

      expect(await PersonUseCase.getI.getPerson(fromServer: false), isA<RSuccess<Person>>());
    });

    test('returns a Person with Result.error from FireDatabase', () async {
      final fireDatabase = GetIt.I.get<IFireDatabase>();

      when(fireDatabase.getPerson()).thenThrow(throwsException);

      expect(await PersonUseCase.getI.getPerson(fromServer: true), isA<RError<Person>>());
    });
  });

  group('getScore', () {
    //TODO
  });

  group('updateLevel', () {
    //TODO
  });

  group('updateName', () {
    //TODO
  });

  group('updateFcmToken', () {
    //TODO
  });

  group('getFriends', () {
    //TODO
  });

  group('getPendingFriends', () {
    //TODO
  });

  group('searchEmail', () {
    //TODO
  });

  group('friendRequest', () {
    //TODO
  });

  group('acceptRequest', () {
    //TODO
  });

  group('declineRequest', () {
    //TODO
  });

  group('cancelFriendRequest', () {
    //TODO
  });

  group('removeFriend', () {
    //TODO
  });

  group('rankingFriends', () {
    //TODO
  });

  group('logout', () {
    //TODO
  });
}
