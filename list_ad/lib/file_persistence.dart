// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:list_ad/todo.dart';
// class FilePersistence {
//   Future<File> _getLocalFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     String localPath = directory.path;
//     File localFile = File('$localPath/adsFile.json');
//     if (localFile.existsSync()) {
//       return localFile;
//     } else {
//       return localFile.create(recursive: true);
//     }
//   }
//   Future saveData(List<Ads> ads) async {
//     final localFile = await _getLocalFile();
//     List adslist = [];
//     ads.forEach((advertise) {
//       adslist.add(advertise.toMap());
//     });
//     String data = json.encode(adslist);
//     return localFile.writeAsStringSync(data);
//   }
//   Future<List<Ads>?> getData() async {
//     try {
//       final localFile = await _getLocalFile();
//       List adslist = [];
//       List<Ads> ads = [];
//       String content = await localFile.readAsString();
//       adslist = json.decode(content);
//       adslist.forEach((tarefa) {
//         ads.add(Ads.fromMap(tarefa));
//       });
//       return ads;
//     } catch (error) {
//       print(error);
//       return null;
//     }
//   }
// }
