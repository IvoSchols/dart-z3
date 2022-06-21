// Copyright (c) 2012-2014 Microsoft Corporation

// Module Name:
//     Z3Object.java
// Abstract:
// Author:
// Notes:

part of 'z3.dart';

/// internal base class for interfacing with native Z3 objects. Should not be
/// used externally.
///*/
abstract class Z3Object {
  late final Context _ctx;
  late final int _n_obj;
  late NativeZ3Library _lookup;

  Z3Object(Context ctx, NativeZ3Library lookup) {
    _ctx = ctx;
    checkNativeObject(lookup);
    NativeZ3Library _lookup = lookup;
    incRef();
    addToReferenceQueue();
  }

  /// Add to ReferenceQueue for tracking reachability on the object and
  /// decreasing the reference count when the object is no inter reachable.
  void addToReferenceQueue();

  /// Increment reference count on {@code this}.
  void incRef();

  /// This function is provided for overriding, and a child class
  /// can insert consistency checks on {@code obj}.
  ///
  /// @param obj Z3 native object.
  void checkNativeObject(lookup) {}

  int getNativeObject() {
    return _n_obj;
  }

  Context getContext() {
    return _ctx;
  }

  @ignore: non_constant_identifier_names;
  static List<int> arrayToNative(List<Z3Object?> a) {
    if (a == null) return [];
    List<Z3Object> an = [];
    for (int i = 0; i < a.length; i++) {
      if (a[i] != null) an.add(a[i]);
    }
    return an;
  }

  NativeZ3Library get lookup => _lookup;
}
