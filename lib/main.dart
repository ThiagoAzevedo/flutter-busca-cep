import 'package:consulta_cep/models/cep_convert.dart';
import 'package:consulta_cep/services/via_cep_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  TextEditingController _ctrlCep;
  bool _ctrlCepValidate = false;
  bool _loading = false;
  bool _enabledField = true;
  String _result;
  CepCovertDart _resultCep;
  bool _resultBool = false;
  String _textInfo = 'Nenhum CEP pesquisado';

  @override
  void initState() {
    super.initState();
    _ctrlCep = TextEditingController();
  }

  @override
  void dispose() {
    _ctrlCep.clear();
    super.dispose();
  }

  void reset() {
    setState(() {
      _ctrlCep.clear();
      _result = '';
      _textInfo = 'Nenhum CEP pesquisado';
      _resultBool = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfff7de02),
        centerTitle: false,
        title: Image.asset(
          'assets/images/correios-logo-5.png',
          height: 30,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: reset,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 520,
          padding: EdgeInsets.symmetric(
            vertical: 70,
            horizontal: 25,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xffe7c13b),
                Color(0xfff7de02),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _titleSearchCep(),
              _buildSearchCepTextField(),
              _buildSearchCepButton(),
              _buildResultForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleSearchCep() {
    return Text(
      'Consulte seus CEP\'s',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: TextField(
        controller: _ctrlCep,
        keyboardType: TextInputType.number,
        maxLength: 8,
        enabled: _enabledField,
        decoration: InputDecoration(
          errorText: _ctrlCepValidate
              ? 'O campo não pode ser vazio. Digite um CEP válido'
              : null,
          labelText: 'Exemplo: 28010100',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xff007bb8),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: _loading
              ? _cicularLoading()
              : Text(
                  'Consultar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
        onTap: () {
          setState(() {
            _ctrlCep.text.isEmpty
                ? _ctrlCepValidate = true
                : _ctrlCepValidate = false;

            _searchCep();
          });
          print('Clicou na busca CPF');
          print(_ctrlCep.text);
        },
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enabledField = !enable;
    });
  }

  Widget _cicularLoading() {
    return Container(
      width: 15.0,
      height: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);
    // Recupera o valor do CEP informado
    final cep = _ctrlCep.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);

    print(resultCep.localidade);
    print(resultCep.complemento);
    print(resultCep.logradouro);

    setState(() {
      _result = resultCep.toJson().toString();
      _resultCep = resultCep;
      _resultBool = true;
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: _resultBool
          ? Column(
              children: <Widget>[
                _buildFieldResult(cep: _resultCep.cep, field: 'CEP: '),
                _buildFieldResult(
                    cep: _resultCep.logradouro, field: 'Logradouro: '),
                _buildFieldResult(
                    cep: _resultCep.complemento, field: 'Complemento: '),
                _buildFieldResult(cep: _resultCep.bairro, field: 'Bairro: '),
                _buildFieldResult(
                    cep: _resultCep.localidade, field: 'Localidade: '),
                _buildFieldResult(cep: _resultCep.uf, field: 'UF: '),
              ],
            )
          : Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                _textInfo,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
    );
  }

  Widget _buildFieldResult({@required String field, @required String cep}) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 120,
          child: Text(
            field,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(
            cep ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
