import 'dart:ffi';
import 'package:dart_z3/dart_z3.dart';
import 'package:dart_z3/src/generated_bindings.dart';
import 'package:ffi/ffi.dart';

void main() {
  simpleExample();

  deMorgan();

  findModelExample1();

  tieShirt();
}

void simpleExample() {
  var z3 = Z3();
  AST ast = AST(z3.native);
  ast.cleanUpContext();
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

  var solver = native.Z3_mk_solver(context);
  native.Z3_solver_assert(context, solver, negated_conjecture);

  switch (native.Z3_solver_check(context, solver)) {
    case Z3_lbool.Z3_L_FALSE:
      /* The negated conjecture was unsatisfiable, hence the conjecture is valid */
      print("demorgen is valid");
      break;
    case Z3_lbool.Z3_L_UNDEF:
      /* Check returned undef */
      print("undef");
      break;
    case Z3_lbool.Z3_L_TRUE:
      /* The negated conjecture was satisfiable, hence the conjecture is not valid */
      print("true");
      break;
  }

  native.Z3_solver_reset(context, solver);
  //No solver delete?
  ast.cleanUpContext();
}

/**
   \brief Find a model for <tt>x xor y</tt>.
*/
void findModelExample1() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, x_xor_y;
  Z3_solver s;

  var native = z3.native;
  var ctx = ast.context;
  s = native.Z3_mk_solver(ctx);

  x = ast.mkBoolVar("x");

  y = ast.mkBoolVar("y");

  x_xor_y = ast.xor(x, y);

  native.Z3_solver_assert(ctx, s, x_xor_y);

  print("model for: x xor y\n");
  check(native, ctx, s, Z3_lbool.Z3_L_TRUE);

  delSolver(native, ctx, s);
  native.Z3_del_context(ctx);
}

/**
   \brief Check whether the logical context is satisfiable, and compare the result with the expected result.
   If the context is satisfiable, then display the model.
*/
void check(
    NativeZ3Library native, Z3_context ctx, Z3_solver s, int expected_result) {
  Z3_model m = Pointer.fromAddress(0);
  int result = native.Z3_solver_check(ctx, s);
  switch (result) {
    case Z3_lbool.Z3_L_FALSE:
      print("unsat\n");
      break;
    case Z3_lbool.Z3_L_UNDEF:
      print("unknown\n");
      m = native.Z3_solver_get_model(ctx, s);
      if (m != Pointer.fromAddress(0)) native.Z3_model_inc_ref(ctx, m);
      print("potential model:\n%s\n${native.Z3_model_to_string(ctx, m)}");
      break;
    case Z3_lbool.Z3_L_TRUE:
      m = native.Z3_solver_get_model(ctx, s);
      if (m != Pointer.fromAddress(0)) native.Z3_model_inc_ref(ctx, m);
      Pointer<Char> charPointer = native.Z3_model_to_string(ctx, m);
      Pointer<Utf8> utfPointer = charPointer.cast();
      print("sat\n%s\n" + utfPointer.toDartString());
      break;
  }
  if (result != expected_result) {
    throw Exception("unexpected result");
  }
  if (m != Pointer.fromAddress(0)) native.Z3_model_dec_ref(ctx, m);
}

void delSolver(NativeZ3Library native, Z3_context ctx, Z3_solver s) {
  native.Z3_solver_dec_ref(ctx, s);
}

void tieShirt() {
  var z3 = Z3();
  var ast = AST(z3.native);
  Z3_ast x, y, x_or_y, nx_or_y, nx_or_ny;
  Z3_solver s;

  var native = z3.native;
  var ctx = ast.context;
  s = native.Z3_mk_solver(ctx);

  Z3_sort tx = native.Z3_mk_bool_sort(ctx);
  Z3_symbol ttx = native.Z3_mk_string_symbol(ctx, "x".toNativeUtf8().cast());
  x = native.Z3_mk_const(ctx, ttx, tx);

  Z3_sort ty = native.Z3_mk_bool_sort(ctx);
  Z3_symbol tty = native.Z3_mk_string_symbol(ctx, "y".toNativeUtf8().cast());
  y = native.Z3_mk_const(ctx, tty, ty);

  var args = <Z3_ast>[];
  args.add(x);
  args.add(y);
  x_or_y = native.Z3_mk_or(ctx, 2, astListToArray(args));

  var not_x = native.Z3_mk_not(ctx, x);

  args[0] = not_x;

  nx_or_y = native.Z3_mk_or(ctx, 2, astListToArray(args));

  var not_y = native.Z3_mk_not(ctx, y);

  args[1] = not_y;

  nx_or_ny = native.Z3_mk_or(ctx, 2, astListToArray(args));

  native.Z3_solver_assert(ctx, s, x_or_y);
  native.Z3_solver_assert(ctx, s, nx_or_y);
  native.Z3_solver_assert(ctx, s, nx_or_ny);

  print("model for: x or y, not x or y, not x or not y\n");
  check(native, ctx, s, Z3_lbool.Z3_L_TRUE);

  delSolver(native, ctx, s);
  native.Z3_del_context(ctx);
}

Pointer<Z3_ast> astListToArray(List<Z3_ast> list) {
  final ptr = calloc.allocate<Z3_ast>(sizeOf<Pointer>() * list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}
