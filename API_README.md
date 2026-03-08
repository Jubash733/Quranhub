# API Documentation

This document explains the unified API Layer integrated into the Quran App.

## Architecture
The API layer comprises:
1. `ApiClient`: A wrapper around `Dio` configured with `LogInterceptor`, caching, and retry mechanisms.
2. `ApiResult<T>`: A sealed response wrapper returning `Success<T>` or `Failure<T>`.

## Usage
Instead of throwing and catching exceptions throughout the codebase, repositories should use `ApiClient.safeCall`.

### Example
```dart
  Future<ApiResult<List<Surah>>> fetchSurahs() async {
    return await apiClient.safeCall(() => quranApi.getChapters());
  }
```

### Response Handling
```dart
  final result = await repo.fetchSurahs();
  switch (result) {
    case Success(data: final data):
      // Emit Data
      break;
    case Failure(message: final message):
      // Emit Error Note
      break;
  }
```

## AI Integrations (Gemini)
Gemini features reside in `lib/data/api/ai_api.dart` or service layers, communicating via `ApiClient` if REST based, or utilizing the Google AI Dart SDK wrapped with `safeCall` to ensure UI gracefully handles AI downtime.
