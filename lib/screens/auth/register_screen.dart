import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade500], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
                      Icon(Icons.person_add, size: 60, color: Colors.blue.shade800),
                      SizedBox(height: 10),
                      Text("إنشاء حساب جديد", style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      SizedBox(height: 20),
                      _buildTextField(_usernameController, "اسم المستخدم", Icons.person),
                      SizedBox(height: 10),
                      _buildTextField(_passwordController, "كلمة المرور", Icons.lock, obscureText: true),
                      SizedBox(height: 10),
                      _buildTextField(_confirmPasswordController, "تأكيد كلمة المرور", Icons.lock, obscureText: true),
                      SizedBox(height: 20),
                      _buildButton("إنشاء الحساب", Colors.blue.shade800, () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("كلمات المرور غير متطابقة")));
                            return;
                          }

                          bool success = await authProvider.register(_usernameController.text, _passwordController.text);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم إنشاء الحساب بنجاح")));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اسم المستخدم موجود مسبقًا")));
                          }
                        }
                      }),
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

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: color),
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.tajawal(fontSize: 18, color: Colors.white)),
    );
  }
}