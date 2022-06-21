// // TODO Implement this library./**
// Copyright (c) 2012-2014 Microsoft Corporation

// Module Name:

//     IntSymbol.java

// Abstract:

// Author:

//     @author Christoph Wintersteiger (cwinter) 2012-03-15

// Notes:

// **/

part of 'z3.dart';

/**
 * Numbered symbols
 **/
class IntSymbol extends Symbol {
  /**
     * The int value of the symbol.
     * Remarks: Throws an exception if the symbol
     * is not of int kind. 
     **/
  int getInt() {
    if (!isIntSymbol()) throw Exception("Int requested from non-Int symbol");
    return _lookup.getSymbolInt(getContext().nCtx(), getNativeObject());
  }

  IntSymbol(Context ctx, int obj) : super(ctx, obj);

  IntSymbol(Context ctx, int i) {
    super(ctx, Native.mkIntSymbol(ctx.nCtx(), i));
  }

  @override
  void checkNativeObject(int obj) {
    if (Native.getSymbolKind(getContext().nCtx(), obj) !=
        Z3_symbol_kind.Z3_INT_SYMBOL.toInt())
      throw Exception("Symbol is not of integer kind");
    super.checkNativeObject(obj);
  }
}
