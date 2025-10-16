import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
//3.1 Importar libreria para Timer
import "dart:async";

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
  //2.1 variable para recorrido de la mirada
  SMINumber? numLook; // 0..80 en tu asset

  //1) FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //3.2 Timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  //4.1 Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  //4.2 Errores para mostrar en la UI
  String? emailError;
  String? passError;

  //4.3 Validadores
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  //4.4 Accion al botón de iniciar sesión
  void _onLogin() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    //Recalcular errores

    final eError = isValidEmail(email) ? null : "Email inválido";
    final pError = isValidPassword(pass)
        ? null
        : "Mínimo 8 caracteres, 1 mayúscula, 1 minuscula, 1 numero y 1 caracter especial";

    //4.5para avisar que hubo un cambio
    setState(() {
      emailError = eError;
      passError = pError;
    });

    //4.6 Cerrar el teclado y bajar
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0; //Mirada neutral al liberar el teclado

    // 4,7  Activar triggers
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
  }

  //2.1)Listeners (Oyentes/Chismosos)
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        isHandsUp?.change(false);
        //2.2 Mirada neutral al enfocar email
        numLook?.value = 50.0;
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
                  //2.3 Enlazar la variable con la animación
                  numLook = controller!.findSMI("numLook");
                })),
            //Espacio entre el oso y el texto email
            const SizedBox(height: 15),
            //campo de texto de email
            SizedBox(
              width: 370,
              child: TextField(
                  //3)Asignas el FocusNode al TextField
                  focusNode: emailFocus,
                  //4.8 Enlazar controller al TextField
                  controller: emailCtrl,
                  onChanged: (value) {
                    //2.4 implementando numLook
                    //"Estoy escribiendo"
                    isChecking!.change(true);

                    //Ajuste de limites de 0 a 100
                    //80 es una medida de calibracion
                    final look =
                        (value.length / 80.0 * 100.0).clamp(0.0, 100.0);
                    numLook?.value = look;

                    //3.3 Debounce: si vuelve a teclear, reinicia el contador
                    _typingDebounce
                        ?.cancel(); //cancela cualquier timer existente
                    _typingDebounce = Timer(const Duration(seconds: 2), () {
                      if (!mounted) {
                        return; //si la pantalla se cierra
                      }
                      //mirada neutra
                      isChecking?.change(false);
                    });

                    if (isChecking == null) return;
                    //Activa el modo chismoso
                    isChecking!.change(true);
                  },
                  //para que aparezca @ en moviles
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      //4.9 Mostrar el texto del error
                      errorText: emailError,
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
                  //4.8 Enlazar controller al TextField
                  controller: passCtrl,
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
                      errorText: passError,
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
                //4.10 Llamar funcion de login
                onPressed: _onLogin,
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

// 1.4 liberacion de recursos/ limpiez DE FOCOS
  @override
  void dispose() {
    //4.11 Limpieza de los controllers
    emailCtrl.dispose();
    passCtrl.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
