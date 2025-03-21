import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SatisfactionSurvey extends StatefulWidget {
  final Map<String, dynamic> poll; // Accept the poll data

  const SatisfactionSurvey({super.key, required this.poll});

  @override
  _SatisfactionSurveyState createState() => _SatisfactionSurveyState();
}

class _SatisfactionSurveyState extends State<SatisfactionSurvey> {
  int _selectedOption = -1;
  bool _isSubmitting = false; // To handle submit button state

  // Function to submit the vote
  Future<void> submitVote() async {
    setState(() {
      _isSubmitting = true; // Show loading indicator when submitting
    });

    final pollId = widget.poll['_id'];

    final url = Uri.parse(
        'http://localhost:5000/poll/vote/$pollId'); // API endpoint for submitting vote
    final body = json.encode({
      'optionIndex': _selectedOption, // Send the selected option index
    });
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json', // Set content type
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally, you could navigate back or refresh the poll after the vote.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit vote'),
              backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Stop the loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> options = widget.poll['options']; // Access poll options

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              widget.poll['question'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Display options from the poll data
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    value: index,
                    groupValue: _selectedOption,
                    title:
                        Text(options[index]['option']), // Display option text
                    onChanged: (int? value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 40,
                  width: 132,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isSubmitting
                        ? null // Disable button while submitting
                        : () {
                            if (_selectedOption != -1) {
                              submitVote(); // Submit the selected option (vote)
                            } else {
                              // Show a message if no option is selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please select an option to vote."),
                                ),
                              );
                            }
                          },
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.send),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
