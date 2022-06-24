library z3;

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

part 'ast.dart';
part 'exceptions.dart';
part 'solver.dart';

class Z3 {
  late final NativeZ3Library _native;

  Z3() {
    String path = _getLibraryPath();
    try {
      _native = NativeZ3Library(DynamicLibrary.open(path));
    } catch (e) {
      print('Could not load library: $path');
      rethrow;
    }
  }

  String _getLibraryPath() {
    String path = 'libz3.so';
    print(Platform.isLinux);
    if (Platform.isLinux) {
      path = 'libz3.so';
    } else if (Platform.isMacOS) {
      path = 'libz3.dylib';
    } else if (Platform.isWindows) {
      path = 'libz3.dll';
    }
    return path;
  }

  NativeZ3Library get native => _native;
}
