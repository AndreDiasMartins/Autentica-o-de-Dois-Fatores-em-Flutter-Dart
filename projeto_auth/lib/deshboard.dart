import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_auth/dashboard_controller.dart';
// import 'package:projeto_auth/thema/LightThema.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.idUser}) {
    viewController =
        Get.put(DashboardController(), tag: "mainDashboardController");
  }

  late final DashboardController viewController;
  final int idUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () => viewController.Loggout(idUser),
              icon: Icon(Icons.logout)),
          // IconButton(onPressed: () => Get.changeTheme(LightThema), icon: Icon(Icons.dark_mode)),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              final formKey = GlobalKey<FormState>();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cadastrar Novo Usuário'),
                    content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              onChanged: (value) =>
                                  viewController.Email.value = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ocampo Email, não pode estar vazio!';
                                }

                                bool emailExiste =
                                    viewController.ListaUsers.any(
                                        (user) => user['email'] == value);

                                if (emailExiste) {
                                  return 'O email já está cadastrado!';
                                }

                                // Expressão regular para validar o formato do e-mail
                                final emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );

                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Digite um e-mail válido!';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                              ),
                              obscureText: true,
                              onChanged: (value) =>
                                  viewController.Senha.value = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'O campo senha deve ser prenchido! ';
                                }

                                if (value.length < 8) {
                                  return 'A senha deve ter pelo menos 8 caracteres!';
                                }

                                final hasUpperCase =
                                    RegExp(r'[A-Z]').hasMatch(value);
                                final hasLowerCase =
                                    RegExp(r'[a-z]').hasMatch(value);
                                final hasDigits = RegExp(r'\d').hasMatch(value);
                                final hasSpecialChars =
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                        .hasMatch(value);

                                if (!hasUpperCase) {
                                  return 'A senha deve conter pelo menos uma letra maiúscula!';
                                }
                                if (!hasLowerCase) {
                                  return 'A senha deve conter pelo menos uma letra minúscula!';
                                }
                                if (!hasDigits) {
                                  return 'A senha deve conter pelo menos um número!';
                                }
                                if (!hasSpecialChars) {
                                  return 'A senha deve conter pelo menos um caractere especial!';
                                }

                                return null;
                              },
                            ),
                          ],
                        )),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            viewController.InsertUsuarios();
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Obx(
            () => Visibility(
              visible: viewController.selectedRow.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _edit,
              ),
            ),
          ),
          Obx(
            () => Visibility(
                visible: viewController.selectedRow.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _delete,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                headingRowHeight: 60,
                showCheckboxColumn: false,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Senha',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                rows: viewController.ListaUsers.map(
                  (element) {
                    final isSelected = viewController.selectedRow == element;
                    return DataRow(
                      color: isSelected
                          ? WidgetStatePropertyAll(Colors.blue.withOpacity(0.2))
                          : WidgetStatePropertyAll(Colors.transparent),
                      selected: isSelected,
                      onSelectChanged: (selected) {
                        if (selected != null) {
                          viewController.selectedRow.value =
                              selected ? element : {};
                        }
                      },
                      cells: [
                        DataCell(
                          Text(
                            element['id'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        DataCell(
                          Text(
                            element['email']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        DataCell(
                          Text(
                            element['senha']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _edit() async {
    if (viewController.selectedRow.isNotEmpty) {
      final userId = viewController.selectedRow['id'] as int;
      viewController.Email.value = viewController.selectedRow['email'];
      viewController.Senha.value = viewController.selectedRow['senha'];

      final formKey = GlobalKey<FormState>();
      Get.dialog(AlertDialog(
        title: const Text('Editar Usuário'),
        content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => TextFormField(
                    initialValue: viewController.Email.value,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) => viewController.Email.value = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha este campo!";
                      }

                      return null;
                    },
                  ),
                ),
                Obx(
                  () => TextFormField(
                    initialValue: viewController.Senha.value,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha este campo!";
                      }
                      if (value.length < 8) {
                        return 'A senha deve ter pelo menos 8 caracteres!';
                      }

                      final hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
                      final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
                      final hasDigits = RegExp(r'\d').hasMatch(value);
                      final hasSpecialChars =
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

                      if (!hasUpperCase) {
                        return 'A senha deve conter pelo menos uma letra maiúscula!';
                      }
                      if (!hasLowerCase) {
                        return 'A senha deve conter pelo menos uma letra minúscula!';
                      }
                      if (!hasDigits) {
                        return 'A senha deve conter pelo menos um número!';
                      }
                      if (!hasSpecialChars) {
                        return 'A senha deve conter pelo menos um caractere especial!';
                      }

                      return null;
                    },
                    onChanged: (value) => viewController.Senha.value = value,
                  ),
                )
              ],
            )),
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Atualizar dados no banco de dados
                viewController.UpdateUser(userId);
                Get.back();
              }
            },
            child: const Text('Atualizar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ));
    }
  }

  void _delete() {
    if (viewController.selectedRow.isNotEmpty) {
      final userId = viewController.selectedRow['id'] as int;
      Get.dialog(AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja deletar este item?'),
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
              Get.back(); // Fecha o diálogo
              viewController.DeleteUser(
                  userId); // Chama a função que realiza a exclusão
            },
          ),
        ],
      ));
    }
  }
}
