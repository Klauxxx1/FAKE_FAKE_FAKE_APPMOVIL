class Participacion {
  final int id;
  final int inscripcionTrimestreId;
  final bool participo;
  final String fecha;

  Participacion({
    required this.id,
    required this.inscripcionTrimestreId,
    required this.participo,
    required this.fecha,
  });

  factory Participacion.fromJson(Map<String, dynamic> json) {
    return Participacion(
      id: json['id'],
      inscripcionTrimestreId: json['inscripcion_trimestre_id'],
      participo: json['participo'] == 1 || json['participo'] == true,
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inscripcion_trimestre_id': inscripcionTrimestreId,
      'participo': participo ? 1 : 0,
      'fecha': fecha,
    };
  }
}
