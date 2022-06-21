// Copyright (c) 2012-2014 Microsoft Corporation
   
// Module Name:
//     Z3Object.java
// Abstract:
// Author:
// Notes:
    

import 'package:dart_z3/src/context.dart';

/// internal base class for interfacing with native Z3 objects. Should not be
/// used externally.
///*/
abstract class Z3Object {

    late final Context _m_ctx;
    late var _m_n_obj;

    Z3Object(Context ctx, int obj) {
        _m_ctx = ctx;
        checkNativeObject(obj);
        _m_n_obj = obj;
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
    void checkNativeObject(int obj) {}

    int getNativeObject()
    {
        return _m_n_obj;
    }

    static int _getNativeObject(Z3Object s)
    {
        if (s == null)
            return 0;
        return s.getNativeObject();
    }

    Context getContext()
    {
        return _m_ctx;
    }

    // ignore: non_constant_identifier_names
    static int[] arrayToNative(Z3Object[] a) {
        if (a == null)
            return null;
        int[] an = new int[a.length];
        for (int i = 0; i < a.length; i++)
            an[i] = (a[i] == null) ? 0 : a[i].getNativeObject();
        return an;
    }
}