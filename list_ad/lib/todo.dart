import 'dart:io';

class Ads {
  int? id;
  late String titulo;
  late String texto;
  late String preco;
  bool done = true;
  File? image;

  Ads(this.titulo, this.texto, this.preco, this.image);

  Ads.fromMap(Map map) {
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.texto = map['texto'];
    this.preco = map['preco']; // Adicionado
    this.done = map['done'] == 1 ? true : false; // SQL não salva booleano
    this.image = map['imagePath'] != '' ? File(map['imagePath']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'titulo': this.titulo,
      'texto': this.texto,
      'preco': this.preco, // Adicionado
      'done': this.done,
      'imagePath': this.image != null ? this.image!.path : ''
    };
    return map;
  }

  @override
  String toString() {
    return "Ads(id: $id, titulo: $titulo, texto: $texto, preco: $preco, done: $done, image: $image)";
  }
}





// class Ads {
//   late String titulo;
//   late String descricao;
//   bool done = true;
//   File? image;

//   Ads(this.titulo, this.descricao, this.image);

//   Map toMap() {
//     Map<String, dynamic> map = {
//       'titulo': this.titulo,
//       'descricao': this.descricao,
//       'done': this.done,
//       //'imagePath': this.image == null ? '' : this.image!.path,
//     };
//     return map;
//   }

//   Ads.fromMap(Map map) {
//     this.descricao = map['titulo'];
//     this.descricao = map['descricao'];
//     this.done = map['done'];
//     //this.image = map['imagePath'] == '' ? File(map['imagePath']) : null;
//   }

