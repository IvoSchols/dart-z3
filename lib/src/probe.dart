import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

import 'object.dart';

class Probe extends Object {
  late final Z3_probe _probe;

  Probe.fromString(NativeZ3Library lookup, Z3_context context, String name)
      : super(lookup, context) {
    _probe = lookup.Z3_mk_probe(context, name.toNativeUtf8().cast());
  }

  Probe.fromZ3Probe(NativeZ3Library lookup, Z3_context context, Z3_probe probe)
      : super(lookup, context) {
    _probe = probe;
  }

  Z3_probe get probe {
    return lookup.Z3_mk_probe(context);
  }
}
