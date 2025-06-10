import 'package:hive_ce/hive.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:openai_dart/openai_dart.dart';

@GenerateAdapters([
  AdapterSpec<ChatHistoryItem>(),
  AdapterSpec<ChatContentType>(),
  AdapterSpec<ChatContent>(),
  AdapterSpec<ChatRole>(),
  AdapterSpec<ChatHistory>(),
  AdapterSpec<ChatConfig>(),
  AdapterSpec<ChatType>(),
  AdapterSpec<ChatSettings>(),
])
part 'hive_adapters.g.dart';
