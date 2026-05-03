enum BusLandmark {
  kameda(label: '亀田支所'),
  goryokaku(label: '五稜郭方面'),
  syowa(label: '昭和方面'),
  other;

  const BusLandmark({this.label});

  final String? label;
}
