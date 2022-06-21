// /**
// Copyright (c) 2012-2014 Microsoft Corporation
   
// Module Name:

//     Symbol.java

// Abstract:

// Author:

//     @author Christoph Wintersteiger (cwinter) 2012-03-15

// Notes:
    
// **/ 


part of 'z3.dart';

/**
 * Symbols are used to name several term and type constructors.
 **/
class Symbol extends Z3Object {
    /**
     * The kind of the symbol (int or string)
     **/
    Z3_symbol_kind getKind()
    {
        return Z3_symbol_kind.fromInt(Native.getSymbolKind(getContext().nCtx(),
                getNativeObject()));
    }

    /**
     * Indicates whether the symbol is of Int kind
     **/
    bool isIntSymbol()
    {
        return getKind() == Z3_symbol_kind.Z3_INT_SYMBOL;
    }

    /**
     * Indicates whether the symbol is of string kind.
     **/
    bool isStringSymbol()
    {
        return getKind() == Z3_symbol_kind.Z3_STRING_SYMBOL;
    }

    @override
    bool equals(Object o)
    {
        if (o == this) return true;
        if (!(o is Symbol)) return false;
        Symbol other = o;
        return this.getNativeObject() == other.getNativeObject();
    }

    /**
     * A string representation of the symbol.
     **/
    @override
    String toString() {
        if (isIntSymbol()) {
            return Integer.toString(((IntSymbol) this).getInt());
        } else if (isStringSymbol()) {
            return ((StringSymbol) this).getString();
        } else {
            return "Z3Exception: Unknown symbol kind encountered.";
        }
    }

    /**
     * Symbol constructor
     **/
    Symbol(Context ctx, int obj) : super(ctx, obj);

    @override
    void incRef() {
        // Symbol does not require tracking.
    }

    @override
    void addToReferenceQueue() {

        // Symbol does not require tracking.
    }

    static Symbol create(Context ctx, int obj)
    {
        switch (Z3_symbol_kind.fromInt(Native.getSymbolKind(ctx.nCtx(), obj)))
        {
        case Z3_INT_SYMBOL:
            return new IntSymbol(ctx, obj);
        case Z3_STRING_SYMBOL:
            return new StringSymbol(ctx, obj);
        default:
            throw new Z3Exception("Unknown symbol kind encountered");
        }
    }
}
