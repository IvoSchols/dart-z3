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

class ElementNotIntOrRealSortException implements Exception {
  @override
  String toString() =>
      "ElementNotIntOrRealSortException: One (or more) of the elements is not of type int or real sort";
}

class SortMismatchException implements Exception {
  @override
  String toString() =>
      "SortMismatchException: One (or more) of the elements is not of the same sort";
}
