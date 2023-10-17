import 'package:flutter/material.dart';

import 'viacep_model.dart';
import 'viacep_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cepController = TextEditingController(text: '');
  bool loading = false;
  var viacepModel = ViaCEPModel();
  var viaCEPRepository = ViaCepRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          const Text('Consulta CEP'),
          TextField(
            controller: cepController,
            maxLength: 8,
            keyboardType: TextInputType.number,
            onChanged: (String value) async {
              var cep = value.replaceAll(new RegExp(r'[^0-9]'), '');
              if (cep.length == 8) {
                setState(() {
                  loading = true;
                });
                viacepModel = await viaCEPRepository.consultarCEP(cep);
              }
              setState(() {
                loading = false;
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Text(viacepModel.logradouro ?? ''),
          Text('${viacepModel.localidade ?? ''} - ${viacepModel.uf ?? ''}'),
          Visibility(visible: loading, child: CircularProgressIndicator())
        ]),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom:
                60.0, // Posição vertical do botão em relação à parte inferior da tela
            left:
                25.0, // Posição horizontal do botão em relação à parte direita da tela
            child: FloatingActionButton(
              onPressed: () async {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
