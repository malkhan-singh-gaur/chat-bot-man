import 'dart:math';

import 'package:example/resources/qns.dart';
import 'package:example/widgets/message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();

  bool isStarted = false;

  String questionAsked = '';
  String answerGiven = '';
  List<String> followupQuestions = [];

  Flutter3DController controller = Flutter3DController();
  List<String> animations = [];
  String? chosenAnimation;
  String? chosenTexture;

  Future moveCameraBetter() async {
    controller.setCameraTarget(0, 1, -2.2);
    animations = await controller.getAvailableAnimations();

    controller.playAnimation(animationName: animations[0]);
  }

  onHintMessageTap(String question) async {
    questionAsked = question;
    answerGiven = 'Thinking...';
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));

    if (interactionMap.containsKey(question)) {
      List<String> answers = interactionMap[question]!['answers']!;
      if (answers.length == 1) {
        answerGiven = interactionMap[question]!['answers']![0];
      } else {
        int random =
            Random().nextInt(interactionMap[question]!['answers']!.length);
        answerGiven = interactionMap[question]!['answers']![random];
      }
      followupQuestions = interactionMap[question]!['followingQuestions']!;
    } else {
      answerGiven =
          "Sorry, i didn't found respont to this question. Let's Start again.";
      followupQuestions.clear();
    }
    // controller.playAnimation(animationName: animations[1]);
    await flutterTts.speak(answerGiven);

    controller.playAnimation(animationName: animations[0]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Flutter3DViewer(
              //If you don't pass progressBarColor the color of defaultLoadingProgressBar will be grey.
              //You can set your custom color or use [Colors.transparent] for hiding loadingProgressBar.
              progressBarColor: Colors.blue,
              controller: controller,
              src: 'assets/business_man.glb',
              //3D model with different animations
              // src: 'assets/sheen_chair.glb', //3D model with different textures
              // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb', // 3D model from URL
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                if (questionAsked.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBox(
                      text: questionAsked,
                      isUser: true,
                      isHint: false,
                    ),
                  ),
                if (answerGiven.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBox(
                      text: answerGiven,
                      isUser: false,
                      isHint: false,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              if (followupQuestions.isEmpty)
                InkWell(
                  onTap: () async {
                    flutterTts.stop();
                    await moveCameraBetter();
                    controller.playAnimation(animationName: animations[0]);
                    onHintMessageTap('Hello there');
                  },
                  child: const MessageBox(
                    text: 'Hello there',
                    isUser: false,
                    isHint: true,
                  ),
                )
              else
                for (var quesiton in followupQuestions)
                  InkWell(
                    onTap: () async {
                      await flutterTts.stop();
                      controller.playAnimation(animationName: animations[0]);
                      onHintMessageTap(quesiton);
                    },
                    child: MessageBox(
                      text: quesiton,
                      isUser: false,
                      isHint: true,
                    ),
                  ),
            ],
          ),
        ),
      ),

      //floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton.small(
      //       onPressed: () async {
      //         if (animations.isNotEmpty) {
      //           controller.playAnimation(animationName: animations[1]);
      //         } else {
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             const SnackBar(content: Text('No animations Found')),
      //           );
      //         }
      //       },
      //       child: const Icon(Icons.play_arrow),
      //     ),
      //   ],
      // ),
    );
  }

  // Future<String?> showPickerDialog(List<String> inputList,
  //     [String? chosenItem]) async {
  //   return await showModalBottomSheet<String>(
  //       context: context,
  //       builder: (ctx) {
  //         return SizedBox(
  //           height: 250,
  //           child: ListView.separated(
  //             itemCount: inputList.length,
  //             padding: const EdgeInsets.only(top: 16),
  //             itemBuilder: (ctx, index) {
  //               return InkWell(
  //                 onTap: () {
  //                   Navigator.pop(context, inputList[index]);
  //                 },
  //                 child: Container(
  //                   height: 50,
  //                   padding: const EdgeInsets.all(16),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text('${index + 1}'),
  //                       Text(inputList[index]),
  //                       Icon(chosenItem == inputList[index]
  //                           ? Icons.check_box
  //                           : Icons.check_box_outline_blank)
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (ctx, index) {
  //               return const Divider(
  //                 color: Colors.grey,
  //                 thickness: 0.6,
  //                 indent: 10,
  //                 endIndent: 10,
  //               );
  //             },
  //           ),
  //         );
  //       });
  // }
}
