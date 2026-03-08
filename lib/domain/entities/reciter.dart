class Reciter {
  final String id;
  final String name;
  final String server;

  Reciter({
    required this.id,
    required this.name,
    required this.server,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['identifier'] ?? '',
      name: json['name'] ?? '',
      server: json['Server'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': id,
      'name': name,
      'Server': server,
    };
  }
}
