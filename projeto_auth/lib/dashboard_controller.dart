import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_auth/login.dart';
import 'package:projeto_auth/postgres_auth_service.dart';

class DashboardController extends GetxController {
  RxList ListaUsers = RxList([]);
  RxString Email = RxString('');
  RxString Senha = RxString('');
  RxMap<String, dynamic> selectedRow = RxMap({});
  RxString emailOriginal = ''.obs; // Para armazenar o email original do usuário
  RxString Email_validator =
      ''.obs; // Para armazenar o email digitado no formulário

  @override
  void onInit() {
    BuscarUsers();
    super.onInit();
  }

  void BuscarUsers() async {
    ListaUsers.assignAll(await PostgresConnection().BuscarUsuarios());
  }

  void InsertUsuarios() async {
    if (await PostgresConnection().InsertUsers(Email.value, Senha.value)) {
      BuscarUsers();
    } else {
      Get.defaultDialog(
        title: 'Esse email ja está sendo usado!',
      );
    }
  }

  void UpdateUser(int iduser) async {
    if (await PostgresConnection()
        .UpdateUser(iduser, Email.value, Senha.value)) {
      BuscarUsers();
    }
  }

  void DeleteUser(int iduser) async {
    if (await PostgresConnection().DeleteUser(iduser)) {
      BuscarUsers();
    }
  }

  void Loggout(int iduser) async {
    Get.dialog(AlertDialog(
      title: Text('Confirmar Logout'),
      content: Text('Tem certeza que deseja sair e nunca mais usar python?'),
      actions: <Widget>[
        TextButton(
          child: Text('Não'),
          onPressed: () {
            Get.back(); // Fecha o diálogo sem fazer nada
          },
        ),
        TextButton(
          child: Text('Sim'),
          onPressed: () async {
            if (await PostgresConnection().DeleteDispositivo(iduser)) {
              Get.back();
              Get.off(LoginStream());
            }
          },
        ),
      ],
    ));
  }
}
