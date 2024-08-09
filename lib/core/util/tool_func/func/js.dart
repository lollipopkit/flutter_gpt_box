part of '../tool.dart';

final class TfJs extends ToolFunc {
  static const instance = TfJs();
  const TfJs()
      : super(
          name: 'js',
          parametersSchema: const {
            'type': 'object',
            'properties': {
              'code': {
                'type': 'string',
                'description': 'The code to run',
              },
              'scriptName': {
                'type': 'string',
                'description': 'The stored js script to run',
              },
            },
          },
        );

  @override
  String get description {
    final scripts = Stores.tool.jsScripts;
    return '''
This tool has a quickjs runtime, you can generate some JS code to run, 
like calculation, web data fetching(includes xhr & fetch), etc.

Also, there are some users' scripts that can be run in this tool:
${scripts.keys.join('\n')}

You need to return the value user wanted at end.
''';
  }

  @override
  String get l10nName => '${libL10n.execute} JavaScript';

  @override
  String help(_CallResp call, _Map args) {
    final code = args['code'] as String? ?? '<?>';
    return '''
${libL10n.execute} ?
```js
$code
```
''';
  }

  @override
  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async {
    final code = args['code'] as String?;
    if (code == null) {
      return [ChatContent.text(libL10n.empty)];
    }
    final rt = getJavascriptRuntime();
    await rt.enableFetch();
    var result = await rt.evaluateAsync(code);
    if (result.isPromise) {
      result = await result.rawResult;
    }
    rt.dispose();
    return [ChatContent.text(result.stringResult)];
  }
}
