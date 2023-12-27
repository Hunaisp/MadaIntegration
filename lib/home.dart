import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
static const platform = MethodChannel('com.example/callme');
String outOrderNo = '10';
  String amount = '1000';
  bool isJSONOption = true; 
// Define your method to invoke the Kotlin side
void invokeKotlinMethod()async {
  // Set this based on your condition

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
          child:ElevatedButton(
            onPressed: () async {
              try {
                // Call the native Android method
                final String result = await platform.invokeMethod('callme', {
                 'outOrderNo': outOrderNo,
    'amount': amount,
    'isJSONOption': isJSONOption, // Set this based on your condition
                });

                // Display the result in Flutter
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Result from Android'),
                      content: Text(result ?? 'No data received'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              } on PlatformException catch (e) {
                print("Error: $e");
                // Handle platform exception/error
              }
            },
            child: Text('Get Result from Android'),
          ),
        
        ),
      
    );
  }
}
