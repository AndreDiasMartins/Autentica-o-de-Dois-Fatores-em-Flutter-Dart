import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_auth/login_controller.dart';

class LoginStream extends StatelessWidget {
  const LoginStream({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: 450, minHeight: 450, maxHeight: 450, maxWidth: 450),
          child: Card(
              shadowColor: Colors.purple,
              elevation: 60,
              color: Colors.black,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.png'),
                        radius: 50,
                      ),
                      const Text(
                        'Welcome sr',
                        style: TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: TextField(
                          onChanged: (value) => controller.email.value = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purple,
                                      style: BorderStyle.solid)),
                              label: Text("Email"),
                              hintText: 'Your Email',
                              suffixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Padding( 
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: TextField(
                          onChanged: (value) => controller.senha.value = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Password"),
                              hintText: 'Your Password',
                              suffixIcon: Icon(
                                Icons.key,
                                color: Colors.white,
                              )),
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: SizedBox.fromSize(
                          size: const Size.fromHeight(40),
                          child: Obx(() => ElevatedButton(
                              onPressed: controller.loginIN.isTrue? null: () {
                                controller.SendEmail();
                              },
                              child: controller.loginIN.isTrue? const Center(child: CircularProgressIndicator(),): const Text("Login")),),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
