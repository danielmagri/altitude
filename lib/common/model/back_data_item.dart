import 'package:altitude/common/enums/back_data_item_type.dart';

class BackDataItem<T> {
  BackDataItem.added(this.data) : state = BackDataItemType.add;
  BackDataItem.update(this.data) : state = BackDataItemType.update;
  BackDataItem.removed(this.data) : state = BackDataItemType.remove;

  final BackDataItemType state;
  final T data;
}
