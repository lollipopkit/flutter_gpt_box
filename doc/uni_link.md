- [URL Scheme](#url-scheme)
- [链接](#链接)

## URL Scheme
- [x] On web, replace `lk-gptbox://app` to `https://gpt.lolli.tech`
- [x] Page: `lk-gptbox://app/go?page=`
  - Available `page`: `setting`, `backup`, `about`
- [x] Config: `lk-gptbox://app/set?openAiUrl=&openAiKey=&openAiModel=`
- [x] Chat
  - [x] New: `lk-gptbox://app/new?msg=&send=`
    - If `send` is `true`, send the message, or just open the chat and fill the message 
  - [x] Open: `lk-gptbox://app/open?chatId=&title=`
    - If `chatId` and `title` is empty, open the chat history list
    - If `chatId` is not empty, open the chat with id
    - If `title` is not empty, open the chat with title
  - [x] Search: `lk-gptbox://app/search?keyword=`
  - [x] Share: `lk-gptbox://app/share?chatId=&title=`
    - If `chatId` and `title` is empty, share the current chat
    - If `chatId` is not empty, share the chat with id
    - If `title` is not empty, share the chat with title

## 链接
- [x] 在网页上，将 `lk-gptbox://app` 替换为 `https://gpt.lolli.tech`
- [x] 页面: `lk-gptbox://app/go?page=`
  - 可用 `page`（页面）: `setting`, `backup`, `about` 
- [x] 配置: `lk-gptbox://app/set?openAiUrl=&openAiKey=&openAiModel=`
- [x] 聊天
  - [x] 新建: `lk-gptbox://app/new?msg=&send=`
    - 如果 `send` 是 `true`，发送消息，否则只是打开聊天并填充消息
  - [x] 打开: `lk-gptbox://app/open?chatId=&title=`
    - 如果 `chatId` 和 `title` 为空，打开聊天历史列表
    - 如果 `chatId` 不为空，打开 id 对应的聊天
    - 如果 `title` 不为空，打开标题对应的聊天
  - [x] 搜索: `lk-gptbox://app/search?keyword=`
  - [x] 分享: `lk-gptbox://app/share?chatId=&title=`
    - 如果 `chatId` 和 `title` 为空，分享当前聊天
    - 如果 `chatId` 不为空，分享 id 对应的聊天
    - 如果 `title` 不为空，分享标题对应的聊天
