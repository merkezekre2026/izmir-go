import pytest

from izmirgo.domain.ids import InvalidId, is_nsid, nsid, split
from izmirgo.domain.search_text import fold, tr_lower


def test_nsid_roundtrip() -> None:
    assert nsid("metro", " 6 ") == "metro:6"
    assert split("eshot:10005") == ("eshot", "10005")
    assert is_nsid("stn:halkapinar")
    assert not is_nsid("halkapinar")


@pytest.mark.parametrize("bad", ["", "  ", "a b"])
def test_nsid_rejects_bad_raw(bad: str) -> None:
    with pytest.raises(InvalidId):
        nsid("metro", bad)


def test_nsid_rejects_bad_namespace() -> None:
    with pytest.raises(InvalidId):
        nsid("Metro!", "1")


def test_turkish_lowercase() -> None:
    assert tr_lower("IŞIK") == "ışık"
    assert tr_lower("İZBAN") == "izban"


@pytest.mark.parametrize(
    ("text", "key"),
    [
        ("Halkapınar", "halkapinar"),
        ("HALKAPINAR", "halkapinar"),
        ("Çiğli Tramvayı İç Hat (Mavi)", "cigli tramvayi ic hat mavi"),
        ("Üçkuyular İskele", "uckuyular iskele"),
        ("Evka - 3", "evka 3"),
        ("ŞEHİT ÖZDEMİR", "sehit ozdemir"),
    ],
)
def test_fold(text: str, key: str) -> None:
    assert fold(text) == key
