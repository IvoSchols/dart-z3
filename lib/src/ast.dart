import 'generated_bindings.dart';

import 'context.dart';
import 'object.dart';

class Ast extends Object {
  late Z3_ast? _ast;

  Ast.empty(NativeZ3Library lookup, Context context) : super(lookup, context) {
    _ast = null; // TODO: check is correct?
  }

  Ast(NativeZ3Library lookup, Context context, Z3_ast ast)
      : super(lookup, context) {
    lookup.Z3_inc_ref(context.native, ast);
    _ast = ast;
  }

  // Z3_ast get ast {
  //   return lookup.Z3_get_ast_value(context, _ast);
  // }
}
