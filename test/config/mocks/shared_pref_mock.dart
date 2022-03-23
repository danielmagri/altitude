import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';
import '../init_config.dart';

@serviceTest
@singleton
class MockSharedPref extends Mock implements SharedPref {}
