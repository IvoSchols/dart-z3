import 'object.dart';

import 'generated_bindings.dart';

class Ast extends Object {
  Z3_ast _ast;

  Ast(NativeZ3Library lookup, Z3_context context) : super(lookup, context) {}

  Z3_ast get ast {
    return lookup.Z3_get_ast_value(context, _ast);
  }
}
