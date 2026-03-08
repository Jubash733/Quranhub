import 'package:core/di/dependency.dart';
import 'package:library_domain/di/dependency.dart';
import 'package:quran/di/dependency.dart';

class Injections {
  void init() {
    // Shared Module
    RegisterCoreModule();

    // Feature Quran
    RegisterQuranModule();

    // Feature Library
    RegisterLibraryModule();
  }
}

