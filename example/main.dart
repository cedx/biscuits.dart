import 'package:biscuits/biscuits.dart';

/// Tests the cookie service.
void main() {
  final cookies = Cookies();

  // Write the cookies.
  print(cookies.containsKey('foo')); // false
  print(cookies.containsKey('baz')); // false
  print(cookies.length); // 0

  cookies['foo'] = 'bar';
  print(cookies.containsKey('foo')); // true
  print(cookies.length); // 1

  cookies.setObject('baz', <String, int>{'qux': 123});
  print(cookies.containsKey('baz')); // true
  print(cookies.length); // 2

  // Read the cookies.
  print(cookies['foo'].runtimeType); // "String"
  print(cookies['foo']); // "bar"

  print(cookies.getObject('baz').runtimeType); // "_JsonMap"
  print(cookies.getObject('baz')); // {"qux": 123}
  print(cookies.getObject('baz')['qux']); // 123

  // Delete the cookies.
  cookies.remove('foo');
  print(cookies.containsKey('foo')); // false
  print(cookies.length); // 1

  cookies.clear();
  print(cookies.containsKey('baz')); // false
  print(cookies.length); // 0
}
