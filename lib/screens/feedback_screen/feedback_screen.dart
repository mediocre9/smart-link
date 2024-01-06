import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_link/common/common.dart';
import 'package:smart_link/screens/feedback_screen/cubit/feedback_cubit.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with StandardAppWidgets {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Feedback"),
          actions: [
            BlocConsumer<FeedbackCubit, FeedbackState>(
              listener: (context, state) {
                if (state is Submitted) {
                  showSnackBarWidget(context, state.message);
                }

                if (state is Error) {
                  showSnackBarWidget(context, state.message);
                }
              },
              builder: (context, state) {
                switch (state) {
                  case FeedbackInitial():
                    return IconButton(
                      onPressed: null,
                      icon: Icon(Icons.send_rounded, color: state.color),
                    );

                  case EmptyFieldsState():
                    return IconButton(
                      icon: Icon(Icons.send_rounded, color: state.color),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await context.read<FeedbackCubit>().submitFeedback(
                              _subjectController.text,
                              _bodyController.text,
                            );
                        _clearTextFields();
                      },
                    );

                  case Loading():
                    return Transform.scale(
                      scale: 0.7,
                      child: CircularProgressIndicator(color: state.color),
                    );

                  default:
                    return Container();
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Subject (required)",
                ),
                maxLength: 70,
                controller: _subjectController,
                onChanged: (_) {
                  context.read<FeedbackCubit>().isRequiredFeedbackEmpty(
                        _subjectController.text,
                        _bodyController.text,
                      );
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Body (required)",
                ),
                maxLines: 5,
                controller: _bodyController,
                onChanged: (_) {
                  context.read<FeedbackCubit>().isRequiredFeedbackEmpty(
                        _subjectController.text,
                        _bodyController.text,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
  }

  void _clearTextFields() {
    _subjectController.clear();
    _bodyController.clear();
  }
}













// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_link/common/common.dart';
// import 'package:smart_link/screens/feedback_screen/cubit/feedback_cubit.dart';

// class FeedbackScreen extends StatefulWidget {
//   const FeedbackScreen({super.key});

//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen>
//     with StandardAppWidgets {
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Feedback"),
//           actions: [
//             BlocConsumer<FeedbackCubit, FeedbackState>(
//               listener: (context, state) {
//                 if (state is Submitted) {
//                   showSnackBarWidget(context, state.message);
//                 }
//               },
//               builder: (context, state) {
//                 switch (state) {
//                   case FeedbackInitial():
//                     return IconButton(
//                       onPressed: null,
//                       icon: Icon(Icons.send_rounded, color: state.color),
//                     );

//                   case NonEmptyState():
//                     return IconButton(
//                       icon: Icon(Icons.send_rounded, color: state.color),
//                       onPressed: () async {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         await context.read<FeedbackCubit>().submitFeedback(
//                               _subjectController.text,
//                               _bodyController.text,
//                             );
//                         _clearTextFields();
//                       },
//                     );

//                   case Loading():
//                     return Transform.scale(
//                       scale: 0.7,
//                       child: CircularProgressIndicator(color: state.color),
//                     );

//                   default:
//                     return Container();
//                 }
//               },
//             )
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextField(
//                 decoration:
//                     const InputDecoration(hintText: "Subject (required)"),
//                 maxLength: 70,
//                 controller: _subjectController,
//                 onChanged: (_) {
//                   context.read<FeedbackCubit>().isRequiredFeedbackEmpty(
//                         _subjectController.text,
//                         _bodyController.text,
//                       );
//                 },
//               ),
//               TextField(
//                 decoration: const InputDecoration(hintText: "Body (required)"),
//                 maxLines: 5,
//                 controller: _bodyController,
//                 onChanged: (_) {
//                   context.read<FeedbackCubit>().isRequiredFeedbackEmpty(
//                         _subjectController.text,
//                         _bodyController.text,
//                       );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   validateRequiredFields(BuildContext context) {

//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _subjectController.dispose();
//     _bodyController.dispose();
//   }

//   void _clearTextFields() {
//     _subjectController.clear();
//     _bodyController.clear();
//   }
// }
