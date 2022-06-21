

// /**
// Copyright (c) 2012-2014 Microsoft Corporation
   
// Module Name:
//     Sort.java
// Abstract:
// Author:
//     @author Christoph Wintersteiger (cwinter) 2012-03-15
// Notes:
    
// **/ 
part of 'z3.dart'

/**
 * The Sort class implements type information for ASTs.
 **/
class Sort extends AST
{
    /**
     * Equality operator for objects of type Sort. 
     **/
    @override
    bool equals(Object o)
    {
        if (o == this) return true;
        if (!(o is Sort)) return false;
        Sort other = o;

        return (getContext().nCtx() == other.getContext().nCtx()) &&
            (Native.isEqSort(getContext().nCtx(), getNativeObject(), other.getNativeObject()));
    }

    /**
     * Hash code generation for Sorts
     * 
     * @return A hash code
     **/
    int hashCode()
    {
        return super.hashCode();
    }

    /**
     * Returns a unique identifier for the sort.
     **/
    int getId()
    {
        return Native.getSortId(getContext().nCtx(), getNativeObject());
    }

    /**
     * The kind of the sort.
     **/
    Z3_sort_kind getSortKind()
    {
        return Z3_sort_kind.fromInt(Native.getSortKind(getContext().nCtx(),
                getNativeObject()));
    }

    /**
     * The name of the sort
     **/
    Symbol getName()
    {
        return Symbol.create(getContext(),
                Native.getSortName(getContext().nCtx(), getNativeObject()));
    }

    /**
     * A string representation of the sort.
     **/
    @override
    String toString() {
        return Native.sortToString(getContext().nCtx(), getNativeObject());
    }

    /**
     * Translates (copies) the sort to the Context {@code ctx}.
     * 
     * @param ctx A context
     * 
     * @return A copy of the sort which is associated with {@code ctx}
     * @throws Z3Exception on error
     **/
    Sort translate(Context ctx)
    {
        return (Sort) super.translate(ctx);
    }

    /**
     * Sort constructor
     **/
    Sort(Context ctx, int obj) : super(ctx, int);
    
    @override
    void checkNativeObject(int obj)
    {
        if (Native.getAstKind(getContext().nCtx(), obj) != Z3_ast_kind.Z3_SORT_AST
                .toInt())
            throw new Z3Exception("Underlying object is not a sort");
        super.checkNativeObject(obj);
    }

    static Sort create(Context ctx, int obj)
    {
        Z3_sort_kind sk = Z3_sort_kind.fromInt(Native.getSortKind(ctx.nCtx(), obj));
        switch (sk)
        {
        case Z3_ARRAY_SORT:
            return new ArraySort<>(ctx, obj);
        case Z3_BOOL_SORT:
            return new BoolSort(ctx, obj);
        case Z3_BV_SORT:
            return new BitVecSort(ctx, obj);
        case Z3_DATATYPE_SORT:
            return new DatatypeSort<>(ctx, obj);
        case Z3_INT_SORT:
            return new IntSort(ctx, obj);
        case Z3_REAL_SORT:
            return new RealSort(ctx, obj);
        case Z3_UNINTERPRETED_SORT:
            return new UninterpretedSort(ctx, obj);
        case Z3_FINITE_DOMAIN_SORT:
            return new FiniteDomainSort(ctx, obj);
        case Z3_RELATION_SORT:
            return new RelationSort(ctx, obj);
        case Z3_FLOATING_POINT_SORT:
            return new FPSort(ctx, obj);
        case Z3_ROUNDING_MODE_SORT:
            return new FPRMSort(ctx, obj);
        case Z3_SEQ_SORT:
            return new SeqSort<>(ctx, obj);
        case Z3_RE_SORT:
            return new ReSort<>(ctx, obj);
        default:
            throw new Z3Exception("Unknown sort kind");
        }
    }
}