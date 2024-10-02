import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:projeto_auth/deshboard.dart';
import 'package:projeto_auth/postgres_auth_service.dart';

class LoginController extends GetxController {
  RxString email = RxString('');
  RxString senha = RxString('');
  RxBool loginIN = RxBool(false);

  void SendEmail() async {
    loginIN.value = true;
    var connect = PostgresConnection();

    int? idUSer = await connect.autenticar(email.value, senha.value);
    if (idUSer != null) {
      if (await connect.validDispositivo(idUSer)) {
        Get.off(Dashboard(
          idUser: idUSer,
        ));
      } else {
        String? token = await connect.createToken(idUSer);
        if (token != null) {
          final message = Message()
            ..from = Address(email.value, 'Your name')
            ..recipients.add(email.value)
            ..subject = 'Seu token e login'
            ..text = token;

          try {
            final sendReport = await send(
                message,
                SmtpServer(
                  '', // Seu Smpt AQui
                  ssl: false,
                  username: '', //login do seu email
                  password: '', //Senha do seu Email
                  ignoreBadCertificate: true,
                  port: 587,
                ));
            print('Message sent: ' + sendReport.toString());
            // Mostrar o modal após o envio do e-mail
            showVerificationDialog(idUSer);
          } on MailerException catch (e) {
            Get.defaultDialog(title: 'error: $e', actions: [
              const Icon(Icons.error),
            ]);
            print('Message not sent.');
            for (var p in e.problems) {
              print('Problem: ${p.code}: ${p.msg}');
            }
          }
        }
      }
    } else {
      Get.defaultDialog(
        title: 'Email ou Senha incorretos!',
      );
    }
    loginIN.value = false;
  }

  void showVerificationDialog(int iduser) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 450,
            minHeight: 200,
            maxWidth: 450,
            maxHeight: 200,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Digite o código de verificação',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: verificationCodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '', // Hide the counter text
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: 'Código de 6 dígitos',
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    validateVerificationCode(iduser);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Verificar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  final verificationCodeController = TextEditingController();

  void validateVerificationCode(int idUser) async {
    String code = verificationCodeController.text.trim();
    // Suponha que você tenha um método para validar o código
    bool isValid = await PostgresConnection().validToken(idUser, code);
    if (isValid) {
      PostgresConnection().DeleteTokens(idUser, code);
      Get.off(Dashboard(
        idUser: idUser,
      ));
      } else {
        Get.defaultDialog(
        title: 'Erro!',
      );
    }
  }
}
