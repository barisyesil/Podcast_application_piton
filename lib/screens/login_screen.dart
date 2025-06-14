import 'package:flutter/material.dart';
import 'home_screen.dart'; // Gerekli dosya yolunu ayarla

// ---- Renk Teması ----
const kDarkBackground = Color(0xFF121212);
const kInputFill = Color(0xFF1E1E1E);
const kAccentColor = Color(0xFFCF9645);
const kTextColor = Colors.white;
const kHintColor = Colors.white60;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kDarkBackground,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "PODKES",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: kAccentColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Giriş Yap",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.05),

              RoundedInputField(
                hintText: "E-posta Adresiniz",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "GİRİŞ YAP",
                press: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              AlreadyHaveAnAccountCheck(
                press: () {
                  // Kayıt ol ekranına yönlendir
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Giriş Alanı Container ----
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kInputFill,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

// ---- E-posta Giriş Alanı ----
class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.email,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kAccentColor,
        style: const TextStyle(color: kTextColor),
        decoration: InputDecoration(
          icon: Icon(icon, color: kAccentColor),
          hintText: hintText,
          hintStyle: const TextStyle(color: kHintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ---- Şifre Giriş Alanı ----
class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({super.key, required this.onChanged});

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _isObscure,
        onChanged: widget.onChanged,
        cursorColor: kAccentColor,
        style: const TextStyle(color: kTextColor),
        decoration: InputDecoration(
          hintText: "Şifre",
          hintStyle: const TextStyle(color: kHintColor),
          icon: const Icon(Icons.lock, color: kAccentColor),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: kAccentColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ---- Giriş Butonu ----
class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;

  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kAccentColor,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
            elevation: 5,
            shadowColor: color.withOpacity(0.5),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ---- "Hesabın yok mu?" ----
class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;

  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Hesabın yok mu? " : "Zaten bir hesabın var mı? ",
          style: const TextStyle(color: kHintColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Kayıt Ol" : "Giriş Yap",
            style: const TextStyle(
              color: kAccentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
