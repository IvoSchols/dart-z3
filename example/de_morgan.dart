part of 'dart_z3_examples.dart';

void deMorgan() {
  var z3 = Z3();
  AST ast = AST(z3.native);

  var context = ast.context;
  var native = z3.native;

  var x = ast.mkBoolConst(false);
  var y = ast.mkBoolConst(true);

  var notX = ast.not(x);
  var notY = ast.not(y);

  var xAndY = ast.and([notX, notY]);
  var ls = ast.not(xAndY);

  var rs = ast.or([x, y]);
  var conjecture = ast.iff(ls, rs);
  var negatedConjecture = ast.not(conjecture);
  var s = Solver(native, context);
  s.add(negatedConjecture);

  print("model for demorgan (negated conjecture, unsat if true):");

  print(s.check());
  print(s.model());

  s.reset();
  //No solver delete?
  ast.delAst();
}
