import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6200EE), // Azul Escuro
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF6200EE), // Azul Escuro
          secondary: Color(0xFF03DAC6), // Ciano
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Cinza Claro
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF000000)), // Preto
          bodyMedium: TextStyle(color: Color(0xFF000000)), // Preto
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _alcoolController = TextEditingController();
  final TextEditingController _gasolinaController = TextEditingController();
  String _resultado = "";
  double _precoAlcool = 0;
  double _precoGasolina = 0;
  final _formKey = GlobalKey<FormState>();

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      _precoAlcool = double.parse(_alcoolController.text);
      _precoGasolina = double.parse(_gasolinaController.text);

      double razao = _precoAlcool / _precoGasolina;
      String razaoFormatada = razao.toStringAsFixed(2);

      setState(() {
        if (razao < 0.7) {
          _resultado = "Razão: $razaoFormatada. Abasteça com Álcool!";
        } else {
          _resultado = "Razão: $razaoFormatada. Abasteça com Gasolina!";
        }
      });
    }
  }

  void _limparCampos() {
    _alcoolController.clear();
    _gasolinaController.clear();
    setState(() {
      _resultado = "";
      _precoAlcool = 0;
      _precoGasolina = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Álcool ou Gasolina?'),
        centerTitle: true,
        backgroundColor: Color(0xFF6200EE), // Azul Escuro
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.local_gas_station,
                size: 80.0, // Diminuindo o tamanho da logo
                color: Color(0xFF6200EE), // Azul Escuro
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _alcoolController,
                label: "Preço do Álcool (R\$)",
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _gasolinaController,
                label: "Preço da Gasolina (R\$)",
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calcular,
                      child: Text("Calcular"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5722), // Laranja
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _limparCampos,
                      child: Text("Limpar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E9E9E), // Cinza
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF6200EE), // Azul Escuro
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              if (_precoAlcool > 0 && _precoGasolina > 0)
                Container(
                  height: 200, // Aumentando a altura do gráfico para melhor visibilidade
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: _precoAlcool,
                          color: Color(0xFF6200EE), // Azul Escuro
                          title: 'Álcool\nR\$${_precoAlcool.toStringAsFixed(2)}',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: _precoGasolina,
                          color: Color(0xFF03DAC6), // Ciano
                          title: 'Gasolina\nR\$${_precoGasolina.toStringAsFixed(2)}',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: Color(0xFF000000)), // Preto
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF000000), fontSize: 18.0), // Preto
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFE0E0E0), // Cinza Claro
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira um valor';
        }
        if (double.tryParse(value) == null) {
          return 'Insira um número válido';
        }
        return null;
      },
    );
  }
}
