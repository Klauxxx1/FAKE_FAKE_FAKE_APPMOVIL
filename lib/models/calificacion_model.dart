class MateriaCalificacion {
  final String nombreMateria;
  final String nombreProfesor;
  final String nombreCurso;
  final double rendimientoAcademicoReal;
  final double rendimientoAcademicoEstimado;
  final List<Asistencia> asistencias;
  final List<Participacion> participaciones;
  final EvaluacionLegal evaluacionLegal;

  MateriaCalificacion({
    required this.nombreMateria,
    required this.nombreProfesor,
    required this.nombreCurso,
    required this.rendimientoAcademicoReal,
    required this.rendimientoAcademicoEstimado,
    required this.asistencias,
    required this.participaciones,
    required this.evaluacionLegal,
  });

  factory MateriaCalificacion.fromJson(Map<String, dynamic> json) {
    return MateriaCalificacion(
      nombreMateria: json['nombre_materia'] ?? '',
      nombreProfesor: json['nombre_profesor'] ?? '',
      nombreCurso: json['nombre_curso'] ?? '',
      rendimientoAcademicoReal:
          json['rendimiento_academico_real']?.toDouble() ?? 0.0,
      rendimientoAcademicoEstimado:
          json['rendimiento_academico_estimado']?.toDouble() ?? 0.0,
      asistencias:
          (json['asistencias'] as List<dynamic>?)
              ?.map((a) => Asistencia.fromJson(a))
              .toList() ??
          [],
      participaciones:
          (json['participaciones'] as List<dynamic>?)
              ?.map((p) => Participacion.fromJson(p))
              .toList() ??
          [],
      evaluacionLegal: EvaluacionLegal.fromJson(json['evaluacion_legal'] ?? {}),
    );
  }
}

class Asistencia {
  final int id;
  final String fecha;
  final String tipo;
  final String observaciones;
  final int inscripcionTrimestre;

  Asistencia({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.observaciones,
    required this.inscripcionTrimestre,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json['id'] ?? 0,
      fecha: json['fecha'] ?? '',
      tipo: json['tipo'] ?? '',
      observaciones: json['observaciones'] ?? '',
      inscripcionTrimestre: json['inscripcion_trimestre'] ?? 0,
    );
  }
}

class Participacion {
  final int id;
  final bool participo;
  final String fecha;
  final int inscripcionTrimestre;

  Participacion({
    required this.id,
    required this.participo,
    required this.fecha,
    required this.inscripcionTrimestre,
  });

  factory Participacion.fromJson(Map<String, dynamic> json) {
    return Participacion(
      id: json['id'] ?? 0,
      participo: json['participo'] ?? false,
      fecha: json['fecha'] ?? '',
      inscripcionTrimestre: json['inscripcion_trimestre'] ?? 0,
    );
  }
}

class EvaluacionLegal {
  final int id;
  final String notaSaberEvaluacionProfesor;
  final String notaHacerEvaluacionProfesor;
  final String notaSerEvaluacionProfesor;
  final String notaDecidirEvaluacionProfesor;
  final String notaEvaluacionProfesor;
  final String notaSerEvaluacionEstudiante;
  final String notaDecidirEvaluacionEstudiante;
  final String notaEvaluacionEstudiante;
  final String notaEvaluacionLegal;
  final int inscripcionTrimestre;

  EvaluacionLegal({
    required this.id,
    required this.notaSaberEvaluacionProfesor,
    required this.notaHacerEvaluacionProfesor,
    required this.notaSerEvaluacionProfesor,
    required this.notaDecidirEvaluacionProfesor,
    required this.notaEvaluacionProfesor,
    required this.notaSerEvaluacionEstudiante,
    required this.notaDecidirEvaluacionEstudiante,
    required this.notaEvaluacionEstudiante,
    required this.notaEvaluacionLegal,
    required this.inscripcionTrimestre,
  });

  factory EvaluacionLegal.fromJson(Map<String, dynamic> json) {
    return EvaluacionLegal(
      id: json['id'] ?? 0,
      notaSaberEvaluacionProfesor:
          json['nota_saber_evaluacion_profesor'] ?? '0',
      notaHacerEvaluacionProfesor:
          json['nota_hacer_evaluacion_profesor'] ?? '0',
      notaSerEvaluacionProfesor: json['nota_ser_evaluacion_profesor'] ?? '0',
      notaDecidirEvaluacionProfesor:
          json['nota_decidir_evaluacion_profesor'] ?? '0',
      notaEvaluacionProfesor: json['nota_evaluacion_profesor'] ?? '0',
      notaSerEvaluacionEstudiante:
          json['nota_ser_evaluacion_estudiante'] ?? '0',
      notaDecidirEvaluacionEstudiante:
          json['nota_decidir_evaluacion_estudiante'] ?? '0',
      notaEvaluacionEstudiante: json['nota_evaluacion_estudiante'] ?? '0',
      notaEvaluacionLegal: json['nota_evaluacion_legal'] ?? '0',
      inscripcionTrimestre: json['inscripcion_trimestre'] ?? 0,
    );
  }
}
