import 'object.dart';

import 'generated_bindings.dart';

enum check_result { unsat, sat, unknown }

class Solver extends Object {
  late Z3_solver _solver;

  Solver(NativeZ3Library lookup, Z3_context context) : super(lookup, context) {
    _solver = lookup.Z3_mk_solver(context);
  }

  void add(Z3_ast ast) {
    lookup.Z3_add_const_interp(c, m, f, a)
    lookup.Z3_solver_assert(_solver, ast);
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
