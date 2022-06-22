library z3;

import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

// import 'context.dart';
// import 'solver.dart';

class Z3 {
  late final NativeZ3Library _native;
  late final Z3_config _config;
  late final Z3_context _context;
  Z3_solver? _solver;

  Z3() {
    _native = NativeZ3Library(DynamicLibrary.open('libz3.so'));
    _config = _native.Z3_mk_config();
    //TODO: add config options
    _context = _native.Z3_mk_context(_config);
    _native.Z3_del_config(_config);
  }

  //Deletes C pointer of config, only use at end there is no null check for the pointer
  void cleanUpConfig() {
    _native.Z3_del_config(_config);
  }

  //Deletes C pointer of context, only use at end there is no null check for the pointer
  void cleanUpContext() {
    _native.Z3_del_context(context);
  }

  void cleanUpSolver() {}

  NativeZ3Library get native => _native;

  Z3_context get context => _context;

  Z3_solver get solver => _solver ??= _solver = _native.Z3_mk_solver(context);
}
