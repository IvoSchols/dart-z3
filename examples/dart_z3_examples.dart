library dart_z3_examples;

import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';

part 'simple_example.dart';
part 'de_morgan.dart';
part 'find_model_examples.dart';
part 'tie_shirt.dart';
part 'dogs_cats_mouses.dart';

void main() {
  simpleExample();

  deMorgan();

  findModelExample1();
  findModelExample2();

  tieShirt();

  dogsCatsMouses();
}
