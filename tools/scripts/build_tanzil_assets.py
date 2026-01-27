import json
from pathlib import Path
from urllib.request import urlopen, Request

ROOT = Path(__file__).resolve().parents[2]
ASSETS_DIR = ROOT / 'assets' / 'data'

TANZIL_TEXT_URL = 'https://tanzil.net/pub/download/v1.0/download.php'
TANZIL_TEXT_PAYLOAD = 'quranType=uthmani&outType=txt-2&agree=true&marks=true&sajdah=true'

TRANSLATIONS = {
    'en': 'https://tanzil.net/trans/en.pickthall',
    'ar': 'https://tanzil.net/trans/ar.muyassar',
}

SURAH_META_URL = 'https://raw.githubusercontent.com/semarketir/quranjson/master/source/surah.json'


def _fetch_text(url: str, post_data: bytes | None = None) -> str:
    headers = {'User-Agent': 'QuranAppBuildScript/1.0'}
    req = Request(url, data=post_data, headers=headers)
    with urlopen(req) as resp:
        return resp.read().decode('utf-8')


def _load_surah_meta() -> dict[int, dict]:
    raw = _fetch_text(SURAH_META_URL)
    meta = json.loads(raw)
    surah_map: dict[int, dict] = {}
    for item in meta:
        index = int(item['index'])
        surah_map[index] = {
            'surah': index,
            'name_ar': item.get('titleAr', '').strip(),
            'name_en': item.get('title', '').strip(),
            'ayah_count': int(item.get('count', 0)),
            'revelation': item.get('type', '').strip(),
        }
    return surah_map


def _build_quran_text(surah_map: dict[int, dict]) -> list[dict]:
    payload = TANZIL_TEXT_PAYLOAD.encode('utf-8')
    raw = _fetch_text(TANZIL_TEXT_URL, post_data=payload)
    lines = [line for line in raw.splitlines() if line.strip()]
    result = []
    for line in lines:
        parts = line.split('|', 2)
        if len(parts) != 3:
            continue
        surah = int(parts[0])
        ayah = int(parts[1])
        text = parts[2]
        meta = surah_map.get(surah, {})
        result.append({
            'surah': surah,
            'ayah': ayah,
            'surahName': {
                'ar': meta.get('name_ar', ''),
                'en': meta.get('name_en', ''),
            },
            'text': text,
        })
    return result


def _build_translation(url: str) -> list[dict]:
    raw = _fetch_text(url)
    items = []
    for line in raw.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split('|', 2)
        if len(parts) != 3:
            continue
        surah = int(parts[0])
        ayah = int(parts[1])
        text = parts[2]
        items.append({'surah': surah, 'ayah': ayah, 'text': text})
    return items


def main() -> None:
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)

    surah_map = _load_surah_meta()
    quran_text = _build_quran_text(surah_map)
    (ASSETS_DIR / 'quran_text.json').write_text(
        json.dumps(quran_text, ensure_ascii=False, indent=2),
        encoding='utf-8',
    )

    (ASSETS_DIR / 'surah_meta.json').write_text(
        json.dumps(list(surah_map.values()), ensure_ascii=False, indent=2),
        encoding='utf-8',
    )

    for lang, url in TRANSLATIONS.items():
        translations = _build_translation(url)
        target = ASSETS_DIR / 'translations' / f'{lang}.json'
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(
            json.dumps(translations, ensure_ascii=False, indent=2),
            encoding='utf-8',
        )

    print('Assets generated:', ASSETS_DIR)


if __name__ == '__main__':
    main()
