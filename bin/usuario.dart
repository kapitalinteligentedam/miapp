import "dart:io";
import "package:mysql1/mysql1.dart";

import "database.dart";

class Usuario {
  int? _idusuario;
  String? _user;
  String? _password;
  String? apellidos;

  int? get idusuario => _idusuario;
  String? get user => _user;
  String? get password => _password;

  set idusuario(int? idusuario) {
    _idusuario = idusuario;
  }

  set user(String? user) {
    _user = user;
  }

  set password(String? password) {
    _password = password;
  }

  Usuario();

  Usuario.fromMap(ResultRow map) {
    _idusuario = map['idusuario'];
    _user = map['nombre'];
    _password = map['password'];
  }

  static Future<bool> comprobarSiExiste(String nombre) async {
    bool existe = true;
    var conn;
    try {
      conn = await DataBase.obtenerConexion();
      var registros =
          await conn.query("SELECT * FROM usuarios WHERE nombre = ?", [nombre]);
      if (registros.length == 0) {
        existe = false;
      }
    } catch (e) {
      print(e);
    } finally {
      conn.close();
    }
    return existe;
  }

  Future<bool> login() async {
    var conn;
    try {
      conn = await DataBase.obtenerConexion();
      var registros =
          await conn.query("SELECT * FROM usuarios WHERE nombre = ?", [user]);
      if (registros.length == 0) {
        return false;
      } else {
        Usuario usuario = Usuario.fromMap(registros.first);
        if (password == usuario.password) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      conn.close();
    }
  }

  Future<bool> save() async {
    bool guardado = false;
    var conn;
    try {
      conn = await DataBase.obtenerConexion();
      await conn.query("INSERT INTO usuarios (nombre,password) VALUES(?,?)",
          [user, password]);
      stdout.writeln("Usuario insertado con éxito");
      guardado = true;
    } catch (e) {
      print(e);
    } finally {
      conn.close();
    }
    return guardado;
  }
}
