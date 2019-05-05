import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=89069e6f';

void main() async {
  runApp(MaterialApp(title: 'Currency Convert', home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Conversor de Moedas',
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Carregando Informações...',
                    textAlign: TextAlign.center),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar informções',
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 120,
                        color: Colors.amber,
                      ),
                      buildTextFiel(
                          'Real', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextFiel(
                          'Dollar', 'US\$', dollarController, _dollarChanged),
                      Divider(),
                      buildTextFiel('Euro', '€', euroController, _euroChanged)
                    ],
                  ),
                );
              }
            }
          },
        ));
  }
}

Widget buildTextFiel(String label, String prefix,
    TextEditingController controller, Function currencyChanged) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 22.0),
        border: OutlineInputBorder(),
        prefixText: prefix),
    onChanged: currencyChanged,
  );
}
