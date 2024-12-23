import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'dart:convert';

class SatPage extends StatefulWidget {
    @override
    _SatPageState createState() => _SatPageState();
}

class _SatPageState extends State<SatPage> {
    HashSet<String> _selectedSubdomains = HashSet<String>();
    HashSet<String> _selectedDifficulties = HashSet<String>();
    List<Question> _questions = [];

    bool _difficultyIsExpanded = false;

    static const difficulties = [
        "Easy",
        "Medium",
        "Hard",
    ];
    var category = <Category>[
        Category("Reading and Writing", <Subcategory>[
            Subcategory("Information and Ideas", [
                "Inferences",
                "Central Ideas and Details",
                "Command of Evidence",
            ]),
            Subcategory("Craft and Structure", [
                "Words in Context",
                "Text Structure and Purpose",
                "Cross-Text Connections",
            ]),
            Subcategory("Expression of Ideas", [
                "Rhetorical Synthesis",
                "Transitions",
            ]),
            Subcategory("Standard English Conventions", [
                "Boundaries",
                "Form, Structure, and Sense",
            ]),
        ]),
        Category("Math", <Subcategory>[
            Subcategory("Algebra", [
                "Linear equations in two variables",
                "Linear inequalities in one or two variables",
                "Systems of two linear equations in two variables",
                "Linear functions",
                "Linear equations in one variable",
            ]),
            Subcategory("Advanced Math", [
                "Nonlinear functions",
                "Equivalent expressions",
                "Nonlinear equations in one variable and systems of equations in two variables",
            ]),
            Subcategory("Problem-Solving and Data Analysis", [
                "Inference from sample statistics and margin of error",
                "Ratios, rates, proportional relationships, and units",
                "Probability and conditional probability",
                "Percentages",
                "Two-variable data: Models and scatterplots",
                "One-variable data: Distributions and measures of center and spread",
                "Evaluating statistical claims: Observational studies and experiments",
            ]),
            Subcategory("Geometry and Trigonometry", [
                "Lines, angles, and triangles",
                "Right triangles and trigonometry",
                "Area and volume",
                "Circles",
            ]),
        ]),
    ];

    Future<void> _fetchData() async {
        try {
          // Build the request payload as JSON
          Map<String, dynamic> requestPayload = {
            'subdomain': _selectedSubdomains.toList(),
            'difficulty': _selectedDifficulties.toList(),
            'test': 'SAT',
          };
          print(json.encode(requestPayload));

          // Make a POST request to fetch questions
          final response = await http.post(
            Uri.parse('https://aquarc.org/sat/find-questions-v2'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestPayload), // Send the payload as JSON
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body); // Parse the JSON response
            print(data);
            setState(() {
              _questions = data.map<Question>((question) => 
                Question.fromJson(question)).toList(); 
            });
            print('Questions fetched successfully');

            // now close all open ExpansionTiles
            setState(() {
                for (var openTile in category) {
                    openTile.isExpanded = false;
                }
                _difficultyIsExpanded = false;
                print(_difficultyIsExpanded);
            });


          } else {
            print('Failed to load questions: ${response.statusCode}');
          }
      } catch (e) {
        print('Error fetching questions: $e');
      }
  }

    Widget _buildDifficultySelector() {
        return ExpansionTile(
            key: GlobalKey(),
            title: Text('Difficulty'),
            initiallyExpanded: _difficultyIsExpanded,
            onExpansionChanged: (bool value) {
                setState(() {
                    _difficultyIsExpanded = value;
                });
            },
            children: difficulties.map((difficulty) => 
                CheckboxListTile(
                    title: Text(difficulty),
                    value: _selectedDifficulties.contains(difficulty),
                    onChanged: (bool? value) {
                        setState(() {
                            if (value == true) {
                                _selectedDifficulties.add(difficulty);
                            } else {
                                _selectedDifficulties.remove(difficulty);
                            }
                        });
                    },
                )).toList(),
        );
    }

    Widget _loadAnswerChoices() {
        if (_questions[0].answerChoices != null 
            && _questions[0].answerChoices!.isNotEmpty) {
            return Column(children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                        setState(() {
                            
                        });
                    },
                    child: HtmlWidget(
                        _questions[0].answerChoices![0].content,
                        textStyle: TextStyle(fontSize: 18.0),
                    ),
                ),
                ElevatedButton(
                    onPressed: () {
                        setState(() {
                            
                        });
                    },
                    child: HtmlWidget(
                        _questions[0].answerChoices![1].content,
                        textStyle: TextStyle(fontSize: 18.0),
                    ),
                ),
                ElevatedButton(
                    onPressed: () {
                        setState(() {
                            
                        });
                    },
                    child: HtmlWidget(
                        _questions[0].answerChoices![2].content,
                        textStyle: TextStyle(fontSize: 18.0),
                    ),
                ),
                ElevatedButton(
                    onPressed: () {
                        setState(() {
                            
                        });
                    },
                    child: HtmlWidget(
                        _questions[0].answerChoices![3].content,
                        textStyle: TextStyle(fontSize: 18.0),
                    ),
                ),
            ]);
        } else {
            return Text("LMAO");
        }
    } 

    Widget _buildQuestionDisplay() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _questions.isNotEmpty 
                ? Column(
                    children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                        ),
                        HtmlWidget(
                            _questions[0].details,
                            textStyle: const TextStyle(
                                fontSize: 16,
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                        ),
                        HtmlWidget(
                            _questions[0].question,
                            textStyle: const TextStyle(
                                fontSize: 16,
                            ),
                        ),
                    ],

                )
                : Text("Pick a question!"),
            );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('SAT'),
            ),
            body: ListView(
                children: [
                    ...category.map((category) => 
                        category.build(_selectedSubdomains, setState)).toList(),
                    _buildDifficultySelector(),
                    ElevatedButton(
                        onPressed: _fetchData,
                        child: Text('Fetch Questions'),
                    ),
                    _buildQuestionDisplay(),
                    _loadAnswerChoices(),
                ],
            ),
        );
    }
}

class Category {
    String name= "";
    List<Subcategory> subcategories = [];

    bool isExpanded = true;

    Category(String name, List<Subcategory> subcategories) {
        this.name = name;
        this.subcategories = subcategories;
    }

    Widget build(HashSet<String> _selectedSubdomains, Function setState) {
        return ExpansionTile(
            key: GlobalKey(),
            title: Text(name),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool value) {
                setState(() {
                    isExpanded = value;
                });
            },
            children: subcategories.map((subcategory) => 
                subcategory.build(_selectedSubdomains, setState)).toList(),
        );
    }
} 
    
class Subcategory {
    String name = "";
    List<String> subdomains = [""];

    Subcategory(String name, List<String> subdomains) {
        this.name = name;
        this.subdomains = subdomains;
    }

    Widget build(HashSet<String> _selectedSubdomains, Function setState) {
        return Column(
          children: [
            // Text displaying the subcategory name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,  // Display the name of the subcategory
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            
            // List of checkboxes for subdomains
            ...subdomains.map((subdomain) => CheckboxListTile(
                  title: Text(subdomain),
                  value: _selectedSubdomains.contains(subdomain),  // Default value for checkboxes
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedSubdomains.add(subdomain);
                      } else {
                        _selectedSubdomains.remove(subdomain);
                      }
                    });
                  },
                )).toList(),
          ],
        );
    }
}

class Question {
    String questionId = "";
    String id = "";
    String test = "";
    String category = "";
    String domain = "";
    String skill = "";
    String difficulty = "";
    String details = "";
    String question = "";
    List<AnswerChoice>? answerChoices;
    String answer = "";
    String rationale = "";

    Question({
        required this.questionId,
        required this.id,
        required this.test,
        required this.category,
        required this.domain,
        required this.skill,
        required this.difficulty,
        required this.details,
        required this.question,
        this.answerChoices,
        required this.answer,
        required this.rationale,
    });

    // convert from JSON
    factory Question.fromJson(Map<String, dynamic> json) {
        return Question(
            questionId: json['questionId'] ?? '',
            id: json['id'] ?? '',
            test: json['test'] ?? '',
            category: json['category'] ?? '',
            domain: json['domain'] ?? '',
            skill: json['skill'] ?? '',
            difficulty: json['difficulty'] ?? '',
            details: json['details'] ?? '',
            question: json['question'] ?? '',
            answerChoices: (jsonDecode(json['answerChoices']) as List<dynamic>?)
              ?.map((choice) => AnswerChoice.fromJson(choice as Map<String, dynamic>))
              .toList(),
            answer: json['answer'] ?? '',
            rationale: json['rationale'] ?? '',
        );
    }
}

class AnswerChoice {
    String id = "";
    String content = "";

    AnswerChoice({
        required this.id,
        required this.content,
    });

    // convert from JSON
    factory AnswerChoice.fromJson(Map<String, dynamic> json) {
        return AnswerChoice(
            id: json['id'] ?? '',
            content: json['content'] ?? '',
        );
    }
}

