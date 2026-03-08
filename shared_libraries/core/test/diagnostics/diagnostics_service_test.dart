import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dependencies/dio/dio.dart';
import 'package:core/diagnostics/diagnostics_service.dart';

// Generate MockDio manually or via build_runner if time permits
// For now, simple mock
class MockDio extends Mock implements Dio {}

void main() {
  late DiagnosticsService service;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    service = DiagnosticsService(dio: mockDio);
  });

  group('DiagnosticsService', () {
    test('runFullDiagnostics returns map with keys', () async {
      // We can't easily mock static InternetAddress.lookup without a wrapper
      // But we can test the structure
      final result = await service.runFullDiagnostics();
      expect(result.containsKey('internet'), true);
      expect(result.containsKey('storage'), true);
      expect(result.containsKey('api_endpoints'), true);
    });

    test('attemptRemediation returns false for unknown issue', () async {
      final result = await service.attemptRemediation('unknown_issue');
      expect(result, false);
    });
  });
}
