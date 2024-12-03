import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_ad/todo.dart';
import 'package:path_provider/path_provider.dart';

class CadastroScreen extends StatefulWidget {
  final Ads? ads;
  const CadastroScreen({super.key, this.ads});

  @override
  State<CadastroScreen> createState() => _CadastroScreen();
}

class _CadastroScreen extends State<CadastroScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Ads? ads;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.ads != null) {
      setState(() {
        _tituloController.text = widget.ads!.titulo;
        _textController.text = widget.ads!.texto;
        _image = widget.ads!.image;
        ads = widget.ads;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.app_registration),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Cadastro de terefa",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 90)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _image!,
                          width: 200,
                          height: 113,
                          fit: BoxFit.cover,
                        ),
                      )),
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                File image = File(pickedFile.path);
                Directory directory = await getApplicationDocumentsDirectory();
                String _localPath = directory.path;

                String uniqueID = UniqueKey().toString();
                final File savedImage =
                    await image.copy('$_localPath/image_$uniqueID.png');

                setState(() {
                  _image = savedImage;
                });
              }
              // final ImagePicker _picker = ImagePicker();
              // final XFile? pickedFile =
              //     await _picker.pickImage(source: ImageSource.camera);
              // if (pickedFile != null) {
              //   setState(() {
              //     _image = File(pickedFile.path);
              //   });
              // }
            },
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 2.5),
                  child: Card(
                    color: const Color.fromARGB(255, 73, 73, 73),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                      child: TextFormField(
                        controller: _textController,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: "Titulo",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 226, 225, 225),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 226, 225, 225),
                          )),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Prenchimento Obrigatório";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  child: Card(
                    color: const Color.fromARGB(255, 73, 73, 73),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                      child: TextFormField(
                        controller: _tituloController,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: "Descrição",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 226, 225, 225),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 226, 225, 225),
                          )),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Prenchimento Obrigatório";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  Ads newads = Ads(_textController.text,
                                      _tituloController.text, _image);
                                  Navigator.pop(context, newads);
                                }
                              },
                              child: Text(
                                ads != null ? "Editar" : "Cadastrar",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.pop(context, "/");
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
