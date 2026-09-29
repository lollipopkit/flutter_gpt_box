# URL scheme

`lollipopkit.com://gptbox/<path>?<params>`

| Path | Params | What |
|---|---|---|
| `/new` | `msg`, `send=true` | A new chat, with `msg` in the composer — or sent, with `send=true` |
| `/open` | `chatId` or `title` | Opens a chat |
| `/search` | | Focuses the chat search |
| `/share` | `chatId` | Shares a chat (the current one without `chatId`) |
| `/go` | `page=settings\|providers\|tools\|backup\|about` | Opens a page |
| `/provider` | `name`, `api`, `baseUrl`, `models`? | Adds a custom provider, after asking. `api` is one of `openai-completions`, `openai-responses`, `anthropic-messages`, `google-generative-ai`. OpenAI-compatible endpoints list their models; the other APIs need `models` (comma-separated ids). A link never carries a key: you enter it yourself |

---

# URL scheme（中文）

`lollipopkit.com://gptbox/<路径>?<参数>`

| 路径 | 参数 | 作用 |
|---|---|---|
| `/new` | `msg`、`send=true` | 新建对话，`msg` 填入输入框；带 `send=true` 时直接发送 |
| `/open` | `chatId` 或 `title` | 打开对话 |
| `/search` | | 聚焦对话搜索 |
| `/share` | `chatId` | 分享对话（不带 `chatId` 时为当前对话） |
| `/go` | `page=settings\|providers\|tools\|backup\|about` | 打开页面 |
| `/provider` | `name`、`api`、`baseUrl`、`models`? | 询问后添加自定义服务商。`api` 取值为 `openai-completions`、`openai-responses`、`anthropic-messages`、`google-generative-ai`。OpenAI 兼容端点会自动获取模型列表；其他 API 需要 `models`（逗号分隔的 ID）。链接中不会包含 key，需要你自己填写 |
