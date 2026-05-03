enum BusType {
  kameda('亀田支所'),
  goryokaku('五稜郭方面'),
  syowa('昭和方面'),
  other('');

  const BusType(this.where);

  final String where;
}
