import 'package:flutter/material.dart';

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Alunos',
      home: StudentHome(),
    );
  }
}

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String _studentName = '';
  String _studentId = '';
  List<double> _grades = [];

  void _navigateToAddGrades() {
    if (_studentName.isEmpty || _studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha nome e matrícula primeiro!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGradesScreen(
          studentName: _studentName,
          onGradesAdded: (grades) {
            setState(() {
              _grades = grades;
            });
          },
        ),
      ),
    );
  }

  void _navigateToViewStudent() {
    if (_studentName.isEmpty || _studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha nome e matrícula primeiro!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewStudentScreen(
          studentName: _studentName,
          studentId: _studentId,
          grades: _grades,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro do Aluno'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome do Aluno',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {
                  _studentName = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Matrícula',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              onChanged: (value) {
                setState(() {
                  _studentId = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.add_chart),
              label: Text('Lançar Notas'),
              onPressed: _navigateToAddGrades,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              icon: Icon(Icons.visibility),
              label: Text('Visualizar Aluno'),
              onPressed: _navigateToViewStudent,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            if (_studentName.isNotEmpty && _studentId.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aluno Cadastrado:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Nome: $_studentName'),
                      Text('Matrícula: $_studentId'),
                      Text('Quantidade de notas: ${_grades.length}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddGradesScreen extends StatefulWidget {
  final String studentName;
  final Function(List<double>) onGradesAdded;

  const AddGradesScreen({
    Key? key,
    required this.studentName,
    required this.onGradesAdded,
  }) : super(key: key);

  @override
  _AddGradesScreenState createState() => _AddGradesScreenState();
}

class _AddGradesScreenState extends State<AddGradesScreen> {
  List<double> _grades = [];
  final TextEditingController _gradeController = TextEditingController();

  void _addGrade() {
    final gradeText = _gradeController.text.trim();
    if (gradeText.isEmpty) return;

    final grade = double.tryParse(gradeText);
    if (grade == null || grade < 0 || grade > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite uma nota válida (0-10)!')),
      );
      return;
    }

    setState(() {
      _grades.add(grade);
      _gradeController.clear();
    });
  }

  void _removeGrade(int index) {
    setState(() {
      _grades.removeAt(index);
    });
  }

  void _saveGrades() {
    widget.onGradesAdded(_grades);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notas salvas com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lançar Notas'),
        backgroundColor: Colors.orange[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Aluno: ${widget.studentName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gradeController,
                    decoration: InputDecoration(
                      labelText: 'Nota (0-10)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addGrade,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Notas Adicionadas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _grades.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma nota adicionada',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _grades.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            title: Text(
                              'Nota: ${_grades[index].toStringAsFixed(1)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeGrade(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGrades,
              child: Text('Salvar Notas'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewStudentScreen extends StatelessWidget {
  final String studentName;
  final String studentId;
  final List<double> grades;

  const ViewStudentScreen({
    Key? key,
    required this.studentName,
    required this.studentId,
    required this.grades,
  }) : super(key: key);

  double _calculateAverage() {
    if (grades.isEmpty) return 0;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  String _getStatus() {
    final average = _calculateAverage();
    if (average >= 7) return 'Aprovado';
    if (average >= 5) return 'Recuperação';
    return 'Reprovado';
  }

  @override
  Widget build(BuildContext context) {
    final average = _calculateAverage();
    final status = _getStatus();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dados do Aluno'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do Aluno',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Nome: $studentName'),
                    Text('Matrícula: $studentId'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Média: ${average.toStringAsFixed(1)}'),
                        SizedBox(width: 20),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: status == 'Aprovado'
                                ? Colors.green
                                : status == 'Recuperação'
                                    ? Colors.orange
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Notas do Aluno:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: grades.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma nota cadastrada',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: grades.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            title: Text(
                              'Nota ${index + 1}: ${grades[index].toStringAsFixed(1)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Icon(
                              grades[index] >= 7
                                  ? Icons.check_circle
                                  : grades[index] >= 5
                                      ? Icons.warning
                                      : Icons.error,
                              color: grades[index] >= 7
                                  ? Colors.green
                                  : grades[index] >= 5
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
