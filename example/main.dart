import 'package:biscuits/biscuits.dart';

/// TODO
void main() {
  var cookies = Cookies();

  cookies['foo'] = 'bar';
  print(cookies['foo'].runtimeType); // "String"
  print(cookies['foo']); // "bar"

  cookies.setObject('bar', <String, int>{'baz': 123});
  print(cookies.getObject('bar').runtimeType); // "_JsonMap"
  print(cookies.getObject('bar')); // {"baz": 123}
  print(cookies.getObject('bar')['baz']); // 123
}
