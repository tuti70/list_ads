import 'dart:io';

class Ads {
  int? id;
  late String titulo;
  late String text;
  late double preco;
  bool done = true;
  File? image;

  Ads(
      {int? id,
      required String titulo,
      required String text,
      required double preco,
      File? image});

  Ads.fromMap(Map map) {
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.text = map['text'];
    this.preco = map['preco']; // Adicionado
    this.done = map['done'] == 1 ? true : false; // SQL não salva booleano
    this.image = map['imagePath'] != '' ? File(map['imagePath']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'titulo': this.titulo,
      'text': this.text,
      'preco': this.preco, // Adicionado
      'done': this.done,
      'imagePath': this.image != null ? this.image!.path : ''
    };
    return map;
  }

  @override
  String toString() {
    return "Ads(id: $id, titulo: $titulo, text: $text, preco: $preco, done: $done, image: $image)";
  }
}
