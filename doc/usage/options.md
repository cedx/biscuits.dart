path: blob/master
source: lib/src/cookie_options.dart

# Cookie options
Several methods of the [`Cookies`](api.md) class accept an `options` parameter in order to customize the cookie attributes.
These options are expressed using an instance of the `CookieOptions` class, which has the following properties:

- String **domain**: The domain for which the cookie is valid.
- DateTime **expires**: The expiration date and time for the cookie. A `null` value indicates a session cookie.
- Duration **maxAge**: The maximum duration until the cookie expires. A `null` value indicates a session cookie.
- String **path**: The path to which the cookie applies.
- bool **secure**: Value indicating whether to transmit the cookie over HTTPS only.

!!! info
    The `maxAge` property has precedence over the `expires` one.

For example:

```dart
import 'package:biscuits/biscuits.dart';

void main() {
  Cookies().set('foo', 'bar', CookieOptions(
    domain: 'www.domain.com',
    maxAge: const Duration(hours: 1),
    path: '/'
  ));
}
```
    
## Configuring defaults
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

  print(jsonEncode(cookies.defaults));
  // {"domain": "www.domain.com", "expires": null, "path": "/", "secure": true}
}
```

!!! tip
    The [`Cookies#defaults`](api.md) property let you override the default cookie options at runtime.
