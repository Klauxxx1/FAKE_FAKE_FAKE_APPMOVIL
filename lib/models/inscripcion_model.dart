class Inscripcion {
  final int id;
  final int cursoId;
  final int estudianteId;
  final int profesorId;
  final int materiaId;
  final String gestionAcademicaAnual;
  final double notaEvaluacionLegal;
  final double notaAsistencia;
  final double notaParticipacion;
  final double rendimientoAcademicoReal;
  final double rendimientoAcademicoEstimado;

  Inscripcion({
    required this.id,
    required this.cursoId,
    required this.estudianteId,
    required this.profesorId,
    required this.materiaId,
    required this.gestionAcademicaAnual,
    required this.notaEvaluacionLegal,
    required this.notaAsistencia,
    required this.notaParticipacion,
    required this.rendimientoAcademicoReal,
    required this.rendimientoAcademicoEstimado,
  });

  factory Inscripcion.fromJson(Map<String, dynamic> json) {
    return Inscripcion(
      id: json['id'],
      cursoId: json['curso_id'],
      estudianteId: json['estudiante_id'],
      profesorId: json['profesor_id'],
      materiaId: json['materia_id'],
      gestionAcademicaAnual: json['gestion_academica_anual'],
      notaEvaluacionLegal: json['nota_evaluacion_legal']?.toDouble() ?? 0.0,
      notaAsistencia: json['nota_asistencia']?.toDouble() ?? 0.0,
      notaParticipacion: json['nota_participacion']?.toDouble() ?? 0.0,
      rendimientoAcademicoReal:
          json['rendimiento_academico_real']?.toDouble() ?? 0.0,
      rendimientoAcademicoEstimado:
          json['rendimiento_academico_estimado']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curso_id': cursoId,
      'estudiante_id': estudianteId,
      'profesor_id': profesorId,
      'materia_id': materiaId,
      'gestion_academica_anual': gestionAcademicaAnual,
      'nota_evaluacion_legal': notaEvaluacionLegal,
      'nota_asistencia': notaAsistencia,
      'nota_participacion': notaParticipacion,
      'rendimiento_academico_real': rendimientoAcademicoReal,
      'rendimiento_academico_estimado': rendimientoAcademicoEstimado,
    };
  }
}

class InscripcionTrimestre {
  final int id;
  final int inscripcionId;
  final String gestionAcademicaTrimestral;
  final double notaEvaluacionLegal;
  final double notaAsistencia;
  final double notaParticipacion;
  final double rendimientoAcademicoReal;
  final double rendimientoAcademicoEstimado;

  InscripcionTrimestre({
    required this.id,
    required this.inscripcionId,
    required this.gestionAcademicaTrimestral,
    required this.notaEvaluacionLegal,
    required this.notaAsistencia,
    required this.notaParticipacion,
    required this.rendimientoAcademicoReal,
    required this.rendimientoAcademicoEstimado,
  });

  factory InscripcionTrimestre.fromJson(Map<String, dynamic> json) {
    return InscripcionTrimestre(
      id: json['id'],
      inscripcionId: json['inscripcion_id'],
      gestionAcademicaTrimestral: json['gestion_academica_trimestral'],
      notaEvaluacionLegal: json['nota_evaluacion_legal']?.toDouble() ?? 0.0,
      notaAsistencia: json['nota_asistencia']?.toDouble() ?? 0.0,
      notaParticipacion: json['nota_participacion']?.toDouble() ?? 0.0,
      rendimientoAcademicoReal:
          json['rendimiento_academico_real']?.toDouble() ?? 0.0,
      rendimientoAcademicoEstimado:
          json['rendimiento_academico_estimado']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inscripcion_id': inscripcionId,
      'gestion_academica_trimestral': gestionAcademicaTrimestral,
      'nota_evaluacion_legal': notaEvaluacionLegal,
      'nota_asistencia': notaAsistencia,
      'nota_participacion': notaParticipacion,
      'rendimiento_academico_real': rendimientoAcademicoReal,
      'rendimiento_academico_estimado': rendimientoAcademicoEstimado,
    };
  }
}
