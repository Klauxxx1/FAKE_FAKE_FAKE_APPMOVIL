class Asistencia {
  final int id;
  final int inscripcionTrimestreId;
  final bool asistio;
  final String fecha;

  Asistencia({
    required this.id,
    required this.inscripcionTrimestreId,
    required this.asistio,
    required this.fecha,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json['id'],
      inscripcionTrimestreId: json['inscripcion_trimestre_id'],
      asistio: json['asistio'] == 1 || json['asistio'] == true,
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inscripcion_trimestre_id': inscripcionTrimestreId,
      'asistio': asistio ? 1 : 0,
      'fecha': fecha,
    };
  }
}
