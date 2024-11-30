import 'package:flutter/material.dart';
//import 'package:list_ad/file_persistence.dart';
import 'package:list_ad/pages/cadastro_screen.dart';
import 'package:list_ad/todo.dart';
import 'package:list_ad/databases/helpers/ad_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Ads> _lista = List.empty(growable: true);
  //FilePersistence filePersistence = FilePersistence();

  AdHelper _helper = AdHelper();

  @override
  void initSate() {
    super.initState();
    _helper.getAll().then((data) {
      setState(() {
        if (data != null) _lista = data;
      });
    });
  }
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   filePersistence.getData().then((value) {
  //     setState(() {
  //       if (value != null) _lista = value;
  //     });
  //   });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const Icon(Icons.store),
        title: const Text(
          "App ADS",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        itemCount: _lista.length,
        itemBuilder: (context, position) {
          Ads ads = _lista[position];
          return GestureDetector(
            onLongPress: () async {
              showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text("Editar"),
                            onTap: () async {
                              Navigator.pop(context);
                              Ads editedAds = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroScreen(ads: ads)));
                              var result = await _helper.editAds(ads);
                              if (result != null) {
                                setState(() {
                                  _lista.removeAt(position);
                                  _lista.insert(position, editedAds);
                                  //filePersistence.saveData(_lista);
                                  const snackBar = SnackBar(
                                    content: Text('Anuncio Editado'),
                                    backgroundColor: Colors.blue,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text("Apagar"),
                            onTap: () async {
                              Navigator.pop(context);
                              var result = await _helper
                                  .deleteAds(ads); // Added closing parenthesis
                              if (result != null) {
                                setState(() {
                                  _lista.removeAt(position);
                                  //filePersistence.saveData(_lista);
                                  const snackBar = SnackBar(
                                    content:
                                        Text('Anuncio apagada com sucesso'),
                                    backgroundColor: Colors.red,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.send),
                            title: const Text("Compartilhar"),
                            onTap: () async {
                              final Uri params = Uri(
                                scheme: 'sms',
                                path: '+55 64 8440-0620',
                                queryParameters: {'body': 'Uma mensagem'},
                                // preciso adiconar avlor no BDA
                              );

                              if (await canLaunchUrl(params)) {
                                await launchUrl(params);
                              } else {
                                print("erro ao enviar mensagem");
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color.fromARGB(255, 73, 73, 73),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Imagem do produto ou icon se não tiver img
                    ads.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              ads.image!,
                              width: 120,
                              height: 66,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(
                            width: 120,
                            height: 66,
                            child: Icon(Icons.no_photography),
                          ),
                    SizedBox(width: 16),
                    // Informações do produto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do produto
                          Text(
                            _lista[position].titulo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ads.done ? Colors.white : Colors.grey,
                              decoration: ads.done
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          // Preço e visitas
                          Text(
                            "250",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          //Descrição
                          Text(
                            _lista[position].texto,
                            style: TextStyle(
                              fontSize: 12,
                              color: ads.done
                                  ? const Color.fromARGB(255, 179, 179, 179)
                                  : Colors.grey,
                              decoration: ads.done
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Tipo de frete
                          const Text(
                            "Frete Gratis",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botão de ação ok
                    Switch(
                      value: ads.done,
                      activeColor: const Color.fromARGB(255, 61, 255, 109),
                      onChanged: (bool value) {
                        setState(() {
                          ads.done = !ads.done;
                        }); // Adicionar lógica de ativar/desativar anúncio
                      },
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          try {
            Ads newAds = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CadastroScreen()));
            Ads? saveAds = await _helper.saveAds(newAds);
            setState(() {
              _lista.add(newAds);
              //filePersistence.saveData(_lista);

              final snackbar = SnackBar(
                content: Text('Anuncio criado!'),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          } catch (erro) {
            print("Erro: ${erro.toString()}");
          }
        },
      ),
    );
  }
}
