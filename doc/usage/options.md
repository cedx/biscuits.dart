# Cookie options
Several methods accept an `options` parameter in order to customize the cookie attributes.
These options are expressed using an instance of the [`CookieOptions`](https://github.com/cedx/cookies.js/blob/master/lib/cookie_options.js) class, which has the following properties:

- String **domain** = `""`: The domain for which the cookie is valid.
- DateTime **expires** = `null`: The expiration date and time for the cookie.
- String **path** = `""`: The path to which the cookie applies.
- bool **secure** = `false`: Value indicating whether to transmit the cookie over HTTPS only.

For example:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  Cookies().set('foo', 'bar', CookieOptions(
    domain: 'www.domain.com',
    expires: DateTime.now().add(const Duration(hours: 1)),
    path: '/'
  ));
}
```

It is possible to provide default values for the cookie options when instantiating the `Cookies` service:

```dart
import 'dart:convert';
import 'package:biscuits/biscuits.dart';

void main() {
  final cookies = Cookies(defaults: CookieOptions(
    domain: 'www.domain.com',
    path: '/',
    secure: true
  ));

  print(json.encode(cookies.defaults));
  // {"domain": "www.domain.com", "expires": null, "path": "/", "secure": true}
}
```

!!! tip
    The `Cookies#defaults` property let you override the default cookie options at runtime.
