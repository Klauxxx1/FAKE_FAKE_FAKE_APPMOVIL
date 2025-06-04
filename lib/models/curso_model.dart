class Curso {
  final int id;
  final String nombre;
  final String paralelo;

  Curso({required this.id, required this.nombre, required this.paralelo});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      id: json['id'],
      nombre: json['nombre'],
      paralelo: json['paralelo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'paralelo': paralelo};
  }
}

class CursoMateriaProfesor {
  final int id;
  final int cursoId;
  final int materiaId;
  final int profesorId;
  final String bloque1Inicio;
  final String bloque1Fin;
  final String bloque2Inicio;
  final String bloque2Fin;

  CursoMateriaProfesor({
    required this.id,
    required this.cursoId,
    required this.materiaId,
    required this.profesorId,
    required this.bloque1Inicio,
    required this.bloque1Fin,
    required this.bloque2Inicio,
    required this.bloque2Fin,
  });

  factory CursoMateriaProfesor.fromJson(Map<String, dynamic> json) {
    return CursoMateriaProfesor(
      id: json['id'],
      cursoId: json['curso_id'],
      materiaId: json['materia_id'],
      profesorId: json['profesor_id'],
      bloque1Inicio: json['bloque_1_inicio'],
      bloque1Fin: json['bloque_1_fin'],
      bloque2Inicio: json['bloque_2_inicio'],
      bloque2Fin: json['bloque_2_fin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curso_id': cursoId,
      'materia_id': materiaId,
      'profesor_id': profesorId,
      'bloque_1_inicio': bloque1Inicio,
      'bloque_1_fin': bloque1Fin,
      'bloque_2_inicio': bloque2Inicio,
      'bloque_2_fin': bloque2Fin,
    };
  }
}
