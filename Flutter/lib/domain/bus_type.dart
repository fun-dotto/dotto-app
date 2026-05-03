enum BusType {
  kameda(label: '亀田支所'),
  goryokaku(label: '五稜郭方面'),
  syowa(label: '昭和方面'),
  other;

  const BusType({this.label});

  final String? label;
}
