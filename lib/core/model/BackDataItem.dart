import 'package:altitude/core/enums/BackDataItemType.dart';

class BackDataItem<T> {
  final BackDataItemType state;
  final T data;

  BackDataItem.added(this.data) : state = BackDataItemType.ADD;
  BackDataItem.update(this.data) : state = BackDataItemType.UPDATE;
  BackDataItem.removed(this.data) : state = BackDataItemType.REMOVE;
}
