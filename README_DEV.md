# Quran App — Engineering TODO (Lead Plan)

## Goals
- Enterprise-level Quran app with offline core, FTS search, tafsir, tajweed, audio, AI tadabbur, and polished RTL UI/UX.
- Keep clean architecture: data/domain/presentation + Repositories/UseCases/Cubits + get_it DI.

## Non‑Negotiables
- No external state mgmt imports (no Provider/Bloc from other projects).
- All data indexed by AyahRef(surah, ayah) only.
- Licenses verified and recorded in NOTICE.md.
- No build artifacts committed.

## Roadmap (Phased)
### Phase 0 — Project Audit + Licensing (Now)
- [x] Audit current architecture (BLoC/Cubit + get_it + assets + SQLite helper).
- [x] Identify existing data sources and placeholder assets.
- [x] Replace placeholder data with licensed datasets.
- [x] Add NOTICE.md with sources and licenses.

### Phase 1 — Offline Core + FTS Search (Now)
- [x] Build offline Quran core: SQLite tables for surah/ayah/text + FTS5 index.
- [x] Import Tanzil Uthmani text into assets and initialize DB on first run.
- [x] Add translation pack (Tanzil translations — non‑commercial) and map AyahRef.
- [x] Provide search API over FTS (Arabic normalized) + UI wiring.
- [ ] Unit tests: lookup 1:1, 2:255, 3:1 + FTS search baseline.

### Phase 2 — Priority User Features (After Phase 1)
- [ ] “My Library” hub: bookmarks, notes, highlights, packs (mushaf/tafsir/translation/books).
- [ ] Long‑press Ayah menu: copy/share/note/highlight/bookmark/audio/tafsir/translation.
- [ ] Wird/Planner: weekly tracking + stats + reminders.
- [ ] Settings: reading layout, font sizes, theme, language, display options.
- [ ] Topic‑based coloring in text mode (pack‑driven).

### Phase 3 — Utilities (Optional Module)
- [ ] Prayer times, Qibla, adhkar (licensed datasets), notifications.

### Phase 4 — Audio (Online/Offline)
- [ ] Reader list + recitation packs + downloader + cache manager.
- [ ] Verse‑by‑verse playback + auto‑scroll + repeat + sleep timer.

### Phase 5 — Tafsir Packs
- [ ] License‑approved tafsir datasets.
- [ ] Tafsir repository + use cases + UI tab.

### Phase 6 — Tajweed
- [ ] Tajweed rules dataset (spans by AyahRef).
- [ ] Highlight rendering in text mode.

### Phase 7 — AI Tadabbur
- [ ] Configurable provider (OpenAI/Gemini/local later) with citations from local sources only.
- [ ] Cache by (AyahRef + model + promptVersion).

### Phase 8 — UI/UX Polish
- [ ] Theme refinement, motion transitions, unified empty/error/loading states.
- [ ] Accessibility/contrast checks (Arabic typography focus).

## Technical Decisions (Current)
- DB: SQLite (sqflite) + FTS5 for search.
- Assets: Tanzil Uthmani text (CC BY 3.0; no modifications) + Tanzil translations (non‑commercial).
- Surah metadata: quranjson (MIT).

## Known Blockers (License‑bound)
- Full audio packs, mushaf page images, tafsir datasets: require explicit licenses.
- Topic‑classification and bounding‑box datasets: require explicit licenses.
