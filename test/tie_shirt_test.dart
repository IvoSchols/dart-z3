import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';
import 'package:test/test.dart';

void main() {
  group('tie shirt', () {
    Z3 z3;
    AST ast;
    late Solver s;

    setUp(() {
      z3 = Z3();
      ast = AST(z3.native);
      Z3_ast x, y, xOrY, nxOrY, nxOrNy;
      s = Solver(z3.native, ast.context);

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
    });

    test('check expect sat', (() {
      expect(s.check(), equals("true"));
    }));

    test('model expect', (() {
      expect(s.model(), allOf(contains("y -> true"), contains("x -> false")));
    }));
  });
}
