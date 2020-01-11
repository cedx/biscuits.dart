/// Service for interacting with the [HTTP cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).
library biscuits;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:html' as dom;
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'biscuits.g.dart';
part 'src/cookie_options.dart';
part 'src/cookies.dart';
part 'src/simple_change.dart';
