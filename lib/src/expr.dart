import 'generated_bindings.dart';
import 'sort.dart';

class Expr {
  late final NativeZ3Library _lookup;
  late final Z3_context _context;

  Expr(Z3_context context) {
    _context = context;
  }

  Sort get sort {
    return Sort(_lookup, _context);
  }
}
