library z3;

import 'dart:ffi';

import 'generated_bindings.dart';

import 'solver.dart';

class Z3 {
  late final NativeZ3Library _lookup;
  late final Z3_config _config;
  late final Z3_context _context;

  Solver? _solver;

  Z3() {
    _lookup = NativeZ3Library(DynamicLibrary.open('libz3.so'));
    _config = _lookup.Z3_mk_config();
    //TODO: add config options
    _context = _lookup.Z3_mk_context(_config);

    var boolTie = _lookup.Z3_mk_bool_sort(context);
    var boolShirt = z3.Z3_mk_bool_sort(context);

    var x = z3.Z3_mk_const(context, z3.Z3_mk_const(c, s, ty), boolTie);
    var y = z3.Z3_mk_const(context, "y", boolShirt);

    _config = Z3_mk_config();
  }

  Solver get solver {
    return _solver ??= Solver(_lookup, _context);
  }
}
