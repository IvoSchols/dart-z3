import 'generated_bindings.dart';

import 'context.dart';
import 'expr.dart';
import 'object.dart';

// ignore: camel_case_types
enum check_result { unsat, sat, unknown }

class Solver extends Object {
  late Z3_solver _solver;

  Solver(NativeZ3Library lookup, Context context) : super(lookup, context) {
    _solver = lookup.Z3_mk_solver(context.native);
  }

  void addExpr(Expr e) {
    assert(e.is_bool());
    lookup.Z3_solver_assert(context, _solver, e);
    check_error(context);
  }

  void addExprVector(List<Expr> ev) {
    //TODO: check context
    for (var e in ev) {
      addExpr(e);
    }
  }

  check_result check() {
    //TODO: add proper enum for return value
    int result = lookup.Z3_solver_check(context, _solver);
    if (result == 0) {
      return check_result.unsat;
    } else if (result == 1) {
      return check_result.sat;
    } else if (result == 2) {
      return check_result.unknown;
    }
    throw Exception("Unknown check result");
  }
}
