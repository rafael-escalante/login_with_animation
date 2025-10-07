import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {
  bool _obscurePassword = true; // Estado para mostrar/ocultar contraseña

  //cerebro de la logica de las animaciones
  StateMachineController? controller;
  //State Machine Input
  SMIBool? isChecking; //Activa el modo chismoso
  SMIBool? isHandsUp; //Se tapa los ojos
  SMITrigger? trigSuccess; //se emociona
  SMITrigger? trigFail; //Se pone sad

  //1) FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //2)Listeners (Oyentes/Chismosos)
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        isHandsUp?.change(false);
      }
    });
    passFocus.addListener(() {
      //Manos arriba en password
      isHandsUp?.change(passFocus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    //para obtener el tamaño de la pantalla del disp
    //consulta el tamaño de la pantalla
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
                child: RiveAnimation.asset("animated_login_character.riv",
                    stateMachines: ["Login Machine"],
                    //Al iniciarse
                    onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                      artboard, "Login Machine");
                  //verificar que inicio bien
                  if (controller == null) return;
                  artboard.addController(controller!);
                  isChecking = controller!.findSMI("isChecking");
                  isHandsUp = controller!.findSMI("isHandsUp");
                  trigSuccess = controller!.findSMI("trigSuccess");
                  trigFail = controller!.findSMI("trigFail");
                })),
            //Espacio entre el oso y el texto email
            const SizedBox(height: 15),
            //campo de texto de email
            SizedBox(
              width: 370,
              child: TextField(
                  //3)Asignas el FocusNode al TextField
                  focusNode: emailFocus,
                  onChanged: (value) {
                    if (isHandsUp != null) {
                      //No tapar los ojos al escribir un mail
                      //isHandsUp!.change(false);
                    }
                    if (isChecking == null) return;
                    //Activa el modo chismoso
                    isChecking!.change(true);
                  },
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
                  //3)Asigna el FocusNode
                  focusNode: passFocus,
                  onChanged: (value) {
                    if (isChecking != null) {
                      //No tapar los ojos al escribir un mail
                      //isHandsUp!.change(false);
                    }
                    if (isHandsUp == null) return;
                    //Activa el modo chismoso
                    isHandsUp!.change(true);
                  },
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
            ),
            const SizedBox(height: 10),
            //Texto de olvide la contraseña
            SizedBox(
              width: size.width,
              child: const Text("¿Forgot your password?",
                  //alinear a la derecha+
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline)),
            ),
            //boton login
            const SizedBox(height: 10),
            //boton estilo android
            MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {},
                //TO DO
                child: Text(
                  "login",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't you have a account?",
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Register",
                          style: TextStyle(
                            color: Colors.black,
                            //en negritas
                            fontWeight: FontWeight.bold,
                            //subrayado
                            decoration: TextDecoration.underline,
                          )))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

//liberacion de recursos/ limpiez DE FOCOS
  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }
}
