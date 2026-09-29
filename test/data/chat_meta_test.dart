import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat.dart';

void main() {
  test('ChatMeta survives JSON', () {
    final m = ChatMeta(
      id: 'a',
      title: 'T',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
      useTools: false,
      model: const LlmModelRef('openai', 'gpt-5'),
      trashedAt: DateTime.fromMillisecondsSinceEpoch(2000),
    );
    final back = ChatMeta.fromJson(m.toJson());
    expect(back.id, 'a');
    expect(back.title, 'T');
    expect(back.useTools, isFalse);
    expect(back.model, const LlmModelRef('openai', 'gpt-5'));
    expect(back.trashed, isTrue);
    expect(back.copyWith(restore: true).trashed, isFalse);
    expect(back.copyWith(clearModel: true).model, isNull);
  });

  test('ChatMeta reads what an older build wrote', () {
    final m = ChatMeta.fromJson({'id': 'x'});
    expect(m.title, isNull);
    expect(m.useTools, isTrue);
    expect(m.model, isNull);
  });
}
