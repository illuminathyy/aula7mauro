// lib/calendario.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarioApp());
}

class CalendarioApp extends StatelessWidget {
  const CalendarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendário',
      home: const TelaCalendario(),
    );
  }
}

class TelaCalendario extends StatefulWidget {
  const TelaCalendario({super.key});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  final DateTime _agora = DateTime.now();
  final List<String> _diasSemana = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  void _mostrarDia(int dia) {
    final dataSelecionada = DateTime(_agora.year, _agora.month, dia);
    final diaSemana = _diasSemana[dataSelecionada.weekday];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesDia(dia: dia, diaSemana: diaSemana),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ultimoDia = DateTime(_agora.year, _agora.month + 1, 0).day;
    final primeiroDiaSemana = DateTime(_agora.year, _agora.month, 1).weekday;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_agora.month}/${_agora.year}',
          style: const TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.purple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: ultimoDia + primeiroDiaSemana,
        itemBuilder: (context, index) {
          if (index < primeiroDiaSemana) {
            return Container(); // Dias vazios no início
          }
          
          final dia = index - primeiroDiaSemana + 1;
          return TextButton(
            onPressed: () => _mostrarDia(dia),
            style: TextButton.styleFrom(
              backgroundColor: dia == _agora.day ? Colors.purple[100] : null,
              shape: const CircleBorder(),
            ),
            child: Text(
              '$dia',
              style: TextStyle(
                fontSize: 16,
                color: dia == _agora.day ? Colors.purple : Colors.black,
                fontWeight: dia == _agora.day ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TelaDetalhesDia extends StatelessWidget {
  final int dia;
  final String diaSemana;

  const TelaDetalhesDia({
    super.key,
    required this.dia,
    required this.diaSemana,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Dia'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            Text(
              'Dia da Semana:',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              diaSemana,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Número do Dia:',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              '$dia',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}