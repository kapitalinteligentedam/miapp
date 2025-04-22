import "database.dart";
import "menus.dart";

main() async {
  await DataBase.instalarBBDD();

  while (true) {
    String opcion = Menus.inicio();
    switch (opcion) {
      case "1":
        await Menus.registro();
        break;
      case "2":
        await Menus.acceso();
        break;
    }
  }
}


