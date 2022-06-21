import 'package:ffi/ffi.dart';
import 'generated_bindings.dart';

import 'expr.dart';
import 'probe.dart';
import 'sort.dart';

class Context {
  final NativeZ3Library _lookup;
  final Z3_context _native;
  final Z3_config _config;

  Context(this._lookup, this._config)
      : _native = _lookup.Z3_mk_context_rc(_config);

  Expr constant(String name, Sort sort) {
    Z3_ast r = _lookup.Z3_mk_const(_native, stringToSymbol(name), sort.native);
    //TODO: check for error
    return Expr.fromAst(_lookup, this, r);
  }

  Expr boolConst(String name) {
    return constant(name, boolSort());
  }

  Sort boolSort() {
    Z3_sort s = _lookup.Z3_mk_bool_sort(_native);
    //TODO: check for error
    return Sort.fromNative(_lookup, this, s);
  }

  Probe or(Probe p1, Probe p2) {
    //TODO: check context match
    return Probe.fromZ3Probe(
        _lookup, native, _lookup.Z3_probe_or(native, p1.probe, p2.probe));
  }

  Probe not(Probe p) {
    // TODO: check context match
    return Probe.fromZ3Probe(
        _lookup, native, _lookup.Z3_probe_not(native, p.probe));
  }

  Z3_symbol stringToSymbol(String string) {
    return _lookup.Z3_mk_string_symbol(native, string.toNativeUtf8().cast());
  }

  get native => _native;
}
