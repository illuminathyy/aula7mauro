import 'package:flutter/material.dart';

void main() {
  runApp(DatePickerApp());
}

class DatePickerApp extends StatelessWidget {
  const DatePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('showDatePicker Example')),
        body: const Center(child: NovoTexto()),
      ),
    );
  }
}

class NovoTexto extends StatefulWidget {
  const NovoTexto({super.key});

  @override
  State<NovoTexto> createState() => _NovoTextoState();
}

class _NovoTextoState extends State<NovoTexto> {
  DateTime? selectedDate;
  String? selecionada = '';

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2026),
    );

    setState(() {
      selectedDate = pickedDate;
      if (pickedDate != null) {
        selecionada =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      }
    });
  }

  String digitado = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: _selectDate, child: Text('Selecionar')),
              Text('Idade: $selecionada'),
            ],
          ),
        ),
      ),
    );
  }
}