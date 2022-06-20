import 'generated_bindings.dart';

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
class Sort {
  late final NativeZ3Library _lookup;
  late final Z3_context _context;

  Sort(NativeZ3Library lookup, Z3_context context) {
    _lookup = lookup;
    _context = context;
  }
}
