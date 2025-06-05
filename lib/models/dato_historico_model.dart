class DatoHistorico {
  final String gestion;
  final double promedioNotaEvaluacionLegal;
  final double promedioNotaAsistencia;
  final double promedioNotaParticipacion;
  final double promedioRendimientoAcademicoReal;
  final double promedioRendimientoAcademicoEstimado;

  DatoHistorico({
    required this.gestion,
    required this.promedioNotaEvaluacionLegal,
    required this.promedioNotaAsistencia,
    required this.promedioNotaParticipacion,
    required this.promedioRendimientoAcademicoReal,
    required this.promedioRendimientoAcademicoEstimado,
  });

  factory DatoHistorico.fromJson(Map<String, dynamic> json) {
    return DatoHistorico(
      gestion: json['gestion'] ?? '',
      promedioNotaEvaluacionLegal:
          (json['promedio_nota_evaluacion_legal'] ?? 0.0).toDouble(),
      promedioNotaAsistencia:
          (json['promedio_nota_asistencia'] ?? 0.0).toDouble(),
      promedioNotaParticipacion:
          (json['promedio_nota_participacion'] ?? 0.0).toDouble(),
      promedioRendimientoAcademicoReal:
          (json['promedio_rendimiento_academico_real'] ?? 0.0).toDouble(),
      promedioRendimientoAcademicoEstimado:
          (json['promedio_rendimiento_academico_estimado'] ?? 0.0).toDouble(),
    );
  }

  // Helper para obtener el año y trimestre formateados
  String getGestionFormateada() {
    // Formato ejemplo: "2023-T1"
    List<String> partes = gestion.split('-');
    if (partes.length >= 2) {
      String anio = partes[0];
      String trimestre = partes[1].replaceAll('T', '');
      return '$anio - Trimestre $trimestre';
    }
    return gestion;
  }
}
