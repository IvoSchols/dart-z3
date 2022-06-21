import 'generated_bindings.dart';

import 'ast.dart';
import 'context.dart';

enum Z3_sort_kind {
  Z3_UNINTERPRETED_SORT,
  Z3_BOOL_SORT,
  Z3_INT_SORT,
  Z3_REAL_SORT,
  Z3_BV_SORT,
  Z3_ARRAY_SORT,
  Z3_DATATYPE_SORT,
  Z3_RELATION_SORT,
  Z3_FINITE_DOMAIN_SORT,
  Z3_FLOATING_POINT_SORT,
  Z3_ROUNDING_MODE_SORT,
  Z3_SEQ_SORT,
  Z3_RE_SORT,
  Z3_CHAR_SORT,
  Z3_UNKNOWN_SORT,
}

//TODO finish recursive sort implementation
class Sort extends Ast {
  late Z3_sort native;

  Sort.fromAst(NativeZ3Library lookup, Context context, Z3_ast ast)
      : super(lookup, context, ast);

  Sort.fromNative(NativeZ3Library lookup, Context context, Z3_sort sort)
      : super(lookup, context) {
    native = sort;
  }
}
