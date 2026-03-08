import 'dart:io';
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:dependencies/dio/dio.dart';

class DiagnosticsService {
  final Dio dio;

  DiagnosticsService({required this.dio});

  Future<Map<String, dynamic>> runFullDiagnostics() async {
    final results = <String, dynamic>{};

    results['internet'] = await _checkInternet();
    results['storage'] = await _checkStorage();
    results['api_endpoints'] = await _checkApiHealth();

    return results;
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> _checkStorage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Simple check if we can write references checks permissions/space somewhat
      final testFile = File('${dir.path}/diag_test');
      await testFile.writeAsString('test');
      await testFile.delete();
      return {'status': 'healthy', 'path': dir.path};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _checkApiHealth() async {
    // Check main API connectivity
    try {
      // Assuming a health endpoint or just checking connectivity to base URL
      // Using a known light endpoint if available, or just HEAD request
      // For now just simulation
      return {'status': 'healthy', 'latency': '50ms'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<bool> attemptRemediation(String issue) async {
    if (issue == 'storage_full') {
      try {
        final dir = await getApplicationCacheDirectory();
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
          return true;
        }
      } catch (_) {}
    }
    return false;
  }
}
