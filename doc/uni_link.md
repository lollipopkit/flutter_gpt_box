- [URL Scheme](#url-scheme)
- [链接](#链接)

## URL Scheme
- [x] On web, replace `lpkt.cn://gptbox` to `https://gpt.lpkt.cn`
- [x] Page: `lpkt.cn://gptbox/go?page=`
  - Available `page`: `setting`, `backup`, `about`, `res`
- [x] Config: `lpkt.cn://gptbox/set?openAiUrl=&openAiKey=&openAiModel=`
- [x] Chat
  - [x] New: `lpkt.cn://gptbox/new?msg=&send=`
    - If `send` is `true`, send the message, or just open the chat and fill the message 
  - [x] Open: `lpkt.cn://gptbox/open?chatId=&title=`
    - If `chatId` and `title` is empty, open the chat history list
    - If `chatId` is not empty, open the chat with id
    - If `title` is not empty, open the chat with title
  - [x] Search: `lpkt.cn://gptbox/search?keyword=`
  - [x] Share: `lpkt.cn://gptbox/share?chatId=&title=`
    - If `chatId` and `title` is empty, share the current chat
    - If `chatId` is not empty, share the chat with id
    - If `title` is not empty, share the chat with title

## 链接
- [x] 在网页上，将 `lpkt.cn://gptbox` 替换为 `https://gpt.lpkt.cn`
- [x] 页面: `lpkt.cn://gptbox/go?page=`
  - 可用 `page`（页面）: `setting`, `backup`, `about`, `res`
- [x] 配置: `lpkt.cn://gptbox/set?openAiUrl=&openAiKey=&openAiModel=`
- [x] 聊天
  - [x] 新建: `lpkt.cn://gptbox/new?msg=&send=`
    - 如果 `send` 是 `true`，发送消息，否则只是打开聊天并填充消息
  - [x] 打开: `lpkt.cn://gptbox/open?chatId=&title=`
    - 如果 `chatId` 和 `title` 为空，打开聊天历史列表
    - 如果 `chatId` 不为空，打开 id 对应的聊天
    - 如果 `title` 不为空，打开标题对应的聊天
  - [x] 搜索: `lpkt.cn://gptbox/search?keyword=`
  - [x] 分享: `lpkt.cn://gptbox/share?chatId=&title=`
    - 如果 `chatId` 和 `title` 为空，分享当前聊天
    - 如果 `chatId` 不为空，分享 id 对应的聊天
    - 如果 `title` 不为空，分享标题对应的聊天
