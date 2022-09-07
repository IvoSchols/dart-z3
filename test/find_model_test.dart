import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';

import 'package:test/test.dart';

void main() {
  group('find model tests', () {
    late Z3 z3;
    late AST ast;
    late Solver s;
    setUp(() {
      z3 = Z3();
      ast = AST(z3.native);
    });

    test('x xor y expect true', (() {
      Z3_ast x, y, xXorY;
      Solver s = Solver(z3.native, ast.context);

      var native = z3.native;
      var ctx = ast.context;

      x = ast.mkBoolVar("x");

      y = ast.mkBoolVar("y");

      xXorY = ast.xor(x, y);

      native.Z3_solver_assert(ctx, s.solver, xXorY);

      expect(s.check(), "true");
      String model = s.model();

      ////Expect x->true and y->false or x->false and y->true
      expect(
          model,
          anyOf(allOf(contains("x -> true"), contains("y -> false")),
              allOf(contains("x -> false"), contains("y -> true"))));

      s.delSolver();
      ast.delAst();
    }));

    //Find a model for x < y + 1, x > 2.
    //Then, assert not (x=y), and find another model
    // SMELLY!
    test('model expect unsat', (() {
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

      ///model for: x < y + 1, x > 2"
      expect(s.check(), "true");

      ///SMELLY!
      expect(s.model(), allOf(contains("x -> 3"), contains("y -> 3")));

      /* assert not(x = y) */
      var xEqY = ast.eq(x, y);
      var c3 = ast.not(xEqY);
      s.add(c3);

      expect(s.check(), "true");

      ///SMELLY!
      expect(s.model(), allOf(contains("x -> 3"), contains("y -> 4")));

      s.delSolver();
      ast.delAst();
    }));
  });
}
