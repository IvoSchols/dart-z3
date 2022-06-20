import 'generated_bindings.dart';

enum Z3_error_code {
  Z3_OK,
  Z3_SORT_ERROR,
  Z3_IOB,
  Z3_INVALID_ARG,
  Z3_PARSER_ERROR,
  Z3_NO_PARSER,
  Z3_INVALID_PATTERN,
  Z3_MEMOUT_FAIL,
  Z3_FILE_ACCESS_ERROR,
  Z3_INTERNAL_FATAL,
  Z3_INVALID_USAGE,
  Z3_DEC_REF_ERROR,
  Z3_EXCEPTION
}

class Object {
  late final NativeZ3Library _lookup;
  late final Z3_context _context;

  Object(NativeZ3Library lookup, Z3_context context) {
    _lookup = lookup;
    _context = context;
  }

  Z3_error_code check_error(Z3_context context) {
    int z3_error_code = _lookup.Z3_get_error_code(_context);

    //TODO: handle error code

    //TODO: implement missing error codes
    if (z3_error_code == Z3_error_code.Z3_OK.index) {
      return Z3_error_code.Z3_OK;
    } else {
      return Z3_error_code.Z3_EXCEPTION;
    }
  }

  get lookup => _lookup;
  get context => _context;
}
