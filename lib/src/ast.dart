/**
Copyright (c) 2012-2014 Microsoft Corporation
   
Module Name:

    AST.java

Abstract:

Author:

    @author Christoph Wintersteiger (cwinter) 2012-03-15

Notes:
    
**/

part of 'z3.dart';


/**
 * The abstract syntax tree (AST) class.
 **/
class AST extends Z3Object implements Comparable<AST>
{
    /**
     * Object comparison.
     * 
     * @param o another AST
     **/
    @override
    bool equals(Object o)
    {
        if (o == this) return true;
        if (!(o is AST)) return false;
        AST casted = o;

        return
            (getContext()._ctx == casted.getContext()._ctx) &&
               (bool) (lookup.Z3_is_eq_ast(getContext()._ctx, getNativeObject().toInt(), casted.getNativeObject());
    }

    /**
     * Object Comparison. 
     * @param other Another AST
     * 
     * @return Negative if the object should be sorted before {@code other}, 
     * positive if after else zero.
     * @throws Z3Exception on error
     **/
    @override
    int compareTo(AST other)
    {
        if (other == null) {
            return 1;
        }
        return Integer.compare(getId(), other.getId());
    }

    /**
     * The AST's hash code.
     * 
     * @return A hash code
     **/
    @override
    int hashCode()
    {
        return Native.getAstHash(getContext().nCtx(), getNativeObject());
    }

    /**
     * A unique identifier for the AST (unique among all ASTs).
     * @throws Z3Exception on error
     **/
    int getId()
    {
        return Native.getAstId(getContext().nCtx(), getNativeObject());
    }

    /**
     * Translates (copies) the AST to the Context {@code ctx}. 
     * @param ctx A context
     * 
     * @return A copy of the AST which is associated with {@code ctx}
     * @throws Z3Exception on error
     **/
    AST translate(Context ctx)
    {
        if (getContext() == ctx) {
            return this;
        } else {
            return create(ctx, Native.translate(getContext().nCtx(), getNativeObject(), ctx.nCtx()));
        }
    }

    /**
     * The kind of the AST.
     * @throws Z3Exception on error
     **/
    Z3_ast_kind getASTKind()
    {
        return Z3_ast_kind.fromInt(Native.getAstKind(getContext().nCtx(),
                getNativeObject()));
    }

    /**
     * Indicates whether the AST is an Expr
     * @throws Z3Exception on error
     * @throws Z3Exception on error
     **/
    bool isExpr()
    {
        switch (getASTKind())
        {
        case Z3_APP_AST:
        case Z3_NUMERAL_AST:
        case Z3_QUANTIFIER_AST:
        case Z3_VAR_AST:
            return true;
        default:
            return false;
        }
    }

    /**
     * Indicates whether the AST is an application
     * @return a bool
     * @throws Z3Exception on error
     **/
    bool isApp()
    {
        return this.getASTKind() == Z3_ast_kind.Z3_APP_AST;
    }

    /**
     * Indicates whether the AST is a BoundVariable.
     * @return a bool
     * @throws Z3Exception on error
     **/
    bool isVar()
    {
        return this.getASTKind() == Z3_ast_kind.Z3_VAR_AST;
    }

    /**
     * Indicates whether the AST is a Quantifier
     * @return a bool
     * @throws Z3Exception on error
     **/
    bool isQuantifier()
    {
        return this.getASTKind() == Z3_ast_kind.Z3_QUANTIFIER_AST;
    }

    /**
     * Indicates whether the AST is a Sort
     **/
    bool isSort()
    {
        return this.getASTKind() == Z3_ast_kind.Z3_SORT_AST;
    }

    /**
     * Indicates whether the AST is a FunctionDeclaration
     **/
    bool isFuncDecl()
    {
        return this.getASTKind() == Z3_ast_kind.Z3_FUNC_DECL_AST;
    }

    /**
     * A string representation of the AST.
     **/
    @override
    String toString() {
        return Native.astToString(getContext().nCtx(), getNativeObject());
    }

    /**
     * A string representation of the AST in s-expression notation.
     **/
    String getSExpr()
    {
        return Native.astToString(getContext().nCtx(), getNativeObject());
    }

    AST(Context ctx, int obj) : super(ctx, obj);

    @override
    void incRef() {
        Native.incRef(getContext().nCtx(), getNativeObject());
    }

    @override
    void addToReferenceQueue() {
        getContext().getASTDRQ().storeReference(getContext(), this);
    }

    static AST create(Context ctx, long obj)
    {
        switch (Z3_ast_kind.fromInt(Native.getAstKind(ctx.nCtx(), obj)))
        {
        case Z3_FUNC_DECL_AST:
            return new FuncDecl<>(ctx, obj);
        case Z3_QUANTIFIER_AST:
            return new Quantifier(ctx, obj);
        case Z3_SORT_AST:
            return Sort.create(ctx, obj);
        case Z3_APP_AST:
        case Z3_NUMERAL_AST:
        case Z3_VAR_AST:
            return Expr.create(ctx, obj);
        default:
            throw new Z3Exception("Unknown AST kind");
        }
    }
}
