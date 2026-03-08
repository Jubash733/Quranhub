# OSS Audit

Last updated: 2026-01-27

## Scope
This audit covers:
- External datasets and APIs used for Quran text, translations, metadata, and related features.
- Third‑party packages used by the Flutter app.

## Findings (Datasets/APIs)
### Quran Text
- **Tanzil Quran Text (Uthmani)** — CC BY 3.0
  - Usage: Offline Quran text dataset.
  - Notes: Must not modify text; must attribute Tanzil.net and include license notice.
  - Source: https://tanzil.net/docs/text_license

### Translations & Tafsir
- **alquran.cloud API** — Online-only translations/tafsir with local caching.
  - Usage: Online fallback for translations/tafsir (no offline packs bundled).
  - Source: https://alquran.cloud/api

### Surah Metadata
- **quranjson** — MIT
  - Usage: Surah names/metadata.
  - Source: https://github.com/semarketir/quranjson

### Online Fallback APIs
- **alquran.cloud API** — API access for translations/tafsir/audio fallback
  - Usage: Remote fallback (online only).
  - Source: https://alquran.cloud/api

## Compliance Summary
- All datasets are logged in NOTICE.md with license obligations.
- No Play Store assets or proprietary media are included.
- Any dataset without a permissive or clearly stated license is excluded.

## TODO (Blocked by Licensing)
- Tafsir packs (e.g., Ibn Kathir, Al‑Sa’di): require explicit license verification.
- Mushaf page image packs: require explicit license and redistribution rights.
- Audio recitations: require explicit license and redistribution rights.
- Topic/subject datasets and bounding boxes: require explicit license.

## Package License Review
See THIRD_PARTY_NOTICES.md for package list and licenses. Recent additions
include hooks_riverpod (MIT), flutter_hooks (MIT), freezed_annotation (MIT),
isar/isar_flutter_libs (Apache‑2.0), flutter_cache_manager (MIT), and
background_downloader (BSD‑3‑Clause).
