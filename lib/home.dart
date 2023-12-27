import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
static const platform = MethodChannel('com.example/callme');

// Define your method to invoke the Kotlin side
void invokeKotlinMethod()async {
  String outOrderNo = '10';
  String amount = '1000';
  bool isJSONOption = true; // Set this based on your condition

  // Prepare arguments to pass to the Kotlin side
  Map<String, dynamic> arguments = {
    'outOrderNo': outOrderNo,
    'amount': amount,
    'isJSONOption': isJSONOption, // Pass the JSON option flag
  };

  try {
    // Invoke the method on the Kotlin side with the arguments
    final String result = await platform.invokeMethod('callme', arguments);
    print('Result from Kotlin: $result');
  } catch (e) {
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoke Kotlin from Flutter'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              invokeKotlinMethod();
            },
            child: Text('Call Kotlin method'),
          ),
        ),
      
    );
  }
}
