class Multa {
  final String codigoMarbete;
  final String marca;
  final String modelo;
  final String color;
  final int anio; // Ensure this is 'anio' to match the API
  final String placa;
  final String chasis; // New field for the chassis number
  final String tipoInfraccion;
  final String ubicacionGPS;
  final DateTime fechaHora;
  final String descripcion;
  final List<String> fotos;
  final String audioPath;

  Multa({
    required this.codigoMarbete,
    required this.marca,
    required this.modelo,
    required this.color,
    required this.anio,
    required this.placa,
    required this.chasis, // Include the chassis number
    required this.tipoInfraccion,
    required this.ubicacionGPS,
    required this.fechaHora,
    required this.descripcion,
    required this.fotos,
    required this.audioPath,
  });

  // Convert Multa object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'codigoMarbete': codigoMarbete,
      'marca': marca,
      'modelo': modelo,
      'color': color,
      'anio': anio,
      'placa': placa,
      'chasis': chasis, // Include the chassis number
      'tipoInfraccion': tipoInfraccion,
      'ubicacionGPS': ubicacionGPS,
      'fechaHora': fechaHora.toIso8601String(),
      'descripcion': descripcion,
      'fotos': fotos,
      'audioPath': audioPath,
    };
  }

  // Create a Multa object from a map retrieved from the database
  factory Multa.fromMap(Map<String, dynamic> map) {
    return Multa(
      codigoMarbete: map['codigoMarbete'],
      marca: map['marca'],
      modelo: map['modelo'],
      color: map['color'],
      anio: map['anio'],
      placa: map['placa'],
      chasis: map['chasis'], // Include the chassis number
      tipoInfraccion: map['tipoInfraccion'],
      ubicacionGPS: map['ubicacionGPS'],
      fechaHora: DateTime.parse(map['fechaHora']),
      descripcion: map['descripcion'],
      fotos: List<String>.from(map['fotos']),
      audioPath: map['audioPath'],
    );
  }
}
