import 'package:dart_z3/dart_z3.dart';

void main() {
  var z3 = Z3();

  var lookup = z3.lookup;
  var context = z3.context;

  Expr Tie = context.boolConst('Tie');
  Expr Shirt = context.boolConst('Shirt');

  Solver solver = z3.solver;

  solver.addExpr(Tie & Shirt);
  print(solver.check());

  // solver.add(ast);

  // var boolTie = z3.Z3_mk_bool_sort(context);
  // var boolShirt = z3.Z3_mk_bool_sort(context);

  // var x = z3.Z3_mk_const(context, z3.Z3_mk_const(c, s, ty), boolTie);
  // var y = z3.Z3_mk_const(context, "y", boolShirt);
}

int calculate() {
  return 6 * 7;
}
