import 'package:altitude/common/constant/Books.dart';
import 'package:altitude/common/model/Book.dart';

class LearnDetailPageArguments {
  LearnDetailPageArguments(this.index);

  final int index;

  Book get book => books[index];
}
