import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() {
  runApp(const NovoTexto());
}

class NovoTexto extends StatefulWidget {
  const NovoTexto({super.key});

  @override
  State<NovoTexto> createState() => _NovoTextoState();
}

class _NovoTextoState extends State<NovoTexto> {
  late TextEditingController _controlador;
  String digitado = '';

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _controlador,
                  onChanged: (String valor) {
                    if (valor.length > 0) {
                      if (RegExp(r'^[0-9.,]+$').hasMatch(valor)) {
                        print(valor[valor.length - 1]);
                      } else {
                        _controlador.text =
                            valor.substring(0, valor.length - 1);
                      }
                    }
                  },
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      digitado = _controlador.text;
                      var raio = double.parse(digitado);
                      var area = pi * raio * raio;
                      var f = NumberFormat("###.0#", "pt_BR");
                      digitado = f.format(area);
                    });
                  },
                  child: Text('Verificar')),
              Text('Digitado: $digitado'),
            ],
          ),
        ),
      ),
    );
  }
}