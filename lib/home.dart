import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
static const platform = MethodChannel('com.example/callme');
 static const platformResult = MethodChannel('com.example.callme.result');
String responseData = '';
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
Future<void> _receiveResponse() async {
    try {
      final Map<dynamic, dynamic> response =
          await platform.invokeMethod('getResponse');
      setState(() {
        responseData = response['response'];
      });
    } on PlatformException catch (e) {
      setState(() {
        responseData = 'Failed to get response: ${e.message}';
      });
    }
  }
  @override
  void initState() {
    super.initState();
    platformResult.setMethodCallHandler((call) async {
      if (call.method == 'onActivityResult') {
        final String response = call.arguments['response'];
        setState(() {
          responseData = response;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoke Kotlin from Flutter'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          ElevatedButton(
            onPressed: () {
              invokeKotlinMethod();
            },
            child: Text('Call Kotlin method'),
          ),

  ElevatedButton(
            onPressed: () {
             _receiveResponse();
            },
            child: Text('Get Response'),
          ),


           Text('Response Data:'),
              Text(responseData),
        ],)
        
      
    );
  }
}