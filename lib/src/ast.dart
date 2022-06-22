part of 'z3.dart';

class AST {
  final NativeZ3Library _native;
  late final Z3_context _context;

  late final Z3_sort boolSort;

  AST(this._native) {
    Z3_config config = _native.Z3_mk_config();
    //TODO: add config options
    _context = _native.Z3_mk_context(config);
    _native.Z3_del_config(config);

    //is this okay?
    boolSort = _native.Z3_mk_bool_sort(context);
  }

  // Pointer<Z3_ast> mkConstBool(Pointer<Z3_sort> sort, dynamic value) {}

  // Logic

  // Create an ASt node representing and
  // args must have at least one element
  // All types must be of type bool sort
  Z3_ast and(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areBoolSort(args)) throw ElementNotBoolSortException();
    return _native.Z3_mk_and(context, args.length, _astListToArray(args));
  }

  // Create an AST node representing xor
  // x and y must be of type bool sort
  Z3_ast iff(Z3_ast x, Z3_ast y) {
    if (!_areBoolSort([x, y])) throw ElementNotBoolSortException();
    return _native.Z3_mk_iff(context, x, y);
  }

  // Create an AST node representing not
  // Node must have a Boolean sort!
  Z3_ast not(Z3_ast ast) {
    //TODO: is this check needed?
    if (!_isBoolSort(ast)) throw ElementNotBoolSortException();
    return _native.Z3_mk_not(_context, ast);
  }

  // Create an ASt node representing or
  // args must have at least one element
  // args must be of type bool sort
  Z3_ast or(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areBoolSort(args)) throw ElementNotBoolSortException();

    return _native.Z3_mk_or(context, args.length, _astListToArray(args));
  }

  // Create an AST node representing xor
  // x and y must be of type bool sort
  Z3_ast xor(Z3_ast x, Z3_ast y) {
    if (!_areBoolSort([x, y])) throw ElementNotBoolSortException();
    return _native.Z3_mk_xor(context, x, y);
  }

  ///
  /// Make variables
  ///

  ///  Create a constant symbol using the given name.
  Z3_ast mkVar(String name, Z3_sort ty) {
    Z3_symbol s =
        _native.Z3_mk_string_symbol(_context, name.toNativeUtf8().cast());
    return _native.Z3_mk_const(_context, s, ty);
  }

  // Create a boolean constant
  Z3_ast mkBoolConst(bool boolean) {
    var symbol = _native.Z3_mk_int_symbol(context, boolean ? 1 : 0);
    return _native.Z3_mk_const(_context, symbol, boolSort);
  }

  // Create a boolean variable using the given name
  Z3_ast mkBoolVar(String name) {
    return mkVar(name, boolSort);
  }

  Z3_context get context => _context;

  //Deletes C pointer of context, only use at end there is no null check for the pointer
  void cleanUpContext() {
    _native.Z3_del_context(context);
  }

  ///
  /// Helper function
  ///
  ///
  Pointer<Z3_ast> _astListToArray(List<Z3_ast> list) {
    final ptr = calloc.allocate<Z3_ast>(sizeOf<Pointer>() * list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  bool _areBoolSort(List<Z3_ast> args) {
    return args.every((ast) => _isBoolSort(ast));
  }

  bool _isBoolSort(Z3_ast ast) {
    return _native.Z3_get_sort(context, ast) == boolSort;
  }
}
