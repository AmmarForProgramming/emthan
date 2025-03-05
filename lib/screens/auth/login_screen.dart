import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
   
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
bool _isobsur=false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store, size: 60, color: Colors.blue.shade800),
                      SizedBox(height: 10),
                      Text(
                        "تسجيل الدخول",
                        style: GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_usernameController, "اسم المستخدم", Icons.person),
                      SizedBox(height: 10),
                      _buildPasswordTextField(),
                      //_buildTextField(_passwordController, "كلمة المرور", Icons.lock, obscureText: true),
                      SizedBox(height: 20),
                      _buildButton("تسجيل الدخول", Colors.blue.shade800, () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await authProvider.login(_usernameController.text, _passwordController.text);
                          if (success) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("بيانات غير صحيحة")));
                          }
                        }
                      }),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                        child: Text("إنشاء حساب جديد", style: GoogleFonts.tajawal(color: Colors.blue.shade900)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? "الحقل مطلوب" : null,
    );
  }

Widget _buildPasswordTextField(){
return TextFormField(
controller: _passwordController,
obscureText: !_isobsur,
 decoration: InputDecoration(
        labelText: "كلمة المرور",
        prefixIcon: Icon(Icons.lock, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(onPressed: (){
setState(() {
  _isobsur=!_isobsur;
});
        }, icon: Icon(_isobsur?Icons.visibility:Icons.visibility_off,color: Colors.blue,))
      ),
validator: (value) => value!.isEmpty ? "الحقل مطلوب" : null,
);

}


  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.tajawal(fontSize: 18, color: Colors.white)),
    );
  }
}