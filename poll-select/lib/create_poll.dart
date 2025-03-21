import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pollselect/home_page.dart';

class QuestionForm extends StatefulWidget {
  const QuestionForm({super.key});

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController()
  ];

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _submitForm() async {
    final String question = _questionController.text;
    final List<String> options =
        _optionControllers.map((controller) => controller.text).toList();

    // Prepare the data in the format your backend expects
    final Map<String, dynamic> pollData = {
      "question": question,
      "options":
          options.map((option) => {"option": option, "votes": 0}).toList(),
    };

    const String url =
        'http://localhost:5000/poll/create/670ea8aab809ae662c7b3b0d'; // Update ':id'

    try {
      // Send a POST request to the backend
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(pollData),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
          backgroundColor: Colors.green,
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        // Handle failure

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to create poll'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Internal server error, Try again'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const Text(
                'Create your Poll',
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Enter your question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ..._optionControllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Option',
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _addOption,
                child: const Text(
                  '+ Add New Option',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 24, 143, 248)),
                  ),
                  onPressed: _submitForm,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Submit',
                          style: TextStyle(
                              color: Color.fromARGB(255, 24, 143, 248))),
                      SizedBox(width: 8),
                      Icon(Icons.send,
                          color: Color.fromARGB(255, 24, 143, 248)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
