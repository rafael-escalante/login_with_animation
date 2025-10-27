import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  //Cerebro de la lógica de las animaciones
  StateMachineController? controller;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook;

  //FocusNodes
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //Timers
  Timer? _typingDebounce;

  //Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  //Errores para mostrar en la UI
  String? emailError;
  String? passError;

  //Estado de carga y captcha
  bool isLoading = false;
  bool captchaChecked = false;

  //Validadores
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    final re =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return re.hasMatch(pass);
  }

  //Valida condiciones individuales para checklist dinámico
  bool hasMinLength(String pass) => pass.length >= 8;
  bool hasUppercase(String pass) => pass.contains(RegExp(r'[A-Z]'));
  bool hasLowercase(String pass) => pass.contains(RegExp(r'[a-z]'));
  bool hasNumberAndSymbol(String pass) =>
      pass.contains(RegExp(r'\d')) && pass.contains(RegExp(r'[^A-Za-z0-9]'));

  //Acción al presionar Login
  Future<void> _onLogin() async {
    if (isLoading) return;

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    final eError = email.isEmpty
        ? "El email no puede estar vacío"
        : (isValidEmail(email) ? null : "Email inválido");

    final pError = pass.isEmpty
        ? "La contraseña no puede estar vacía"
        : (isValidPassword(pass)
            ? null
            : "Contraseña inválida, revisa los requisitos");

    final success =
        (eError == null && pError == null && captchaChecked == true);

    setState(() {
      emailError = eError;
      passError = pError;
      isLoading = true;
    });

    //Cerrar teclado y bajar las manos
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0;

    //Esperar un frame antes del trigger
    await Future.delayed(const Duration(milliseconds: 100));

    //Simular carga
    await Future.delayed(const Duration(seconds: 1));

    //Disparar animación
    if (success) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }

    // 🔹 Reiniciar el captcha después de cada intento
    setState(() {
      captchaChecked = false;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        isHandsUp?.change(false);
        numLook?.value = 50;
      }
    });

    passFocus.addListener(() {
      isHandsUp?.change(passFocus.hasFocus);
    });

    //Validación en vivo email
    emailCtrl.addListener(() {
      final email = emailCtrl.text.trim();
      setState(() {
        if (email.isEmpty) {
          emailError = null;
        } else if (!isValidEmail(email)) {
          emailError = "Email inválido";
        } else {
          emailError = null;
        }
      });
    });

    //Validación en vivo password
    passCtrl.addListener(() {
      setState(() {
        final pass = passCtrl.text;
        if (pass.isEmpty) {
          passError = null;
        } else if (!isValidPassword(pass)) {
          passError = "Contraseña inválida, revisa los requisitos";
        } else {
          passError = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/animated_login_character.riv',
                    stateMachines: ["Login Machine"],
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                        artboard,
                        "Login Machine",
                      );
                      if (controller == null) return;
                      artboard.addController(controller!);
                      isChecking = controller!.findSMI('isChecking');
                      isHandsUp = controller!.findSMI('isHandsUp');
                      trigSuccess = controller!.findSMI('trigSuccess');
                      trigFail = controller!.findSMI('trigFail');
                      numLook = controller!.findSMI('numLook');
                    },
                  ),
                ),
                const SizedBox(height: 10),

                //EMAIL
                TextField(
                  focusNode: emailFocus,
                  controller: emailCtrl,
                  onChanged: (value) {
                    isChecking?.change(true);
                    final look =
                        (value.length / 70.0 * 100.0).clamp(0.0, 100.0);
                    numLook?.change(look);

                    _typingDebounce?.cancel();
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      if (!mounted) return;
                      isChecking?.change(false);
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorText: emailError,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                //PASSWORD
                TextField(
                  focusNode: passFocus,
                  controller: passCtrl,
                  onChanged: (value) {
                    if (isHandsUp == null) return;
                    isHandsUp!.change(true);
                  },
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    errorText: passError,
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                //Checklist dinámico
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckItem(
                        "Mínimo 8 caracteres", hasMinLength(passCtrl.text)),
                    _buildCheckItem(
                        "1 letra mayúscula", hasUppercase(passCtrl.text)),
                    _buildCheckItem(
                        "1 letra minúscula", hasLowercase(passCtrl.text)),
                    _buildCheckItem("1 número y 1 carácter especial",
                        hasNumberAndSymbol(passCtrl.text)),
                  ],
                ),

                const SizedBox(height: 10),

                //Captcha simulado
                CheckboxListTile(
                  title: const Text("No soy un robot 🤖"),
                  value: captchaChecked,
                  onChanged: (value) {
                    setState(() {
                      captchaChecked = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.purple,
                ),

                //Forgot password
                SizedBox(
                  width: size.width,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                //Botón de Login
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : _onLogin,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("New here?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Widget auxiliar para checklist
  Widget _buildCheckItem(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  void dispose() {
    passCtrl.dispose();
    emailCtrl.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
