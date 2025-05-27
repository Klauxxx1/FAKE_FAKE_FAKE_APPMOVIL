class Usuario {
  final int id;
  final String correo;
  final String nombre;
  final String rol;

  Usuario({
    required this.id,
    required this.correo,
    required this.nombre,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      correo: json['correo'],
      nombre: json['nombre'],
      rol: json['rol'],
    );
  }
}

class Estudiante {
  final int id;
  final int usuarioId;
  final String fechaNacimiento;
  final String genero;
  final int cursoId;
  final String nombrePadre;
  final String nombreMadre;
  final String ciTutor;
  final String direccion;
  final String telefono;

  Estudiante({
    required this.id,
    required this.usuarioId,
    required this.fechaNacimiento,
    required this.genero,
    required this.cursoId,
    required this.nombrePadre,
    required this.nombreMadre,
    required this.ciTutor,
    required this.direccion,
    required this.telefono,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      usuarioId: json['usuario_id'],
      fechaNacimiento: json['fecha_nacimiento'],
      genero: json['genero'],
      cursoId: json['curso_id'],
      nombrePadre: json['nombre_padre'],
      nombreMadre: json['nombre_madre'],
      ciTutor: json['ci_tutor'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }
}

class Profesor {
  final int id;
  final int usuarioId;
  final String especialidad;
  final String profesion;
  final String fechaIngreso;
  final int antiguedadAnios;
  final String tipoContrato;
  final String ci;
  final String direccion;
  final String telefono;

  Profesor({
    required this.id,
    required this.usuarioId,
    required this.especialidad,
    required this.profesion,
    required this.fechaIngreso,
    required this.antiguedadAnios,
    required this.tipoContrato,
    required this.ci,
    required this.direccion,
    required this.telefono,
  });

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      id: json['id'],
      usuarioId: json['usuario_id'],
      especialidad: json['especialidad'],
      profesion: json['profesion'],
      fechaIngreso: json['fecha_ingreso'],
      antiguedadAnios: json['antiguedad_anios'],
      tipoContrato: json['tipo_contrato'],
      ci: json['ci'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }
}
