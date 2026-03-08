import json
import re
import time
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[2]
ASSETS_DIR = ROOT / 'assets' / 'data'
META_PATH = ASSETS_DIR / 'surah_meta.json'
OUT_PATH = ASSETS_DIR / 'surah_summaries.json'
ATTR_PATH = ASSETS_DIR / 'surah_summaries_attribution.json'

WIKI_API = 'https://ar.wikipedia.org/w/api.php'
USER_AGENT = 'QuranAppSummaries/1.0 (local generation)'
MAX_CHARS = 800


def _fetch_summary(title: str) -> tuple[str, dict]:
    params = {
        'action': 'query',
        'prop': 'extracts|info',
        'exintro': '1',
        'explaintext': '1',
        'redirects': '1',
        'inprop': 'url',
        'format': 'json',
        'formatversion': '2',
        'titles': title,
    }
    url = f'{WIKI_API}?{urlencode(params)}'
    req = Request(url, headers={'User-Agent': USER_AGENT})
    with urlopen(req, timeout=20) as resp:
        payload = json.loads(resp.read().decode('utf-8'))
    pages = payload.get('query', {}).get('pages', [])
    if not pages:
        return '', {}
    page = pages[0]
    extract = (page.get('extract') or '').strip()
    meta = {
        'title': page.get('title') or title,
        'pageId': page.get('pageid'),
        'revId': page.get('lastrevid'),
        'url': page.get('fullurl'),
    }
    return extract, meta


def _clean_text(text: str) -> str:
    if not text:
        return ''
    cleaned = re.sub(r'\[\d+\]', '', text)
    cleaned = re.sub(r'\s+', ' ', cleaned).strip()
    if len(cleaned) <= MAX_CHARS:
        return cleaned
    cutoff = cleaned[:MAX_CHARS]
    for marker in ['.', '؟', '!', '؛']:
        idx = cutoff.rfind(marker)
        if idx > 200:
            return cutoff[: idx + 1].strip()
    return cutoff.strip()


def main() -> None:
    if not META_PATH.exists():
        raise SystemExit(f'Missing {META_PATH}')
    meta = json.loads(META_PATH.read_text(encoding='utf-8'))
    if not isinstance(meta, list):
        raise SystemExit('surah_meta.json must be a list')

    summaries: dict[int, str] = {}
    sources: dict[int, dict] = {}
    for item in meta:
        surah = int(item.get('surah') or 0)
        name_ar = (item.get('name_ar') or '').strip()
        if surah <= 0 or not name_ar:
            continue
        title = f'سورة {name_ar}'
        summary, info = _fetch_summary(title)
        if not summary:
            summary, info = _fetch_summary(name_ar)
        summaries[surah] = _clean_text(summary)
        sources[surah] = {
            'title': info.get('title') or title,
            'url': info.get('url'),
            'pageId': info.get('pageId'),
            'revId': info.get('revId'),
        }
        time.sleep(0.3)

    OUT_PATH.write_text(
        json.dumps(
            {str(k): v for k, v in summaries.items()},
            ensure_ascii=True,
            indent=2,
        ),
        encoding='utf-8',
    )

    attribution = {
        'source': 'ar.wikipedia.org',
        'license': 'CC BY-SA 4.0',
        'generatedAtUtc': datetime.now(timezone.utc).isoformat(),
        'items': {str(k): v for k, v in sources.items()},
    }
    ATTR_PATH.write_text(
        json.dumps(attribution, ensure_ascii=True, indent=2),
        encoding='utf-8',
    )
    print('Wrote summaries to', OUT_PATH)
    print('Wrote attribution to', ATTR_PATH)


if __name__ == '__main__':
    main()
