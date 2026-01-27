# Decisions

Date: 2026-01-27

- Use SQLite (existing) for Quran core text + FTS search, and Isar for new caches and settings to minimize migration risk while meeting offline/search requirements.
- Use alquran.cloud as the online source for translation/tafsir/audio with local caching; keep offline data limited to Tanzil Uthmani text only to avoid translation/tafsir licensing risks.
- Override isar_flutter_libs with a local copy to fix broken Android Gradle metadata; use a minimal library `build.gradle` to restore builds under AGP 8.x.
