part of 'dart_z3_examples.dart';

void tieShirt() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, x_or_y, nx_or_y, nx_or_ny;
  Solver s = Solver(z3.native, ast.context);

  var native = z3.native;
  var ctx = ast.context;

  x = ast.mkBoolVar("x");

  y = ast.mkBoolVar("y");

  x_or_y = ast.or([x, y]);

  var not_x = ast.not(x);

  nx_or_y = ast.or([not_x, y]);

  var not_y = ast.not(y);

  nx_or_ny = ast.or([not_x, not_y]);

  s.add(x_or_y);
  s.add(nx_or_y);
  s.add(nx_or_ny);

  print("model for: x or y, not x or y, not x or not y\n");
  print(s.check());
  print(s.model());

  s.delSolver();
  ast.delAst();
}
