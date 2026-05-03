enum BusLandmark {
  kameda(label: '亀田支所'),
  goryokaku(label: '五稜郭'),
  syowa(label: '昭和'),
  other;

  const BusLandmark({this.label});

  final String? label;
}
