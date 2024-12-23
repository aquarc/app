import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SatPage extends StatefulWidget {
    @override
    _SatPageState createState() => _SatPageState();
}

class _SatPageState extends State<SatPage> {
    static const difficulties = [
        "Easy",
        "Medium",
        "Hard",
    ];
    var category = <Category>[
        Category("Reading and Writing", <Section>[
            Section("Information and Ideas", [
                "Inferences",
                "Central Ideas and Details",
                "Command of Evidence",
            ]),
            Section("Craft and Structure", [
                "Words in Context",
                "Text Structure and Purpose",
                "Cross-Text Connections",
            ]),
            Section("Expression of Ideas", [
                "Rhetorical Synthesis",
                "Transitions",
            ]),
            Section("Standard English Conventions", [
                "Boundaries",
                "Form, Structure, and Sense",
            ]),
        ]),
        Category("Math", <Section>[
            Section("Algebra", [
                
            ]),
            Section("Advanced Math", [

            ]),
            Section("Problem-Solving and Data Analysis", [

            ]),
            Section("Geometry and Trigonometry", [

            ]),
        ]),
    ];

    Future<void> _fetchData() async {
        try {
            final response = await http.get(Uri.parse('https://aquarc.org/'));

            if (response.statusCode == 200) {
                // Request successful
                print('Request successful');
            } else {
                // Request failed
                print('Request failed');
            }
        } catch (e) {
            // Request failed
            print('Request failed');
        }
    }

    @override
    Widget build(BuildContext context) {
      return Container();
    }
}

class Category {
    String name= "";
    List<Section> sections = [];

    Category(String name, List<Section> sections) {
        this.name = name;
        this.sections = sections;
    }
} 
    
class Section {
    String name = "";
    List<String> subdomains = [""];

    Section(String name, List<String> subdomains) {
        this.name = name;
        this.subdomains = subdomains;
    }
}
