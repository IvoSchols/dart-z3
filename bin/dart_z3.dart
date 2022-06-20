import 'package:dart_z3/dart_z3.dart';

void main() {
  var z3 = Z3();
  Solver solver = z3.solver;

  solver.add(ast);

  solver.add(ast);

  var boolTie = z3.Z3_mk_bool_sort(context);
  var boolShirt = z3.Z3_mk_bool_sort(context);

  var x = z3.Z3_mk_const(context, z3.Z3_mk_const(c, s, ty), boolTie);
  var y = z3.Z3_mk_const(context, "y", boolShirt);
}

int calculate() {
  return 6 * 7;
}
