import 'package:dart_z3/dart_z3.dart';
import 'package:test/test.dart';

void main() {
  group('deMorgan', () {
    Z3 z3;
    AST ast;
    late Solver s;
    setUp(() {
      z3 = Z3();
      ast = AST(z3.native);

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
      s = Solver(native, context);
      s.add(negatedConjecture);
    });

    test('check expect unsat', (() {
      expect(s.check(), equals("false"),
          reason: "deMorgan (negated conjecture unsat if true)");
    }));

    test('model expect unsat', (() {
      expect(s.model(), "false");
    }));
  });
}
