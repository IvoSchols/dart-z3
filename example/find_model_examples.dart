part of 'dart_z3_examples.dart';

///   \brief Find a model for <tt>x xor y</tt>.
void findModelExample1() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, xXorY;
  Solver s = Solver(z3.native, ast.context);

  var native = z3.native;
  var ctx = ast.context;

  x = ast.mkBoolVar("x");

  y = ast.mkBoolVar("y");

  xXorY = ast.xor(x, y);

  native.Z3_solver_assert(ctx, s.solver, xXorY);

  print("model for: x xor y\n");
  print(s.check());
  print(s.model());

  s.delSolver();
  ast.delAst();
}

//Find a model for x < y + 1, x > 2.
//Then, assert not (x=y), and find another model
void findModelExample2() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Solver s = Solver(z3.native, ast.context);

  Z3_ast x, y, one, two, yPlusOne;
  x = ast.mkIntVar("x");
  y = ast.mkIntVar("y");
  one = ast.mkInt(1);
  two = ast.mkInt(2);

  yPlusOne = ast.add([y, one]);

  var c1 = ast.lt(x, yPlusOne);
  var c2 = ast.gt(x, two);

  s.add(c1);
  s.add(c2);

  print("model for: x < y + 1, x > 2\n");
  print(s.check());
  print(s.model());

  /* assert not(x = y) */
  var xEqY = ast.eq(x, y);
  var c3 = ast.not(xEqY);
  s.add(c3);

  print("model for: x < y + 1, x > 2, not(x = y)\n");
  print(s.check());
  print(s.model());

  s.delSolver();
  ast.delAst();
}
