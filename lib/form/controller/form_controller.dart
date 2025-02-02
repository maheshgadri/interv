

import 'package:inte/API/model/ChatModel.dart';
import 'package:inte/API/view/ApiService.dart';
import 'package:inte/intchat/view/intcha.dart';

import '../model/form_model.dart';


// class FormController {
//   FormData formData = FormData();
//
//
//   void submitForm() {
//     // Here you can implement logic to submit the form data
//     print('Form submitted!');
//     print('First Name: ${formData.firstName}');
//     print('Last Name: ${formData.lastName}');
//     print('Designation: ${formData.designation}');
//     print('Industry: ${formData.industry}');
//     print('Years of Experience: ${formData.yearsOfExperience}');
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inte/form/model/form_model.dart' as InteForm;

class FormController extends GetxController {
  final InteForm.FormData formData = InteForm.FormData(); // Instance of FormData

  Future<void> submitForm() async {
    // Prepare data to send to ChatGPT
    String prompt =
        'First Name: ${formData.firstName}\n'
        'Last Name: ${formData.lastName}\n'
        'Designation: ${formData.designation}\n'
        'Industry: ${formData.industry}\n'
        'Years of Experience: ${formData.yearsOfExperience}\n'
        'greet candidate with short note chatbot chat dont include Thank you and looking forward to hearing back from you, Best regards, etc and ask about the project';

    try {
      // Send data to ChatGPT and handle responses
      List<ChatModel> responses = await ApiService.sendMessage(
        message: prompt,
        modelId: 'gpt-3.5-turbo-0301',
      );

      // Extract messages from responses
      List<String> messages = responses.map((e) => e.msg).toList();

      // Print OpenAI response
      print('OpenAI Response:');
      messages.forEach((message) {
        print(message);
      });

      // Navigate to chat screen with form data and responses
      Get.to(() => ChatScreen(messages: messages));
    } catch (e) {
      // Handle errors
      Get.dialog(
        AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
