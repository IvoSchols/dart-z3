import 'dart:ffi';
import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';
import 'package:ffi/ffi.dart';

void main() {
  simpleExample();

  deMorgan();

  findModelExample1();

  tieShirt();
}

void simpleExample() {
  var z3 = Z3();
  AST ast = AST(z3.native);
  ast.cleanUpContext();
}

void deMorgan() {
  var z3 = Z3();
  AST ast = AST(z3.native);

  var context = ast.context;
  var native = z3.native;

  var x = ast.mkBoolConst(false);
  var y = ast.mkBoolConst(true);

  var not_x = ast.not(x);
  var not_y = ast.not(y);

  var x_and_y = ast.and([not_x, not_y]);
  var ls = ast.not(x_and_y);

  var rs = ast.or([x, y]);
  var conjecture = ast.iff(ls, rs);

  var s = Solver(native, context);
  s.add(conjecture);

  print("model for demrogan");
  print(s.check());
  print(s.model());

  s.reset();
  //No solver delete?
  ast.cleanUpContext();
}

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
  native.Z3_del_context(ctx);
}

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
  native.Z3_del_context(ctx);
}
