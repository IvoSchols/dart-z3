part of 'dart_z3_examples.dart';

void tieShirt() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, xOrY, nxOrY, nxOrNy;
  Solver s = Solver(z3.native, ast.context);

  // var native = z3.native;
  // var ctx = ast.context;

  x = ast.mkBoolVar("x");

  y = ast.mkBoolVar("y");

  xOrY = ast.or([x, y]);

  var notX = ast.not(x);

  nxOrY = ast.or([notX, y]);

  var notY = ast.not(y);

  nxOrNy = ast.or([notX, notY]);

  s.add(xOrY);
  s.add(nxOrY);
  s.add(nxOrNy);

  print("model for: x or y, not x or y, not x or not y\n");
  print(s.check());
  print(s.model());

  s.delSolver();
  ast.delAst();
}
