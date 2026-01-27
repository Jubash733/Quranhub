# Decisions

Date: 2026-01-27

- Use SQLite (existing) for Quran core text + FTS search, and Isar for new caches and settings to minimize migration risk while meeting offline/search requirements.
- Use alquran.cloud as the online source for translation/tafsir/audio with local caching; keep offline data limited to Tanzil Uthmani text only to avoid translation/tafsir licensing risks.
- Override isar_flutter_libs with a local copy to fix broken Android Gradle metadata; use a minimal library `build.gradle` to restore builds under AGP 8.x.
- Build the SQLite FTS search index on demand (first search) and show a dedicated “preparing search” UI, so upgrades can rebuild indexes explicitly.
- Cache AI tadabbur responses in Isar with a 30-day TTL keyed by (promptType, promptVersion, language, ayahRef); allow an in-memory cache override for tests to avoid native Isar binaries.
- Cache ayah audio using Dio downloads + Isar metadata in app support storage; enforce 500MB LRU eviction and expose reciter/surah cleanup in Settings. Audio_service background playback is deferred to avoid breaking existing player behavior.
- Surah playback uses a dedicated AudioPlayer in the detail screen that streams ayah audio sequentially via GetAyahAudioUsecase; starting verse playback stops surah playback to avoid overlapping audio.
