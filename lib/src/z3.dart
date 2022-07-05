library z3;

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

part 'ast.dart';
part 'exceptions.dart';
part 'solver.dart';

// Holds the pointer to all generated C-libary bindings.
class Z3 {
  late final NativeZ3Library _native;

  /// Creates a new Z3 instance.
  Z3() {
    String path = _getLibraryPath();
    try {
      _native = NativeZ3Library(DynamicLibrary.open(path));
    } catch (e) {
      print('Could not load library: $path');
      rethrow;
    }
  }

  /// Returns the path to the z3 library per platform, assuming it is installed.
  String _getLibraryPath() {
    String path = 'libz3.so';

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
