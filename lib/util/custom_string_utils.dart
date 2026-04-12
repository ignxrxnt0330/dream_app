import 'dart:math';

extension CustomStringUtils on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËĚèéêëěðČÇçčÐĎďÌÍÎÏìíîïĽľÙÚÛÜŮùúûüůŇňŘřŠšŤťŸÝÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEEeeeeeeCCccDDdIIIIiiiiLlUUUUUuuuuuNnRrSsTtYYyyZz';

  String get normalize => splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);

  static double _getEditDistanceRecursive(String s1, String s2, int m, int n) {
    if (m == 0) return n.toDouble();
    if (n == 0) return m.toDouble();

    if (s1[m - 1] == s2[n - 1]) {
      return _getEditDistanceRecursive(s1, s2, m - 1, n - 1);
    }

    return 1 +
        min(
            _getEditDistanceRecursive(s1, s2, m, n - 1),
            min(_getEditDistanceRecursive(s1, s2, m - 1, n),
                _getEditDistanceRecursive(s1, s2, m - 1, n - 1)));
  }

  static double getEditDistance(String s1, String s2) =>
      _getEditDistanceRecursive(s1, s2, s1.length, s2.length);
}
