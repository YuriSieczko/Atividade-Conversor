import 'dart:convert';
import 'dart:html';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeConver extends StatefulWidget {
  const HomeConver({Key? key}) : super(key: key);

  @override
  State<HomeConver> createState() => _HomeConverState();
}

class _HomeConverState extends State<HomeConver> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  final zlotiControl = TextEditingController();
  final yuanControl = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double zloti = 0;
  double yuan = 0;

  @override
  void dispose() {
    realControl.dispose();
    dolarControl.dispose();
    euroControl.dispose();
    zlotiControl.dispose();
    yuanControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversor de Moedas'),
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.connectionState == ConnectionState.done) {
                dolar = double.parse(snapshot.data!['USDBRL']['bid']);
                euro = double.parse(snapshot.data!['EURBRL']['bid']);
                zloti = double.parse(snapshot.data!['PLNBRL']['bid']);
                yuan = double.parse(snapshot.data!['CNYBRL']['bid']);
                // dolar = snapshot.data!['USD']['buy'];
                // euro = snapshot.data!['EUR']['buy'];
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on_outlined,
                        size: 120,
                      ),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Reais ', 'R\$ ', realControl, _convertReal),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Dolares', 'US\$ ', dolarControl, _convertDolar),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Euros', '€ ', euroControl, _convertEuro),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Zloti', 'zł ', zlotiControl, _convertZloti),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Yuan', '¥ ', yuanControl, _convertYuan),
                    ],
                  ),
                );
              } else {
                return waitingIndicator();
              }
            } else {
              return waitingIndicator();
            }
          },
        ));
  }

  TextField currencyTextField(String label, String prefixText,
      TextEditingController controller, Function f) {
    return TextField(
      controller: controller,
      inputFormatters: [
        CurrencyTextInputFormatter(
          locale: "pt",
          name: '',
          symbol: null,
          decimalDigits: 2,
          customPattern: null,
          turnOffGrouping: false,
          enableNegative: false,
        )
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
      ),
      onChanged: (value) {
        value = value.replaceAll('.', '');
        value = value.replaceAll(',', '.');
        f(value);
      },
      keyboardType: TextInputType.number,
    );
  }

  Center waitingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _convertReal(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double real = double.parse(text);
    dolarControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((real / dolar))
        .trim();
    euroControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((real / euro))
        .trim();
    zlotiControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((real / zloti))
        .trim();
    yuanControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((real / yuan))
        .trim();
  }

  void _convertDolar(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double dolar = double.parse(text);
    realControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.dolar * dolar))
        .trim();
    euroControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.dolar * dolar) / euro)
        .trim();
    zlotiControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.dolar * dolar) / zloti)
        .trim();
    yuanControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.dolar * dolar) / yuan)
        .trim();
  }

  void _convertEuro(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double euro = double.parse(text);
    realControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.euro * euro))
        .trim();
    dolarControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.euro * euro) / dolar)
        .trim();
    zlotiControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.euro * euro) / zloti)
        .trim();
    yuanControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.euro * euro) / yuan)
        .trim();
  }

  void _convertZloti(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double zloti = double.parse(text);
    realControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.zloti * zloti))
        .trim();
    dolarControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.zloti * zloti) / dolar)
        .trim();
    euroControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.zloti * zloti) / euro)
        .trim();
    yuanControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.zloti * zloti) / yuan)
        .trim();
  }

  void _convertYuan(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    
    double yuan = double.parse(text);
    realControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.yuan * yuan))
        .trim();
    dolarControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.yuan * yuan) / dolar)
        .trim();
    euroControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.yuan * yuan) / euro)
        .trim();
    zlotiControl.text = NumberFormat.currency(locale: "pt", name: '')
        .format((this.yuan * yuan) / zloti)
        .trim();
  }

  void _clearFields() {
    realControl.clear();
    dolarControl.clear();
    euroControl.clear();
    zlotiControl.clear();
    yuanControl.clear();
  }
}

Future<Map> getData() async {
  //* ENDEREÇO DA API NOVA
  //* https://docs.awesomeapi.com.br/api-de-moedas

  const requestApi =
      "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,PLN-BRL,CNY-BRL";
  var response = await http.get(Uri.parse(requestApi));
  return jsonDecode(response.body);

  //* json manual para teste em caso de
  //* problema com a conexão http
/*   var response = {
    "USDBRL": {
      "code": "USD",
      "codein": "BRL",
      "name": "Dólar Americano/Real Brasileiro",
      "high": "5.3388",
      "low": "5.2976",
      "varBid": "0.0382",
      "pctChange": "0.72",
      "bid": "5.3348",
      "ask": "5.3363",
      "timestamp": "1679660987",
      "create_date": "2023-03-24 09:29:47"
    },
    "EURBRL": {
      "code": "EUR",
      "codein": "BRL",
      "name": "Euro/Real Brasileiro",
      "high": "5.7429",
      "low": "5.6772",
      "varBid": "-0.0095",
      "pctChange": "-0.17",
      "bid": "5.7256",
      "ask": "5.7293",
      "timestamp": "1679660999",
      "create_date": "2023-03-24 09:29:59"
    }
  };

  return jsonDecode(jsonEncode(response));
 */
}
