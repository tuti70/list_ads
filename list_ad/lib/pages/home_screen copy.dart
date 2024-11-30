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

          return Card(
            color: const Color.fromARGB(255, 73, 73, 73),
            child: ListTile(
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
                                var result = await _helper.deleteAds(
                                    ads); // Added closing parenthesis
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
                                  path: '+556498440-0620',
                                  queryParameters: {'body': 'test test'},
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
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ads.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          ads.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.cancel),
                      ),
              ),
              title: Text(
                _lista[position].titulo,
                style: TextStyle(
                  color: ads.done ? Colors.white : Colors.grey,
                  decoration: ads.done
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                _lista[position].texto,
                style: TextStyle(
                  color: ads.done ? Colors.white : Colors.grey,
                  decoration: ads.done
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Switch(
                      value: ads.done,
                      activeColor: const Color.fromARGB(255, 61, 255, 109),
                      onChanged: (bool value) {
                        setState(() {
                          ads.done = !ads.done;
                        });
                      }),
                  const Text('Qtd: 2'),
                ],
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
