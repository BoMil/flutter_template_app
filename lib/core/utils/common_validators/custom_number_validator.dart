class CustomNumberValidator {
  static String? validateNumber({String? price, required String emptyErrMsg, required String validationMsg}) {
    if (price == null || price.isEmpty) {
      return emptyErrMsg;
    }
// ✅ Dozvoljeno: Brojevi, zarez i tacka ali da nisu na kraju ili pocetku stringa
// ❌ Nije dozvoljeno: Bilo koje slovo (malo ili veliko), specijalni karakteri osim zareza i tacke i razmaci
    if (!RegExp(r'^(?![.,])\d+(?:[.,]\d+)*(?![.,])$').hasMatch(price)) {
      return validationMsg;
    }

    return null;
  }

  static String? validateElectricitySupply(
      {String? value, required String emptyErrMsg, required String validationMsg}) {
    if (value == null || value.isEmpty) {
      return emptyErrMsg;
    }
// ✅ Dozvoljeno: Brojevi izmedju 0 - 24, zarez i tacka ali da nisu na kraju ili pocetku stringa
// ❌ Nije dozvoljeno: Bilo koje slovo (malo ili veliko), specijalni karakteri osim zareza i tacke i razmaci
    if (!RegExp(r'^(?![.,])(?:1[0-9]|2[0-4]|[0-9])(?:[.,]\d+)?(?![.,])$').hasMatch(value)) {
      return validationMsg;
    }

    return null;
  }
}
