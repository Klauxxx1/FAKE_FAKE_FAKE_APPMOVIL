/*class EvaluacionLegal {
  final int id;
  final int inscripcionTrimestreId;
  final double notaSaberEvaluacionProfesor;
  final double notaHacerEvaluacionProfesor;
  final double notaSerEvaluacionProfesor;
  final double notaDecidirEvaluacionProfesor;
  final double notaEvaluacionProfesor;
  final double notaSerEvaluacionEstudiante;
  final double notaDecidirEvaluacionEstudiante;
  final double notaEvaluacionEstudiante;
  final double notaEvaluacionLegal;

  EvaluacionLegal({
    required this.id,
    required this.inscripcionTrimestreId,
    required this.notaSaberEvaluacionProfesor,
    required this.notaHacerEvaluacionProfesor,
    required this.notaSerEvaluacionProfesor,
    required this.notaDecidirEvaluacionProfesor,
    required this.notaEvaluacionProfesor,
    required this.notaSerEvaluacionEstudiante,
    required this.notaDecidirEvaluacionEstudiante,
    required this.notaEvaluacionEstudiante,
    required this.notaEvaluacionLegal,
  });

  factory EvaluacionLegal.fromJson(Map<String, dynamic> json) {
    return EvaluacionLegal(
      id: json['id'],
      inscripcionTrimestreId: json['inscripcion_trimestre_id'],
      notaSaberEvaluacionProfesor:
          json['nota_saber_evaluacion_profesor']?.toDouble() ?? 0.0,
      notaHacerEvaluacionProfesor:
          json['nota_hacer_evaluacion_profesor']?.toDouble() ?? 0.0,
      notaSerEvaluacionProfesor:
          json['nota_ser_evaluacion_profesor']?.toDouble() ?? 0.0,
      notaDecidirEvaluacionProfesor:
          json['nota_decidir_evaluacion_profesor']?.toDouble() ?? 0.0,
      notaEvaluacionProfesor:
          json['nota_evaluacion_profesor']?.toDouble() ?? 0.0,
      notaSerEvaluacionEstudiante:
          json['nota_ser_evaluacion_estudiante']?.toDouble() ?? 0.0,
      notaDecidirEvaluacionEstudiante:
          json['nota_decidir_evaluacion_estudiante']?.toDouble() ?? 0.0,
      notaEvaluacionEstudiante:
          json['nota_evaluacion_estudiante']?.toDouble() ?? 0.0,
      notaEvaluacionLegal: json['nota_evaluacion_legal']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inscripcion_trimestre_id': inscripcionTrimestreId,
      'nota_saber_evaluacion_profesor': notaSaberEvaluacionProfesor,
      'nota_hacer_evaluacion_profesor': notaHacerEvaluacionProfesor,
      'nota_ser_evaluacion_profesor': notaSerEvaluacionProfesor,
      'nota_decidir_evaluacion_profesor': notaDecidirEvaluacionProfesor,
      'nota_evaluacion_profesor': notaEvaluacionProfesor,
      'nota_ser_evaluacion_estudiante': notaSerEvaluacionEstudiante,
      'nota_decidir_evaluacion_estudiante': notaDecidirEvaluacionEstudiante,
      'nota_evaluacion_estudiante': notaEvaluacionEstudiante,
      'nota_evaluacion_legal': notaEvaluacionLegal,
    };
  }
}*/
