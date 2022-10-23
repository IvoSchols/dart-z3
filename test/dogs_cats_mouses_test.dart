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

      var costDog = ast.mul([ast.mkInt(1500), dog]);
      var costCat = ast.mul([ast.mkInt(100), cat]);
      var costMouse = ast.mul([ast.mkInt(25), mouse]);

      var costDogCatMouse = ast.add([costDog, costCat, costMouse]);
      var tenThousand = ast.mkInt(10000);
      var c5 = ast.eq(costDogCatMouse, tenThousand);
      s.add(c5);
    });

    tearDown(() {
      ast.dispose();
    });

    test('check expect sat', (() {
      expect(s.check(), equals("true"));
    }));

    //MIGHT BE SMELLY! (have not checked)
    test('model expect', (() {
      expect(
          s.model(),
          allOf(contains("mouse -> 56"), contains("cat -> 41"),
              contains("dog -> 3")));
    }));
  });
}
