part of 'dart_z3_examples.dart';

/**
   \brief Find a model for <tt>x xor y</tt>.
*/
void findModelExample1() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, x_xor_y;
  Solver s = Solver(z3.native, ast.context);

  var native = z3.native;
  var ctx = ast.context;

  x = ast.mkBoolVar("x");

  y = ast.mkBoolVar("y");

  x_xor_y = ast.xor(x, y);

  native.Z3_solver_assert(ctx, s.solver, x_xor_y);

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

  var native = z3.native;
  var ctx = ast.context;

  Z3_ast x, y, one, two, y_plus_one;
  x = ast.mkIntVar("x");
  y = ast.mkIntVar("y");
  one = ast.mkInt(1);
  two = ast.mkInt(2);

  y_plus_one = ast.add([y, one]);

  var c1 = ast.lt(x, y_plus_one);
  var c2 = ast.gt(x, two);

  s.add(c1);
  s.add(c2);

  print("model for: x < y + 1, x > 2\n");
  print(s.check());
  print(s.model());

  /* assert not(x = y) */
  var x_eq_y = ast.eq(x, y);
  var c3 = ast.not(x_eq_y);
  s.add(c3);

  print("model for: x < y + 1, x > 2, not(x = y)\n");
  print(s.check());
  print(s.model());

  s.delSolver();
  ast.delAst();
}
