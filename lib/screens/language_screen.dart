import 'package:flutter/material.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String? selectedLanguage = 'English';
  final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: const Color(0xFF39CCCC), // Your theme color
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: languages.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final lang = languages[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLanguage = lang;
                  print('Language changed to $lang');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(lang, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: selectedLanguage == lang
                      ? Icon(Icons.check_circle, color: Color(0xFF39CCCC))
                      : Icon(Icons.radio_button_off, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFFDF5FB), // Match the soft background tone
    );
  }
}
