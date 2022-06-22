part of 'z3.dart';

class EmptyListException implements Exception {
  @override
  String toString() => "EmptyListException: List cannot be empty";
}

class ElementNotBoolSortException implements Exception {
  @override
  String toString() =>
      "ElementNotBoolSortException: One (or more) of the elements is not of type bool sort";
}
