class LocalizedValue<T> {
  final T en;
  final T hi;
  final T mr;
  LocalizedValue({
    required this.en,
    required this.hi,
    required this.mr
  });

  factory LocalizedValue.fromJson(Map<String, dynamic> json) {
    return LocalizedValue<T>(
      en: json['en'],
      hi: json['hi'],
      mr:json['mr']
    );
  }
   Map<String, dynamic> toJson() => {
        "en": en,
        "hi": hi,
        "mr":mr
    };
}