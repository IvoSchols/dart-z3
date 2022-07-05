part of 'dart_z3_examples.dart';

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
