import "package:mysql1/mysql1.dart";

import "database.dart";

class Cliente{
  int? idcliente;
  String? razonsocial;
  String? nif;
  String? telefono;
  String? email;
  String? direccion;
  double riesgo = 0;
  String? provincia;

  Cliente();
  
  Cliente.fromDB(ResultRow registro){
    idcliente = registro['idcliente'];
    razonsocial = registro['razonsocial'];
    nif = registro['nif'];
    telefono = registro['telefono'];
    email = registro['email'];
    direccion = registro['direccion'];
    riesgo = registro['riesgo'];
  }

  Future<bool> save() async {
    bool guardado = false;
    var conn;
    try {
      conn = await DataBase.obtenerConexion();
      await conn.query("INSERT INTO clientes (razonsocial,nif,direccion,email,telefono,riesgo) VALUES(?,?,?,?,?,?)",
          [razonsocial,nif,direccion,email,telefono,riesgo]);
      guardado = true;
    } catch (e) {
      print(e);
    } finally {
      conn.close();
    }
    return guardado;
  }
  
  static Future<List<Cliente>> all() async {
    List<Cliente> clientes = [];
    var conn;
    try {
      conn = await DataBase.obtenerConexion();
      var registros = await conn.query("SELECT * FROM clientes");
      for(var registro in registros){
        Cliente cliente = Cliente.fromDB(registro);
        clientes.add(cliente);
      }
    } catch (e) {
      print(e);
    } finally {
      conn.close();
    }
      return clientes;
  }
}