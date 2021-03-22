import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';
import '../init_config.dart';

@serviceTest
@singleton
class MockSharedPref extends Mock implements SharedPref {}
