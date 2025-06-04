class Materia {
  final int id;
  final String nombre;
  final String descripcion;

  Materia({required this.id, required this.nombre, required this.descripcion});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'descripcion': descripcion};
  }
}
