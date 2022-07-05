part of 'dart_z3_examples.dart';

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
