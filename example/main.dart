import 'package:biscuits/biscuits.dart';

/// Tests the cookie service.
void writeCookies() {
  final _cookies = Cookies();

  // Write the cookies.
  print(_cookies.containsKey('foo')); // false
  print(_cookies.containsKey('baz')); // false
  print(_cookies.length); // 0

  _cookies['foo'] = 'bar';
  print(_cookies.containsKey('foo')); // true
  print(_cookies.length); // 1

  _cookies.setObject('baz', <String, int>{'qux': 123});
  print(_cookies.containsKey('baz')); // true
  print(_cookies.length); // 2

  // Read the cookies.
  print(_cookies['foo']); // null
  print(_cookies['baz']); // null

  _cookies['foo'] = 'bar';
  print(_cookies['foo'].runtimeType); // "String"
  print(_cookies['foo']); // "bar"

  _cookies.setObject('baz', <String, int>{'qux': 123});
  print(_cookies.getObject('baz').runtimeType); // "_JsonMap"
  print(_cookies.getObject('baz')); // {"qux": 123}
  print(_cookies.getObject('baz')['qux']); // 123

  // Delete the cookies.
  _cookies.remove('foo');
  print(_cookies.containsKey('foo')); // false
  print(_cookies.length); // 1

  _cookies.clear();
  print(_cookies.containsKey('baz')); // false
  print(_cookies.length); // 0
}
