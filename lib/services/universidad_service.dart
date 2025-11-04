import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad_model.dart';

class UniversidadService {
  final CollectionReference _universidadesCollection =
      FirebaseFirestore.instance.collection('universidades');

  // Crear una nueva universidad
  Future<String> crearUniversidad(UniversidadModel universidad) async {
    try {
      final docRef = await _universidadesCollection.add(
        universidad.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear universidad: $e');
    }
  }

  // Obtener todas las universidades (stream en tiempo real)
  Stream<List<UniversidadModel>> obtenerUniversidades() {
    return _universidadesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return UniversidadModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      },
    );
  }

  // Obtener una universidad por ID
  Future<UniversidadModel?> obtenerUniversidadPorId(String id) async {
    try {
      final doc = await _universidadesCollection.doc(id).get();
      if (doc.exists) {
        return UniversidadModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener universidad: $e');
    }
  }

  // Actualizar una universidad
  Future<void> actualizarUniversidad(
    String id,
    UniversidadModel universidad,
  ) async {
    try {
      await _universidadesCollection.doc(id).update(
        universidad.toFirestore(),
      );
    } catch (e) {
      throw Exception('Error al actualizar universidad: $e');
    }
  }

  // Eliminar una universidad
  Future<void> eliminarUniversidad(String id) async {
    try {
      await _universidadesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar universidad: $e');
    }
  }
}
