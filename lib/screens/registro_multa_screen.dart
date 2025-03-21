import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../providers/multa_provider.dart';
import '../models/multa.dart';

class RegistroMultaScreen extends StatefulWidget {
  @override
  _RegistroMultaScreenState createState() => _RegistroMultaScreenState();
}

class _RegistroMultaScreenState extends State<RegistroMultaScreen> {
  CameraController? _cameraController;
  FlutterSoundRecorder? _recorder;
  List<String> _fotos = [];
  String _audioPath = '';
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _inicializarCamara();
    _recorder = FlutterSoundRecorder();
    _inicializarGrabadora();
  }

  Future<void> _inicializarCamara() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print("Error al inicializar la cámara: $e");
    }
  }

  Future<void> _inicializarGrabadora() async {
    try {
      await _recorder!.openRecorder();
    } catch (e) {
      print("Error al inicializar la grabadora: $e");
    }
  }

  Future<void> _tomarFoto(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final foto = await _cameraController!.takePicture();
      setState(() {
        _fotos.add(foto.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto: $e')),
      );
    }
  }

  Future<void> _grabarAudio() async {
    if (_recorder == null) return;
    if (_isRecording) {
      try {
        final path = await _recorder!.stopRecorder();
        setState(() {
          _isRecording = false;
          _audioPath = path!;
        });
      } catch (e) {
        print("Error al detener la grabación: $e");
      }
    } else {
      try {
        final dir = await getTemporaryDirectory();
        final path = join(dir.path, 'audio.mp3');
        await _recorder!.startRecorder(toFile: path, codec: Codec.aacADTS);
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print("Error al iniciar la grabación: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _codigoMarbeteController = TextEditingController();
  final _descripcionController = TextEditingController();
  String? _infraccionSeleccionada;
  DateTime? _fechaEmision;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _fechaEmision = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final multaProvider = Provider.of<MultaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Registrar Multa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codigoMarbeteController,
                decoration: InputDecoration(labelText: 'Código de Marbete'),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_codigoMarbeteController.text.isNotEmpty) {
                    try {
                      await multaProvider.buscarDatosVehiculo(_codigoMarbeteController.text);
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text('Buscar Vehículo'),
              ),
              if (multaProvider.marcaVehiculo.isNotEmpty) ...[
                Text('Marca: ${multaProvider.marcaVehiculo}'),
                Text('Modelo: ${multaProvider.modeloVehiculo}'),
                Text('Color: ${multaProvider.colorVehiculo}'),
                Text('Año: ${multaProvider.anioVehiculo}'),
                Text('Placa: ${multaProvider.placaVehiculo}'),
                Text('Chasis: ${multaProvider.chasisVehiculo}'),
              ],
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _infraccionSeleccionada,
                decoration: InputDecoration(labelText: 'Tipo de Infracción'),
                items: multaProvider.infracciones.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                onChanged: (value) => setState(() => _infraccionSeleccionada = value),
                validator: (value) => value == null ? 'Seleccione una infracción' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción de la Multa'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _fechaEmision == null
                        ? 'Fecha de Emisión: No seleccionada'
                        : 'Fecha de Emisión: ${_fechaEmision!.toLocal().toString().split(' ')[0]}',
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _seleccionarFecha(context),
                    child: Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _tomarFoto(context),
                child: Text('Tomar Foto'),
              ),
              Wrap(
                children: _fotos.map((foto) => Image.file(File(foto), width: 100, height: 100)).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _grabarAudio,
                child: Text(_isRecording ? 'Detener Grabación' : 'Grabar Audio'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final multa = Multa(
                      codigoMarbete: _codigoMarbeteController.text,
                      marca: multaProvider.marcaVehiculo,
                      modelo: multaProvider.modeloVehiculo,
                      color: multaProvider.colorVehiculo,
                      anio: multaProvider.anioVehiculo,
                      placa: multaProvider.placaVehiculo,
                      chasis: multaProvider.chasisVehiculo,
                      tipoInfraccion: _infraccionSeleccionada!,
                      ubicacionGPS: '', // Obtener con GPS (opcional)
                      fechaHora: _fechaEmision ?? DateTime.now(),
                      descripcion: _descripcionController.text,
                      fotos: _fotos,
                      audioPath: _audioPath,
                    );
                    await multaProvider.agregarMulta(multa);
                    Navigator.pop(context);
                  }
                },
                child: Text('Registrar Multa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
