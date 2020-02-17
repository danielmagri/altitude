import 'dart:async';
import 'package:altitude/core/bloc/model/LoadableData.dart';

abstract class LoadableStreamController<T> {
  LoadableStreamController._();

  factory LoadableStreamController({void onListen(), void onPause(), void onResume(), onCancel(), bool sync: false}) {
    return SingleLoadableStreamController<T>(
        onListen: onListen, onPause: onPause, onResume: onResume, onCancel: onCancel, sync: sync);
  }

  factory LoadableStreamController.broadcast({void onListen(), onCancel(), bool sync: false}) {
    return BroadcastLoadableStreamController<T>(onListen: onListen, onCancel: onCancel, sync: sync);
  }

  T get lastDataSend;

  Stream<LoadableData<T>> get stream;

  void loading([bool value]);
  void success(T data);
  void error(dynamic error);
  void close();
}

class SingleLoadableStreamController<T> extends LoadableStreamController<T> {
  SingleLoadableStreamController({void onListen(), void onPause(), void onResume(), onCancel(), bool sync: false})
      : _streamController = StreamController<LoadableData<T>>(
            onListen: onListen, onPause: onPause, onResume: onResume, onCancel: onCancel, sync: sync),
        super._();

  final StreamController<LoadableData<T>> _streamController;

  T _lastDataSend;
  T get lastDataSend => _lastDataSend;

  Stream<LoadableData<T>> get stream => _streamController.stream;

  @override
  void loading([bool value = true]) {
    _streamController.sink.add(LoadableData.loading(lastDataSend, value));
  }

  @override
  void success(T data) {
    _lastDataSend = data;
    _streamController.sink.add(LoadableData(data));
  }

  @override
  void error(dynamic error) {
    _streamController.sink.addError(error);
  }

  @override
  void close() {
    _streamController.close();
  }
}

class BroadcastLoadableStreamController<T> extends LoadableStreamController<T> {
  BroadcastLoadableStreamController({void onListen(), void onCancel(), bool sync: false})
      : _streamController =
            StreamController<LoadableData<T>>.broadcast(onListen: onListen, onCancel: onCancel, sync: sync),
        super._();

  final StreamController<LoadableData<T>> _streamController;

  T _lastDataSend;
  T get lastDataSend => _lastDataSend;

  Stream<LoadableData<T>> get stream => _streamController.stream;

  @override
  void loading([bool value = true]) {
    _streamController.sink.add(LoadableData.loading(lastDataSend, value));
  }

  @override
  void success(T data) {
    _lastDataSend = data;
    _streamController.sink.add(LoadableData(data));
  }

  @override
  void error(dynamic error) {
    _streamController.sink.addError(error);
  }

  @override
  void close() {
    _streamController.close();
  }
}
