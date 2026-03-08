# NOTICE — Sources & Licenses

This project aggregates datasets and APIs with their respective licenses. All data indexed by AyahRef(surah, ayah).

## Text (Quran)
- **Tanzil Quran Text (Uthmani)** — CC BY 3.0
  - Must retain copyright notice, provide attribution to Tanzil.net, and do not modify the text.
  - Source: https://tanzil.net/docs/text_license

## Translations (On-demand Downloads)
- **Project Gutenberg (EBook #16955)** — Public Domain (US)
  - Used to build the Pickthall English translation pack at download time.
  - Source: https://www.gutenberg.org/ebooks/16955

## Tafsir
- No tafsir is bundled. Tafsir packs are only enabled when the source license is
  Public Domain / CC0 / CC-BY / CC-BY-SA (or written permission).

## Surah Metadata
- **quranjson** — MIT
  - Source: https://github.com/semarketir/quranjson

## Surah Summaries (Planned / Generated)
- **Arabic Wikipedia (ar.wikipedia.org)** — CC BY-SA 4.0
  - Generated via `tools/scripts/build_surah_summaries_wikipedia.py`.
  - Attribution data stored in `assets/data/surah_summaries_attribution.json`.
  - Source: https://ar.wikipedia.org
  - License: https://creativecommons.org/licenses/by-sa/4.0/

## Tajweed (Planned)
- **quran-tajweed** — CC BY 4.0
  - Source: https://github.com/cpfair/quran-tajweed

## Audio (Streaming)
- **alquran.cloud API** — streaming only (downloads disabled unless license is explicit).
  - Source: https://alquran.cloud/api

---
If you replace any dataset, update this NOTICE with the new source and license.
