void DBG(String msg) {
  assert(() {
    print('[DEBUG] $msg');

    return true;
  }());
}
