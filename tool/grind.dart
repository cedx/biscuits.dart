import 'dart:async';
import 'package:grinder/grinder.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@DefaultTask('Build the project')
void build() => Pub.run('build_runner', arguments: ['build', '--delete-conflicting-outputs']);

@Task('Delete all generated files and reset any saved state')
void clean() {
  defaultClean();
  ['.dart_tool/build', 'doc/api', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '*.{info,json}').files.forEach(delete);
}

@Task('Upload the results of the code coverage')
void coverage() => Pub.run('coveralls', arguments: ['var/lcov.info']);

@Task('Build the documentation')
void doc() {
  DartDoc.doc();
  run('mkdocs', arguments: ['build']);
}

@Task('Fix the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs, lineLength: 200);

@Task('Perform the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Run the test suites')
void test() => TestRunner().test();

@Task('Upgrade the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watch for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch']);
