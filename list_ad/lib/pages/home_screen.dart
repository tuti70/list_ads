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
  void initState() {
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
                              Ads editAds = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroScreen(ads: ads)));
                              var result = await _helper.editAds(ads);
                              if (result != null) {
                                setState(() {
                                  _lista.removeAt(position);
                                  _lista.insert(position, editAds);
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
                              var result = await _helper.deleteAds(ads);
                              if (result != null) {
                                setState(() {
                                  _lista.removeAt(position);

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
                                path: '+55648440-0620',
                                queryParameters: {
                                  "body": Uri.encodeComponent(
                                      "Gostei do produto ${ads.titulo}")
                                },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem do produto ou ícone se não houver imagem
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ads.image != null
                          ? Image.file(
                              ads.image!,
                              opacity: ads.done
                                  ? const AlwaysStoppedAnimation(1)
                                  : const AlwaysStoppedAnimation(.3),
                              width: double
                                  .infinity, // Ocupar toda a largura disponível
                              height: 250, // Ajustar para manter proporção 16:9
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Icon(
                                Icons.no_photography,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    SizedBox(height: 16),
                    // Nome do produto
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

                    // Descrição
                    Text(
                      _lista[position].text,
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
                        // decoration: ads.done
                        //     ? TextDecoration.none
                        //     : TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        // Preço
                        Expanded(
                          child: Text(
                            _lista[position].preco as String,
                            style: TextStyle(
                              fontSize: 18,
                              color: ads.done ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: ads.done
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: ads.done,
                              activeColor:
                                  const Color.fromARGB(255, 61, 255, 109),
                              onChanged: (bool value) {
                                setState(() {
                                  ads.done = !ads.done;
                                }); // Adicionar lógica de ativar/desativar anúncio
                              },
                            ),
                          ),
                        )
                      ],
                    )
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
            Ads? save = await _helper.saveAds(newAds);
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
