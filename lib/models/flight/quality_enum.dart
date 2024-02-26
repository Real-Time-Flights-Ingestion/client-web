enum Quality {
  basic,
  live,
  approximate,
  unknown,
}

extension QualityDeserialization on Quality {
  static List<Quality> fromStringList(List<String> list) {
    return list.map((e) {
      return Quality.values.firstWhere(
        (element) => element.name == e.toLowerCase().trim(),
        orElse: () => Quality.unknown,
      );
    }).toList();
  }
}
