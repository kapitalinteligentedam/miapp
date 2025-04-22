import 'dart:io';
import 'usuario.dart';
import 'cliente.dart';

class Menus {
  static String inicio() {
    String? opcion;

    do {
      stdout.writeln("""Hola!, selecciona una opción:
      1. Registro
      2. Log in""");
      opcion = stdin.readLineSync() ?? 'error';
    } while (opcion != "1" && opcion != "2");

    return opcion;
  }

  static String principal() {
    String? opcion;

    do {
      stdout.writeln("""Bienvenido, elige una opción:
  1. Registrar un cliente
  2. Listar todos los clientes""");
      opcion = stdin.readLineSync() ?? 'error';
    } while (opcion != "1" && opcion != "2");

    return opcion;
  }

  static registro() async {
    bool creado = false;
    do {
      creado = false;
      stdout.writeln("Introduce el nombre con el que te quieres registrar");
      String nombre = stdin.readLineSync() ?? 'error';
      stdout.writeln("Ahora introduce la que será tu contraseña");
      String password = stdin.readLineSync() ?? 'error';
      bool nombreExiste = await Usuario.comprobarSiExiste(nombre);

      if (nombreExiste) {
        stdout.writeln("El nombre ya existe, prueba con otro");
      } else {
        Usuario usuario = Usuario();
        usuario.user = nombre;
        usuario.password = password;
        creado = await usuario.save();
      }
    } while (creado == false);
  }

  static Future<bool> login() async {
    Usuario usuario = Usuario();
    do {
      stdout.writeln("Introduce tu nombre de usuario");
      usuario.user = stdin.readLineSync() ?? 'error';
      stdout.writeln("Ahora introduce tu contraseña");
      usuario.password = stdin.readLineSync() ?? 'error';

      if (await usuario.login()) {
        stdout.writeln("Login correcto");
        return true;
      } else {
        stdout.writeln("Login incorrecto");
      }
    } while (true);
  }

  static registroCliente() async {
    Cliente cliente = Cliente();
    stdout.writeln("Introduce la razón social");
    cliente.razonsocial = stdin.readLineSync() ?? 'error';
    stdout.writeln("Introduce el NIF");
    cliente.nif = stdin.readLineSync() ?? 'error';
    stdout.writeln("Introduce la dirección");
    cliente.direccion = stdin.readLineSync() ?? 'error';
    stdout.writeln("Introduce el teléfono");
    cliente.telefono = stdin.readLineSync() ?? 'error';
    stdout.writeln("Introduce el email");
    cliente.email = stdin.readLineSync() ?? 'error';
    if (await cliente.save()) {
      stdout.writeln("Cliente registrado correctamente");
    } else {
      stdout.writeln("NO se ha registrado el cliente");
    }
  }

  static listarClientes() async{
    List<Cliente> listadoClientes = await Cliente.all();
    for(Cliente cliente in listadoClientes){
      stdout.writeln("${cliente.idcliente} - ${cliente.razonsocial} - ${cliente.nif}");
    }
  }

  static acceso() async {
    if (await Menus.login()) {
      while (true) {
        String opcion = Menus.principal();
        switch (opcion) {
          case "1":
            await Menus.registroCliente();
            break;
          case "2":
            await Menus.listarClientes();
            break;
        }
      }
    } else {
      stdout.writeln("Login incorrecto");
    }
  }
}
