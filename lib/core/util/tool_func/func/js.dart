part of '../tool.dart';

// final class _RunJS extends _ToolFunc {
//   const _RunJS()
//       : super(
//           name: 'runJS',
//           description: 'Run JavaScript code',
//           parametersSchema: const {'code': 'The JavaScript code to run'},
//         );

//   @override
//   Future<_Msg> run(_CallResp call, _Map args) async {
//     final code = args['code'];
//     return _Msg(
//       role: _Role.tool,
//       content: [ChatContent.text('running $code').toOpenAI],
//       name: name,
//       toolCalls: [call],
//     );
//   }
// }