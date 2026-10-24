"""Turkish-aware text folding for search keys.

Search keys are folded in Python during ingestion rather than with database collations, so
results don't depend on the server locale. Folding is lossy on purpose: "Halkapınar",
"HALKAPINAR" and "halkapinar" all map to "halkapinar".
"""

from __future__ import annotations

import re
import unicodedata

# Turkish casing must be handled before generic lowercasing: "I".lower() is "i" in Python,
# but in Turkish "I" is the capital of "ı".
_TR_UPPER = str.maketrans({"I": "ı", "İ": "i"})
_FOLD = str.maketrans(
    {"ç": "c", "ğ": "g", "ı": "i", "ö": "o", "ş": "s", "ü": "u", "â": "a", "î": "i", "û": "u"}
)
_NON_ALNUM = re.compile(r"[^a-z0-9]+")


def tr_lower(text: str) -> str:
    """Lowercase using Turkish rules (I→ı, İ→i)."""
    return text.translate(_TR_UPPER).lower()


def fold(text: str) -> str:
    """Return an ASCII search key: Turkish-lowercased, diacritics removed, punctuation → space."""
    lowered = tr_lower(text).translate(_FOLD)
    decomposed = unicodedata.normalize("NFKD", lowered)
    ascii_only = "".join(c for c in decomposed if not unicodedata.combining(c))
    return _NON_ALNUM.sub(" ", ascii_only).strip()
