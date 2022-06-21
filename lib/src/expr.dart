import 'generated_bindings.dart';

import 'ast.dart';
import 'context.dart';
import 'sort.dart';

class Expr extends Ast {
  Expr(NativeZ3Library lookup, Context context) : super.empty(lookup, context);

  Expr.fromAst(NativeZ3Library lookup, Context context, Z3_ast ast)
      : super(lookup, context, ast) {}

  bool is_bool() {
    super.
    return lookup.Z3_is_bool_sort(context, sort);
  }

  Expr operator &(Expr a) {
    //TODO: check context match
    assert(is_bool() && a.is_bool());
    Z3_ast r = lookup.Z3_mk_and(context, 2, [this, a]);
    //TODO:check for error
    return Expr.fromAst(lookup, context, r);
  }

}
