import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'qrcode.dart';
import 'package:localstorage/localstorage.dart';

String URL = "www.slmm.com.br/CTC/insere.php";
final LocalStorage storage = new LocalStorage('localstorage_app');

Future<String> fetchData() async {
  Map data = {"nome":"a", "data": "03/03/22 00:00:33"};

  String body = json.encode(data);
  print(body);

  var response = await http.post(Uri.parse(URL),
      headers: {"Content-Type": "application/json"}, body: body);
      print(response.statusCode);
  if (response.statusCode == 200) {
    String json2 = json.encode(response.body);
    return response.body;
  } else {
    throw Exception('Erro inesperado');
  }
}


Future<String> listData() async {
  Map data = {"nome":"a", "data": "03/03/22 00:00:33"};

  String body = json.encode(data);
  print(body);

  var response = await http.get(Uri.parse("www.slmm.com.br/CTC/getLista.php"));
      print(response.statusCode);
  if (response.statusCode == 200) {
    String json2 = json.encode(response.body);
    print(response.body);
    return "alo";
  } else {
    throw Exception('Erro inesperado');
  }
}




class RotaPost extends StatefulWidget {
  const RotaPost({Key? key}) : super(key: key);

  @override
  _RotaPostState createState() => _RotaPostState();
}

class _RotaPostState extends State<RotaPost> {
  final nomeController = TextEditingController();
  final dataController = TextEditingController();
  Future<String>? _dadosF;

  @override
  void dispose() {
    nomeController.dispose();
    dataController.dispose();
    super.dispose();
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder(
        future: _dadosF,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  ElevatedButton botao() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = fetchData();
          });
        },
        child: Text("enviar dados"));
  }

  @override
  Widget build(BuildContext context) {

     setState(() {
            _dadosF = listData();
          });

    return Scaffold(
      appBar: AppBar(title: Text("Lista de dados")),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
          TextField(
              controller: nomeController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.person),
                  hintText: 'Insira o nome')),
                  TextField(
              controller: dataController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.calendar_month),
                  hintText: 'Insira a data')),
                  
              Container(
              margin: EdgeInsets.all(3),
              child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(nomeController.text),
                      );
                    });
                setState(() {
                  _dadosF = null;
                });
              },
              child: Text("Mandar dados")),
              
              ),

              Container(
                margin: EdgeInsets.all(6),
                child:  ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Qrcode(),
                    ));
              },
              child: Text("Habilitar QR Code")),
              ),

          (_dadosF == null) ? botao() : buildFutureBuilder(),
        ]),
      ),
    );
  }
}
