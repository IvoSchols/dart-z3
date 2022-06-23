import 'dart:ffi';
import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';
import 'package:ffi/ffi.dart';

void main() {
  simpleExample();

  deMorgan();

  findModelExample1();

  tieShirt();

  findModelExample2();

  dogsCatsMouses();
}

void simpleExample() {
  var z3 = Z3();
  AST ast = AST(z3.native);
  ast.delAst();
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
  var negated_conjecture = ast.not(conjecture);
  var s = Solver(native, context);
  s.add(negated_conjecture);

  print("model for demorgan (negated conjecture, unsat if true):");

  print(s.check());
  print(s.model());

  s.reset();
  //No solver delete?
  ast.delAst();
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
  ast.delAst();
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

//https://ericpony.github.io/z3py-tutorial/guide-examples.htm
//Consider the following puzzle. Spend exactly 100 dollars and buy exactly 100 animals. Dogs cost 15 dollars, cats cost 1 dollar, and mice cost 25 cents each. You have to buy at least one of each. How many of each should you buy?
void dogsCatsMouses() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Solver s = Solver(z3.native, ast.context);
  Z3_ast dog, cat, mouse, zero, hundred;
  dog = ast.mkIntVar('dog');
  cat = ast.mkIntVar('cat');
  mouse = ast.mkIntVar('mouse');
  zero = ast.mkInt(0);
  var c1 = ast.gt(dog, zero);
  var c2 = ast.gt(cat, zero);
  var c3 = ast.gt(mouse, zero);
  s.add(c1);
  s.add(c2);
  s.add(c3);

  hundred = ast.mkInt(100);
  var plus = ast.add([dog, cat, mouse]);
  var c4 = ast.eq(plus, hundred);
  s.add(c4);

  var cost_dog = ast.mul([ast.mkInt(1500), dog]);
  var cost_cat = ast.mul([ast.mkInt(100), cat]);
  var cost_mouse = ast.mul([ast.mkInt(25), mouse]);

  var cost_dog_cat_mouse = ast.add([cost_dog, cost_cat, cost_mouse]);
  var ten_thousand = ast.mkInt(10000);
  var c5 = ast.eq(cost_dog_cat_mouse, ten_thousand);
  s.add(c5);

  print("model for: dogs, cats, and mice\n");
  print(s.check());
  print(s.model());
}
