part of 'z3.dart';

/// A Z3 solver that operates within context.
class Solver {
  final NativeZ3Library _native;
  final Z3_context _context;
  late final Z3_solver _solver;

  Solver(this._native, this._context) {
    _solver = _native.Z3_mk_solver(_context);
    _native.Z3_solver_inc_ref(_context, _solver);
  }

  //Assert constraints into the solver.
  void add(Z3_ast ast) {
    _native.Z3_solver_assert(_context, _solver, ast);
  }

  //Check whether the assertions in the given solver plus the optional assumptions are consistent or not.
  String check() {
    int result = _native.Z3_solver_check(_context, _solver);

    //TODO: is it neccesary to call model inc ref?

    switch (result) {
      case Z3_lbool.Z3_L_FALSE:
        return "false";
      case Z3_lbool.Z3_L_UNDEF:
        return "undef";
      case Z3_lbool.Z3_L_TRUE:
        return "true";
    }
    throw Exception("unexpected result");
  }

  //Return the model (recalculates check)
  String model() {
    Z3_model m = Pointer.fromAddress(0);
    String result = "";

    String checkResult = check();

    if (checkResult == "false") {
      return "false";
    } else if (checkResult == "undef" || checkResult == "true") {
      m = _native.Z3_solver_get_model(_context, _solver);
      if (m != Pointer.fromAddress(0)) _native.Z3_model_inc_ref(_context, m);
      if (checkResult == "undef") result += "potential model:\n";
      // if (checkResult == "true") result += "sat\n";
      Pointer<Char> charPointer = _native.Z3_model_to_string(_context, m);
      Pointer<Utf8> utfPointer = charPointer.cast();
      result += utfPointer.toDartString();
    }
    if (m != Pointer.fromAddress(0)) _native.Z3_model_dec_ref(_context, m);

    return result;
  }

  // Remove all the assertions from the solver.
  void reset() {
    _native.Z3_solver_reset(_context, _solver);
  }

  Z3_solver get solver => _solver;
}
