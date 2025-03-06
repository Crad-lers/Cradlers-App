import 'package:flutter/material.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String? selectedLanguage = 'English'; // Default selection, you can save this preference using SharedPreferences or a similar approach

  @override
  Widget build(BuildContext context) {
    final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese']; // Example languages

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor: Colors.blue, // Or any other appropriate color
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(languages[index]),
              trailing: selectedLanguage == languages[index] ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() {
                  selectedLanguage = languages[index];
                  // Here you would also call your logic to change the app's language
                  print('Language changed to ${languages[index]}');
                });
              },
            ),
          );
        },
      ),
    );
  }
}
