import 'dart:async';
import 'package:grinder/grinder.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

/// Builds the project.
@DefaultTask('Build the project')
void build() => Pub.run('build_runner', arguments: ['build']);

/// Deletes all generated files and reset any saved state.
@Task('Delete the generated files')
void clean() {
  defaultClean();
  ['.dart_tool/build', 'doc/api', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '*.{info,json}').files.forEach(delete);
}

/// Uploads the code coverage report.
@Task('Upload the code coverage')
void coverage() => Pub.run('coveralls', arguments: ['var/lcov.info']);

/// Builds the documentation.
@Task('Build the documentation')
void doc() {
  DartDoc.doc();
  run('mkdocs', arguments: ['build']);
}

/// Fixes the coding standards issues.
@Task('Fix the coding issues')
void fix() => DartFmt.format(existingSourceDirs, lineLength: 200);

/// Performs static analysis of source code.
@Task('Perform the static analysis')
void lint() => Analyzer.analyze(existingSourceDirs);

/// Runs all the test suites.
@Task('Run the tests')
@Depends(build)
void test() => TestRunner().test();

/// Upgrades the project to the latest revision.
@Task('Upgrade the project')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}
