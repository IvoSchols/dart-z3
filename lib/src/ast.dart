part of 'z3.dart';

/// An abstract syntax tree (AST) node that holds its own context.
/// ALL RETURNS NEED TO BE FREED -> MEMORY LEAKS
class AST {
  final NativeZ3Library _native;
  late final Z3_context _context;

  late final Z3_sort _stringSort;
  late final Z3_sort _boolSort;
  late final Z3_sort _intSort;

  AST(this._native) {
    Z3_config config = _native.Z3_mk_config();
    //TODO: add config options
    _context = _native.Z3_mk_context(config);
    _native.Z3_del_config(config);

    //is this okay? Maybe create sorts/types class?
    _stringSort = _native.Z3_mk_string_sort(_context);
    _boolSort = _native.Z3_mk_bool_sort(context);
    _intSort = _native.Z3_mk_int_sort(context);
  }

  // Destructor, frees the context
  void dispose() {
    // _native.Z3_del_context(_context);
    // calloc.free(_context);
  }

  // Propositional Logic and Equality

  /// Create an AST node representing and
  /// args must have at least one element
  /// All types must be of type bool sort
  Z3_ast and(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areBoolSort(args)) throw ElementNotBoolSortException();
    Pointer<Z3_ast> cArray = _astListToCArray(args);
    Z3_ast result = _native.Z3_mk_and(context, args.length, cArray);
    calloc.free(cArray);
    return result;
  }

  /// Create an AST node representing l = r
  /// l and r must be of the same sort
  Z3_ast eq(Z3_ast l, Z3_ast r) {
    if (!_isSameSort(l, r)) throw SortMismatchException();
    return _native.Z3_mk_eq(context, l, r);
  }

  // Create an AST node representing l != r
  /// l and r must be of the same sort
  Z3_ast neq(Z3_ast l, Z3_ast r) {
    if (!_isSameSort(l, r)) throw SortMismatchException();
    return _native.Z3_mk_not(context, eq(l, r));
  }

  /// Create an AST node representing xor
  /// x and y must be of type bool sort
  Z3_ast iff(Z3_ast x, Z3_ast y) {
    if (!_areBoolSort([x, y])) throw ElementNotBoolSortException();
    return _native.Z3_mk_iff(context, x, y);
  }

  /// Create an AST node representing not
  /// Node must have a Boolean sort!
  Z3_ast not(Z3_ast ast) {
    //TODO: is this check needed?
    if (!_isBoolSort(ast)) throw ElementNotBoolSortException();
    return _native.Z3_mk_not(_context, ast);
  }

  /// Create an AST node representing or
  /// args must have at least one element
  /// args must be of type bool sort
  Z3_ast or(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areBoolSort(args)) throw ElementNotBoolSortException();
    Pointer<Z3_ast> cArray = _astListToCArray(args);
    Z3_ast result = _native.Z3_mk_or(context, args.length, cArray);
    calloc.free(cArray);
    return result;
  }

  /// Create an AST node representing xor
  /// x and y must be of type bool sort
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
    Pointer<Z3_ast> cArray = _astListToCArray(args);
    Z3_ast result = _native.Z3_mk_add(context, args.length, cArray);
    calloc.free(cArray);
    return result;
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

  /// Create an AST node representing ge
  /// x and y must have the same sort, and must be int or real sort
  Z3_ast ge(Z3_ast x, Z3_ast y) {
    if (!_areIntOrRealSort([x, y])) throw ElementNotIntOrRealSortException();
    return _native.Z3_mk_ge(context, x, y);
  }

  /// Create an AST node representing le
  /// x and y must have the same sort, and must be int or real sort
  Z3_ast le(Z3_ast x, Z3_ast y) {
    if (!_areIntOrRealSort([x, y])) throw ElementNotIntOrRealSortException();
    return _native.Z3_mk_le(context, x, y);
  }

  /// Create an AST node representing mul
  /// All types must be of type int or real sort
  /// args must have at least one element
  Z3_ast mul(List<Z3_ast> args) {
    if (args.isEmpty) throw EmptyListException();
    if (!_areIntOrRealSort(args)) throw ElementNotIntOrRealSortException();
    Pointer<Z3_ast> cArray = _astListToCArray(args);
    Z3_ast result = _native.Z3_mk_mul(context, args.length, cArray);
    calloc.free(cArray);
    return result;
  }

  ///
  /// Make variables
  ///

  /// Create a string constant
  Z3_ast mkStringConst(String str) {
    Pointer<Char> strPtr = str.toNativeUtf8().cast();
    Z3_ast result = _native.Z3_mk_string(context, strPtr);
    malloc.free(strPtr);
    return result;
  }

  /// Create a string variable using the given name
  Z3_ast mkStringVar(String name) {
    return _mkVar(name, _stringSort);
  }

  ///  Create a constant symbol using the given name.
  Z3_ast _mkVar(String name, Z3_sort ty) {
    Pointer<Char> strPtr = name.toNativeUtf8().cast();
    Z3_symbol s = _native.Z3_mk_string_symbol(_context, strPtr);
    Z3_ast result = _native.Z3_mk_const(_context, s, ty);
    malloc.free(strPtr);
    // malloc.free(s); -> cannot free segfault
    return result;
  }

  /// Create a boolean constant
  Z3_ast mkBoolConst(bool boolean) {
    Z3_symbol symbol = _native.Z3_mk_int_symbol(context, boolean ? 1 : 0);
    Z3_ast result = _native.Z3_mk_const(context, symbol, _boolSort);
    // malloc.free(symbol); -> cannot free attempt to free invalid pointer 0x1
    return result;
  }

  /// Create a boolean variable using the given name
  Z3_ast mkBoolVar(String name) {
    return _mkVar(name, _boolSort);
  }

  /// Create an integer
  Z3_ast mkInt(int value) {
    return _native.Z3_mk_int(_context, value, _intSort);
  }

  /// Create an integer variable using the given name
  Z3_ast mkIntVar(String name) {
    return _mkVar(name, _intSort);
  }

  Z3_context get context => _context;

  ///
  /// Helper function
  ///
  ///
  Pointer<Z3_ast> _astListToCArray(List<Z3_ast> list) {
    final ptr = calloc.allocate<Z3_ast>(sizeOf<Pointer>() * list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  /// Check if all given AST are of type bool sort
  bool _areBoolSort(List<Z3_ast> args) {
    return args.every((ast) => _isBoolSort(ast));
  }

  /// Check if given AST is of type bool sort
  bool _isBoolSort(Z3_ast ast) {
    return _native.Z3_get_sort(context, ast) == _boolSort;
  }

  /// Check if all given AST are of type int or real sort
  bool _areIntOrRealSort(List<Z3_ast> args) {
    return args.every((ast) => _isIntOrRealSort(ast));
  }

  /// Check if given AST is of type int or real sort
  bool _isIntOrRealSort(Z3_ast ast) {
    return _native.Z3_get_sort(context, ast) == _intSort;
  }

  /// Check if all given AST are of same sort
  /// (Not sure if the responsibility lies with this package)
  bool areSameSort(List<Z3_ast> args) {
    if (args.isEmpty) return false;
    if (args.length == 1) return true;
    return args.skip(1).every((element) => _isSameSort(args[0], element));
  }

  /// Check if given AST is of type int sort
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
