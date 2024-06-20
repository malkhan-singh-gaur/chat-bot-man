import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isHint;

  const MessageBox({
    super.key,
    required this.text,
    required this.isUser,
    required this.isHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: isHint
            ? Colors.grey.shade300
            : isUser
                ? Colors.greenAccent
                : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: const [BoxShadow(color: Colors.grey)],
      ),
      child: Padding(padding: const EdgeInsets.all(4.0), child: Text(text)),
    );
  }
}

// class ResponseMessageBox extends StatefulWidget {
//   final String text;

//   const ResponseMessageBox({
//     super.key,
//     required this.text,
//   });

//   @override
//   State<ResponseMessageBox> createState() => _ResponseMessageBoxState();
// }

// class _ResponseMessageBoxState extends State<ResponseMessageBox> {
//   int _currentCharIndex = 0;

//   // creating a function and future delay for iteration
//   void _typeWrittingAnimation() {
//     for (int i = 0;
//         _currentCharIndex < widget.text.length;
//         _currentCharIndex++) {
//       setState(() {});
//       Future.delayed(const Duration(milliseconds: 50));
//     }
//   }

//   @override
//   void initState() {
//     _typeWrittingAnimation();
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     _typeWrittingAnimation();
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(5),
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         boxShadow: [BoxShadow(color: Colors.grey)],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Text(widget.text.substring(0, _currentCharIndex)),
//       ),
//     );
//   }
// }
