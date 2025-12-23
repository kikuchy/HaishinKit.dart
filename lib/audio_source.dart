class AudioSource {
  final String id;
  final String? name;

  AudioSource({
    required this.id,
    this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioSource &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'AudioSource{id: $id, name: $name}';
  }

  AudioSource copyWith({
    String? id,
    String? name,
  }) {
    return AudioSource(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory AudioSource.fromMap(Map<String, dynamic> map) {
    return AudioSource(
      id: map['id'] as String,
      name: map['name'] as String?,
    );
  }
}
