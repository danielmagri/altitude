import 'package:flutter/foundation.dart' show kDebugMode;

abstract class Failure implements Exception {
  Failure._();

  factory Failure.dataFailure(String value) = DataFailure;
  factory Failure.authFailure(dynamic error) = GenericFailure;
  factory Failure.genericFailure(dynamic error) = GenericFailure;
  factory Failure.noConnection(dynamic error) = NoConnectionFailure;

  String get message;
}

class DataFailure extends Failure {
  DataFailure(this.value) : super._();

  final String value;

  @override
  String get message => value;
}

class GenericFailure extends Failure {
  GenericFailure(this.value) : super._();

  final dynamic value;

  @override
  String get message => kDebugMode ? value.toString() : 'Generic Error message';
}

class NoConnectionFailure extends Failure {
  NoConnectionFailure(this.value) : super._();

  final dynamic value;

  @override
  String get message => 'No connection';
}
