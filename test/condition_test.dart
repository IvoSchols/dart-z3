import 'package:test/test.dart';
import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';

/// SMELLY TESTS, ADD EXCEPTIONS UPON FAILURE
/// PLEASE NOTE THE IMPORTANCE OF s.reset()
void main() {
  group('condition', () {
    Z3 z3 = Z3();
    late AST ast = AST(z3.native);
    late Solver s = Solver(z3.native, ast.context);

    // setUp(() {
    //   z3 = Z3();
    //   ast = AST(z3.native);
    //   s = Solver(z3.native, ast.context);
    // });
    test('equalsZero', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.eq(val, zero);
      s.add(equals);
      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> 0"));
      s.reset();
    });

    test('greaterEqualsThree', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.neq(val, zero);
      s.add(equals);

      Z3_ast three = ast.mkInt(3);
      Z3_ast greaterEqual = ast.ge(val, three);
      s.add(greaterEqual);

      s.add(ast.and([equals, greaterEqual]));

      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> 3"));

      s.reset();
    });

    test('lessEqualMinusTwelve', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.neq(val, zero);
      s.add(equals);

      Z3_ast three = ast.mkInt(3);
      Z3_ast lessThenThree = ast.lt(val, three);
      s.add(lessThenThree);

      Z3_ast and1 = ast.and([equals, lessThenThree]);
      s.add(and1);

      Z3_ast minusTwelve = ast.mkInt(-12);
      Z3_ast lessEqual = ast.le(val, minusTwelve);
      s.add(lessEqual);

      s.add(ast.and([and1, lessEqual]));

      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> (- 12)"));

      s.reset();
    });

    test('greaterThanMinusEight', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.neq(val, zero);
      s.add(equals);

      Z3_ast three = ast.mkInt(3);
      Z3_ast lessThenThree = ast.lt(val, three);
      s.add(lessThenThree);

      Z3_ast and1 = ast.and([equals, lessThenThree]);
      s.add(and1);

      Z3_ast minusTwelve = ast.mkInt(-12);
      Z3_ast greaterThen = ast.gt(val, minusTwelve);
      s.add(greaterThen);

      Z3_ast and2 = ast.and([and1, greaterThen]);
      s.add(ast.and([and1, and2]));

      Z3_ast minusEight = ast.mkInt(-8);
      Z3_ast greaterThenMinusEight = ast.gt(val, minusEight);

      s.add(greaterThenMinusEight);

      Z3_ast and3 = ast.and([and2, greaterThenMinusEight]);
      s.add(and3);

      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> (- 4)"));

      s.reset();
    });

    test('lessThenMinusEight', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.neq(val, zero);
      s.add(equals);

      Z3_ast three = ast.mkInt(3);
      Z3_ast lessThenThree = ast.lt(val, three);
      s.add(lessThenThree);

      Z3_ast and1 = ast.and([equals, lessThenThree]);
      s.add(and1);

      Z3_ast minusTwelve = ast.mkInt(-12);
      Z3_ast greaterThen = ast.gt(val, minusTwelve);
      s.add(greaterThen);

      Z3_ast and2 = ast.and([and1, greaterThen]);
      s.add(ast.and([and1, and2]));

      Z3_ast minusEight = ast.mkInt(-8);
      Z3_ast lessEqualMinusEight = ast.le(val, minusEight);

      s.add(lessEqualMinusEight);

      Z3_ast and3 = ast.and([and2, lessEqualMinusEight]);
      s.add(ast.and([and2, and3]));

      Z3_ast lessThenMinusEight = ast.lt(val, ast.mkInt(-8));
      s.add(lessThenMinusEight);

      Z3_ast and4 = ast.and([and3, lessThenMinusEight]);
      s.add(and4);

      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> (- 11)"));

      s.reset();
    });

    test('equalsMinusEight', () {
      Z3_ast val = ast.mkIntVar('x');
      Z3_ast zero = ast.mkInt(0);
      Z3_ast equals = ast.neq(val, zero);
      s.add(equals);

      Z3_ast three = ast.mkInt(3);
      Z3_ast lessThenThree = ast.lt(val, three);
      s.add(lessThenThree);

      Z3_ast and1 = ast.and([equals, lessThenThree]);
      s.add(and1);

      Z3_ast minusTwelve = ast.mkInt(-12);
      Z3_ast greaterThen = ast.gt(val, minusTwelve);
      s.add(greaterThen);

      Z3_ast and2 = ast.and([and1, greaterThen]);
      s.add(ast.and([and1, and2]));

      Z3_ast minusEight = ast.mkInt(-8);
      Z3_ast lessEqualMinusEight = ast.le(val, minusEight);

      s.add(lessEqualMinusEight);

      Z3_ast and3 = ast.and([and2, lessEqualMinusEight]);
      s.add(ast.and([and2, and3]));

      Z3_ast geMinusEight = ast.ge(val, ast.mkInt(-8));
      s.add(geMinusEight);

      Z3_ast and4 = ast.and([and3, geMinusEight]);
      s.add(and4);

      expect(s.check(), contains("true"));
      expect(s.model(), contains("x -> (- 8)"));

      s.reset();
    });
  });
}
