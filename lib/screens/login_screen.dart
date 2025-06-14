import 'package:flutter/material.dart';
import 'home_screen.dart'; // Gerekli yolu kendi klasör yapına göre ayarla

// Figma'daki renkleri burada tanımlayabilirsiniz
const kPrimaryColor = Color(0xFF6F35A5); // Örnek bir renk
const kPrimaryLightColor = Color(0xFFF1E6FF); // Örnek bir renk

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Cihazın ekran boyutunu almak için

    return Scaffold(
      body: SingleChildScrollView( // Klavye açıldığında taşmayı önlemek için
        child: SizedBox(
          width: double.infinity,
          height: size.height,
          // Arka planı Figma'daki gibi ayarlayabilirsiniz
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/images/background.png"), // Eğer bir arka plan görseli varsa
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Uygulama Adı veya Logo
              const Text(
                "GİRİŞ YAP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: size.height * 0.03), // Boşluk

              // Figma'da bir görsel varsa ekleyebilirsiniz
              // SvgPicture.asset(
              //   "assets/icons/login.svg", // Örnek SVG
              //   height: size.height * 0.35,
              // ),
              // SizedBox(height: size.height * 0.03),

              // E-posta Giriş Alanı
              RoundedInputField(
                hintText: "E-posta Adresiniz",
                onChanged: (value) {},
              ),
              SizedBox(height: size.height * 0.01),

              // Şifre Giriş Alanı
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              SizedBox(height: size.height * 0.02),

              // Giriş Butonu
            RoundedButton(
              text: "GİRİŞ YAP",
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),

              SizedBox(height: size.height * 0.03),

              // Zaten hesabın var mı? Kayıt ol
              AlreadyHaveAnAccountCheck(
                press: () {
                  // Kayıt ol ekranına yönlendirme
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tekrar kullanılabilir bir giriş alanı widget'ı
class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.email, // Varsayılan ikon
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// Tekrar kullanılabilir bir şifre alanı widget'ı
class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    super.key,
    required this.onChanged,
  });

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
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Şifre",
          icon: const Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: kPrimaryColor,
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


// Tekrar kullanılabilir bir buton widget'ı
class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
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

// "Zaten hesabın var mı?" widget'ı
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
          login ? "Hesabın yok mu ? " : "Zaten bir hesabın var mı ? ",
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Kayıt Ol" : "Giriş Yap",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

// Giriş alanlarını sarmalayan container
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}




