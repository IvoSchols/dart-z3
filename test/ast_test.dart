import 'dart:ffi';

import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';
import 'package:test/test.dart';

void main() {
  group('dogs cats mouses', () {
    Z3 z3;
    late AST ast;
    late Solver s;

    setUp(() {
      z3 = Z3();
      ast = AST(z3.native);
      s = Solver(z3.native, ast.context);
    });

    tearDown(() {
      ast.dispose();
    });

    test('expect and throws empty', (() {
      expect(() => ast.and([]), throwsA(isA<Exception>()));
    }));

    test('expect and throws not same sort', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.and([x, y]), throwsA(isA<Exception>()));
    });

    test('expect and returns ast node', () {
      var trueConst = ast.mkBoolConst(true);
      var x = ast.mkBoolVar('x');
      var and = ast.and([trueConst, x]);
      expect(and, isA<Z3_ast>());
    });

    test('epect eq throws not same sort', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.eq(x, y), throwsA(isA<Exception>()));
    });

    test('expect eq returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var eq = ast.eq(x, y);
      expect(eq, isA<Z3_ast>());
    });

    test('expect neq throws not same sort', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.neq(x, y), throwsA(isA<Exception>()));
    });

    test('expect neq returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var neq = ast.neq(x, y);
      expect(neq, isA<Z3_ast>());
    });

    test('expect iff throws not bool sort', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      expect(() => ast.iff(x, y), throwsA(isA<Exception>()));
    });

    test('expect iff returns ast node', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      var iff = ast.iff(x, y);
      expect(iff, isA<Z3_ast>());
    });

    test('expect or throws empty', () {
      expect(() => ast.or([]), throwsA(isA<Exception>()));
    });

    test('expect or throws not bool sort', () {
      var x = ast.mkStringVar('x');
      var y = ast.mkStringVar('y');
      expect(() => ast.or([x, y]), throwsA(isA<Exception>()));
    });

    test('expect or returns ast node', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      var or = ast.or([x, y]);
      expect(or, isA<Z3_ast>());
    });

    test('expect xor throws not bool sort', () {
      var x = ast.mkStringVar('x');
      var y = ast.mkStringVar('y');
      expect(() => ast.xor(x, y), throwsA(isA<Exception>()));
    });

    test('expect xor returns ast node', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      var xor = ast.xor(x, y);
      expect(xor, isA<Z3_ast>());
    });

    test('expect add throws empty', () {
      expect(() => ast.add([]), throwsA(isA<Exception>()));
    });

    test('expect add throws not int sort', () {
      var x = ast.mkStringVar('x');
      var y = ast.mkStringVar('y');
      expect(() => ast.add([x, y]), throwsA(isA<Exception>()));
    });

    test('expect add returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var add = ast.add([x, y]);
      expect(add, isA<Z3_ast>());
    });

    test('expect gt throws not int sort', () {
      var x = ast.mkStringVar('x');
      var y = ast.mkStringVar('y');
      expect(() => ast.gt(x, y), throwsA(isA<Exception>()));
    });

    test('expect gt returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var gt = ast.gt(x, y);
      expect(gt, isA<Z3_ast>());
    });

    test('expect lt throws not int sort', () {
      var x = ast.mkStringVar('x');
      var y = ast.mkStringVar('y');
      expect(() => ast.lt(x, y), throwsA(isA<Exception>()));
    });

    test('expect lt returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var lt = ast.lt(x, y);
      expect(lt, isA<Z3_ast>());
    });

    test('expect ge throws not int sort', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.ge(x, y), throwsA(isA<Exception>()));
    });

    test('expect ge returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var ge = ast.ge(x, y);
      expect(ge, isA<Z3_ast>());
    });

    test('expect le throws not int sort', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.le(x, y), throwsA(isA<Exception>()));
    });

    test('expect le returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var le = ast.le(x, y);
      expect(le, isA<Z3_ast>());
    });

    test('expect mul throws empty', () {
      expect(() => ast.mul([]), throwsA(isA<Exception>()));
    });

    test('expect mul throws not int sort', () {
      var x = ast.mkBoolVar('x');
      var y = ast.mkBoolVar('y');
      expect(() => ast.mul([x, y]), throwsA(isA<Exception>()));
    });

    test('expect mul returns ast node', () {
      var x = ast.mkIntVar('x');
      var y = ast.mkIntVar('y');
      var mul = ast.mul([x, y]);
      expect(mul, isA<Z3_ast>());
    });

    test('expect mkStringConst returns ast node', () {
      var str = ast.mkStringConst('str');
      expect(str, isA<Z3_ast>());
    });

    test('expect mkStringVar returns ast node', () {
      var str = ast.mkStringVar('str');
      expect(str, isA<Z3_ast>());
    });

    test('expect mkBoolConst true returns ast node', () {
      var bool = ast.mkBoolConst(true);
      expect(bool, isA<Z3_ast>());
    });

    test('expect mkBoolConst false returns ast node', () {
      var bool = ast.mkBoolConst(false);
      expect(bool, isA<Z3_ast>());
    });

    test('expect mkBoolVar returns ast node', () {
      var bool = ast.mkBoolVar('bool');
      expect(bool, isA<Z3_ast>());
    });

    test('expect mkInt returns ast node', () {
      var int = ast.mkInt(1);
      expect(int, isA<Z3_ast>());
    });

    test('expect mkIntVar returns ast node', () {
      var int = ast.mkIntVar('int');
      expect(int, isA<Z3_ast>());
    });
  });
}
