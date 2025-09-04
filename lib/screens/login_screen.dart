import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {
  bool _obscurePassword = true; // Estado para mostrar/ocultar contraseña
  @override
  Widget build(BuildContext context) {
    //para obtener el tamaño de la pantalla del disp
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          //margen interior
          child: Padding(
        //eje horizontal/derecha izquierda
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset("animated_login_character.riv")),
            //Espacio entre el oso y el texto email
            const SizedBox(height: 15),
            //campo de texto de email
            SizedBox(
              width: 370,
              child: TextField(
                  //para que aparezca @ en moviles
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.mail),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ))),
            ),
            const SizedBox(height: 15),
            //campo de texto de la contraseña
            SizedBox(
              width: 370,
              child: TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ))),
            )
          ],
        ),
      )),
    );
  }
}
