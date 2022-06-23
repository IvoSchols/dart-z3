library z3;

import 'dart:ffi';
import 'package:dart_z3/dart_z3.dart';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

// import 'context.dart';
// import 'solver.dart';
part 'ast.dart';
part 'exceptions.dart';
part 'solver.dart';

class Z3 {
  late final NativeZ3Library _native;

  Z3() {
    _native = NativeZ3Library(DynamicLibrary.open('libz3.so'));
  }

  NativeZ3Library get native => _native;

  // Z3_solver get solver => _solver ??= _solver = _native.Z3_mk_solver(context);
}
