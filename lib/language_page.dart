import 'package:flutter/material.dart';
import 'package:flutter_project/authpage/signin_page.dart';
import 'package:flutter_project/images.dart';
import 'package:google_fonts/google_fonts.dart';
class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  String selectedLang = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),

              // Logo

              Image.asset(AppImages.Toplogo,height: 200,width: 150,),


              const SizedBox(height: 20),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select language",
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ),const SizedBox(height: 10,),
              languageField(),
              SizedBox(height: 300,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SigninPage()),
                    );
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget languageField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLang,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(value: "English", child: Text("English")),
            DropdownMenuItem(value: "বাংলা", child: Text("বাংলা")),
          ],
          onChanged: (value) {
            setState(() {
              selectedLang = value!;
            });
          },
        ),
      ),
    );
  }

}


