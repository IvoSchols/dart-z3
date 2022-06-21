library z3;

import 'dart:ffi';

import 'generated_bindings.dart';

import 'solver.dart';

part 'ast.dart'
part 'context.dart';
part 'int_symbol.dart';
part 'sort.dart';
part 'symbol.dart';
part 'Z3Object.dart';

class Z3 {
  late final NativeZ3Library _lookup;
  late final Z3_config _config;
  late final Context _context;

  Solver? _solver;

  Z3() {
    _lookup = NativeZ3Library(DynamicLibrary.open('libz3.so'));
    _config = _lookup.Z3_mk_config();
    //TODO: add config options
    _context = Context(_lookup, _config);
  }

  Solver get solver {
    return _solver ??= Solver(_lookup, _context);
  }

  NativeZ3Library get lookup => _lookup;

  Context get context => _context;
}
