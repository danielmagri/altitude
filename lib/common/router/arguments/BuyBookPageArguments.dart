import 'package:altitude/common/constant/Books.dart';
import 'package:altitude/common/model/Book.dart';

class BuyBookPageArguments {
  BuyBookPageArguments(this.index);

  final int index;

  Book get book => BOOKS[index];
}
