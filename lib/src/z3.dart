library z3;

import 'dart:ffi';

import 'generated_bindings.dart';

// import 'context.dart';
// import 'solver.dart';

class Z3 {
  late final NativeZ3Library _native;
  Z3_config? _config;
  Z3_context? _context;
  Z3_solver? _solver;

  Z3() {
    _native = NativeZ3Library(DynamicLibrary.open('libz3.so'));
    _config = _native.Z3_mk_config();
    //TODO: add config options
    _context = _native.Z3_mk_context(_config!);
    _native.Z3_del_config(_config!);
  }

  void cleanUpConfig() {
    if (_config == null) return;
    _native.Z3_del_config(_config!);
    _config = null;
  }

  void cleanUpContext() {
    if (_context == null) return;
    _native.Z3_del_context(context);
    _context = null;
  }

  void cleanUpSolver() {}

  NativeZ3Library get native => _native;

  Z3_context get context {
    if (_context == null) {
      _config ??= _native.Z3_mk_config();
      _native.Z3_mk_context(_config!);
      cleanUpConfig();
    }
    return _context!;
  }

  Z3_solver get solver => _solver ??= _solver = _native.Z3_mk_solver(context);
}
