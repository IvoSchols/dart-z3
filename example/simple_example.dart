part of 'dart_z3_examples.dart';

void simpleExample() {
  var z3 = Z3();
  AST ast = AST(z3.native);
  ast.delAst();
}
