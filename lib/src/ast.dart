part of 'z3.dart';

class AST {
  final NativeZ3Library _native;
  late final Z3_context _context;

  late final Z3_sort _boolSort;
  late final Z3_sort _intSort;

  AST(this._native) {
    Z3_config config = _native.Z3_mk_config();
    //TODO: add config options
    _context = _native.Z3_mk_context(config);
    _native.Z3_del_config(config);

    //is this okay? Maybe create sorts/types class?
    _boolSort = _native.Z3_mk_bool_sort(context);
    _intSort = _native.Z3_mk_int_sort(context);
  }

  // Propositional Logic and Equality

  // Create an AST node representing and
  // args must have at least one element
  // All types must be of type bool sort
  Z3_ast and(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areBoolSort(args)) throw ElementNotBoolSortException();
    return _native.Z3_mk_and(context, args.length, _astListToArray(args));
  }

  // Create an AST node representing l = r
  // l and r must be of the same sort
  Z3_ast eq(Z3_ast l, Z3_ast r) {
    if (!_isSameSort(l, r)) throw SortMismatchException();
    return _native.Z3_mk_eq(context, l, r);
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

  // Create an AST node representing or
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
  /// Integer and Real Arithmetic/Inequality
  ///
  /// Create an AST node representing add
  /// x and y must be of type int or real sort
  Z3_ast add(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areIntOrRealSort(args)) throw ElementNotIntOrRealSortException();
    return _native.Z3_mk_add(context, args.length, _astListToArray(args));
  }

  /// Create an AST node representing gt
  /// x and y must have the same sort, and must be int or real sort
  Z3_ast gt(Z3_ast x, Z3_ast y) {
    if (!_areIntOrRealSort([x, y])) throw ElementNotIntOrRealSortException();
    return _native.Z3_mk_gt(context, x, y);
  }

  /// Create an AST node representing lt
  /// x and y must have the same sort, and must be int or real sort
  Z3_ast lt(Z3_ast x, Z3_ast y) {
    if (!_areIntOrRealSort([x, y])) throw ElementNotIntOrRealSortException();
    _native.Z3_get_sort(context, x) ==
        _native.Z3_get_sort(context, y); // TODO: check is this correct?
    return _native.Z3_mk_lt(context, x, y);
  }

  /// Create an AST node representing mul
  /// All types must be of type int or real sort
  /// args must have at least one element
  Z3_ast mul(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areIntOrRealSort(args)) throw ElementNotIntOrRealSortException();
    return _native.Z3_mk_mul(context, args.length, _astListToArray(args));
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
    return _native.Z3_mk_const(_context, symbol, _boolSort);
  }

  // Create a boolean variable using the given name
  Z3_ast mkBoolVar(String name) {
    return mkVar(name, _boolSort);
  }

  // Create an integer
  Z3_ast mkInt(int value) {
    return _native.Z3_mk_int(_context, value, _intSort);
  }

  // Create an integer variable using the given name
  Z3_ast mkIntVar(String name) {
    return mkVar(name, _intSort);
  }

  Z3_context get context => _context;

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
    return _native.Z3_get_sort(context, ast) == _boolSort;
  }

  bool _areIntOrRealSort(List<Z3_ast> args) {
    return args.every((ast) => _isIntOrRealSort(ast));
  }

  bool _isIntOrRealSort(Z3_ast ast) {
    return _native.Z3_get_sort(context, ast) == _intSort;
  }

  bool _areSameSort(List<Z3_ast> args) {
    return args.every((ast) => _isSameSort(args[0], ast));
  }

  bool _isSameSort(Z3_ast x, Z3_ast y) {
    return _native.Z3_get_sort(context, x) == _native.Z3_get_sort(context, y);
  }

  // Deletes C pointer of context, only use at end there is no null check for the pointer
  // In this implementation (right now) context and ast are bound together.
  // This is not the case in the C API.
  // Please only call if you know what you are doing.
  void delAst() {
    _native.Z3_del_context(context);
  }
}
