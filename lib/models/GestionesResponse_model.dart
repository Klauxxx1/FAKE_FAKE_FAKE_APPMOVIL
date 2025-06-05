// To parse this JSON data, do
//
//     final gestionesResponse = gestionesResponseFromJson(jsonString);

import 'dart:convert';

List<GestionesResponse> gestionesResponseFromJson(String str) =>
    List<GestionesResponse>.from(
      json.decode(str).map((x) => GestionesResponse.fromJson(x)),
    );

String gestionesResponseToJson(List<GestionesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GestionesResponse {
  String gestion;
  double promedioNotaEvaluacionLegal; // Cambiado de int a double
  double promedioNotaAsistencia; // Cambiado de int a double
  double promedioNotaParticipacion; // Cambiado de int a double
  double promedioRendimientoAcademicoReal;
  double promedioRendimientoAcademicoEstimado;

  GestionesResponse({
    required this.gestion,
    required this.promedioNotaEvaluacionLegal,
    required this.promedioNotaAsistencia,
    required this.promedioNotaParticipacion,
    required this.promedioRendimientoAcademicoReal,
    required this.promedioRendimientoAcademicoEstimado,
  });

  factory GestionesResponse.fromJson(Map<String, dynamic> json) =>
      GestionesResponse(
        gestion: json["gestion"],
        promedioNotaEvaluacionLegal:
            (json["promedio_nota_evaluacion_legal"] as num).toDouble(),
        promedioNotaAsistencia:
            (json["promedio_nota_asistencia"] as num).toDouble(),
        promedioNotaParticipacion:
            (json["promedio_nota_participacion"] as num).toDouble(),
        promedioRendimientoAcademicoReal:
            (json["promedio_rendimiento_academico_real"] as num).toDouble(),
        promedioRendimientoAcademicoEstimado:
            (json["promedio_rendimiento_academico_estimado"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "gestion": gestion,
    "promedio_nota_evaluacion_legal": promedioNotaEvaluacionLegal,
    "promedio_nota_asistencia": promedioNotaAsistencia,
    "promedio_nota_participacion": promedioNotaParticipacion,
    "promedio_rendimiento_academico_real": promedioRendimientoAcademicoReal,
    "promedio_rendimiento_academico_estimado":
        promedioRendimientoAcademicoEstimado,
  };
}
