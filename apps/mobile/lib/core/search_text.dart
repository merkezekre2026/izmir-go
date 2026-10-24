/// Turkish-aware search folding. Mirrors backend `izmirgo.domain.search_text.fold`
/// so offline search matches online search.
const _upper = {'I': 'ı', 'İ': 'i'};
const _fold = {
  'ç': 'c',
  'ğ': 'g',
  'ı': 'i',
  'ö': 'o',
  'ş': 's',
  'ü': 'u',
  'â': 'a',
  'î': 'i',
  'û': 'u', //
};
final _nonAlnum = RegExp('[^a-z0-9]+');

String trLower(String text) {
  final buf = StringBuffer();
  for (final rune in text.runes) {
    final ch = String.fromCharCode(rune);
    buf.write(_upper[ch] ?? ch.toLowerCase());
  }
  return buf.toString();
}

String fold(String text) {
  final buf = StringBuffer();
  for (final rune in trLower(text).runes) {
    final ch = String.fromCharCode(rune);
    buf.write(_fold[ch] ?? ch);
  }
  return buf.toString().replaceAll(_nonAlnum, ' ').trim();
}
