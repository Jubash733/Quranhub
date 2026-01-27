# COMPLIANCE

## Policy
- Only use OSS code and datasets with permissive licenses (MIT / Apache‑2.0 / BSD) for code.
- Do not copy any Play Store assets or proprietary content.
- Dataset licenses are recorded in NOTICE.md and verified in docs/OSS_AUDIT.md.
- Any non‑commercial dataset must be explicitly approved before commercial distribution.

## Current Status
- Quran text is sourced from Tanzil (CC BY 3.0, no modification, attribution required).
- Translations are sourced from Tanzil (non‑commercial only).
- Surah metadata from quranjson (MIT).
- New libraries added for the Library feature (Riverpod, Isar, background_downloader) are permissively licensed (MIT/BSD/Apache‑2.0).
- Any new dataset must be added to NOTICE.md and docs/OSS_AUDIT.md before shipping.

## Attribution Requirements
- Include Tanzil attribution in‑app or in documentation.
- Retain copyright notices in datasets.

## Review Process
1) Validate dataset license and usage rights.
2) Document in NOTICE.md and docs/OSS_AUDIT.md.
3) Add to THIRD_PARTY_NOTICES.md for code dependencies.
4) If license is GPL/LGPL for code: do not embed; re‑implement or isolate.
