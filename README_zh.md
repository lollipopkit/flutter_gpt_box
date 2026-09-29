简体中文 | [English](README.md)

<h2 align="center">Flutter GPT Box</h2>

<p align="center">
一个支持 OpenAI API 的 第三方客户端。
</p>

<!-- Badges-->
<p align="center">
  <a href="https://cdn.lpkt.cn/donate"><img alt="donate" src="https://img.shields.io/badge/捐赠-我-pink"></a>
  <img alt="lang" src="https://img.shields.io/badge/语言-dart-cyan">
  <img alt="license" src="https://img.shields.io/badge/证书-GPLv3-yellow">
</p>

## 😣 注意
本应用目前正在开发中，可能部分功能缺失 / 不可用。
请不要在生产环境中使用，也不要用于重要数据。


## 🪄 特性
- 多个 provider (OpenAI、Anthropic、Gemini、OpenRouter……以及任意 OpenAI 兼容接口)，密钥保存在系统钥匙串
- Tools
  - 记忆：模型跨对话保存的文件，可在设置中编辑
  - 读取网页和 API。[视频](https://cdn.lpkt.cn/gptbox/screenshot/tools.mp4)
  - 搜索和读取其他对话
  - MCP 服务器
- 文本 / 图片聊天，文本文件作为附件
- 本地化 (English, 简体中文, Deutsch, 繁體中文, Indonesian, Français, Dutch, Türkçe, Español, Русский язык, Українська, Português, 日本語)
- 以图片形式分享聊天
- Url Scheme，例如：`lollipopkit.com://gptbox/new?msg=你好`
- 与 WebDAV / iCloud 加密同步
- 移动端 & 桌面端 支持
- 渲染 代码块 / LaTeX 公式
- 性能远超传统 Web


## 🏙️ 截屏
<table>
  <tr>
    <td><img width="277px" src="https://cdn.lpkt.cn/gptbox/screenshot/1.jpg"></td>
    <td><img width="277px" src="https://cdn.lpkt.cn/gptbox/screenshot/2.jpg"></td>
    <td><img width="277px" src="https://cdn.lpkt.cn/gptbox/screenshot/3.jpg"></td>
    <td><img width="277px" src="https://cdn.lpkt.cn/gptbox/screenshot/4.jpg"></td>
  </tr>
</table>


## ⬇️ 使用

平台 | 下载
--- | ---
iOS | [AppStore](https://apps.apple.com/app/id6476033062)
macOS | [Github](https://github.com/lollipopkit/flutter_gpt_box/releases)（Apple silicon 用 `GPTBox-<版本>-arm64.dmg`，Intel 用 `-amd64.dmg`）
Android | [Github](https://github.com/lollipopkit/flutter_gpt_box/releases) / [CDN](https://cdn.lpkt.cn/gptbox/pkg/?order=desc) / [OpenAPK](https://www.openapk.net/gptbox/flutter.gpt.box/)
Linux & Windows | [Github](https://github.com/lollipopkit/flutter_gpt_box/releases) / [CDN](https://cdn.lpkt.cn/gptbox/pkg/?order=desc)

由于未完成备案，请移步 **AppStore 其他区** 下载。  
请从你 **信任的** 来源下载。


## 🆘 帮助

<div align="center">
  <a href="https://t.me/lpktg"><img alt="donate" src="https://img.shields.io/badge/Telegram-lpktg-green"></a>
  <a href="https://discord.gg/SsVNbRhK7w"><img alt="discord" src="https://img.shields.io/badge/Discord-lpkt-purple"></a>
</div>

反馈前须知：
1. 反馈问题请附带 log（设置 → 关于 → 日志），并以 bug 模版提交。
2. 反馈问题前请检查是否是 本app 的问题。
3. 欢迎所有有效、正面的反馈，主观（比如你觉得其他UI更好看）的反馈不一定会接受

确认了解上述内容后：
- 如果你有**任何问题或者功能请求**，请在 [讨论](https://github.com/lollipopkit/flutter_gpt_box/discussions/new/choose) 中交流。
- 如果 app 有**任何 bug**，请在 [问题](https://github.com/lollipopkit/flutter_gpt_box/issues/new) 中反馈。


## 🧱 贡献
- 任何正面的贡献都欢迎。
- [本地化翻译指南](https://blog.lpkt.cn/posts/faq/) 可在我的博客中找到。


## 💡 我的其它 Apps
- [Server Box](https://github.com/lollipopkit/flutter_server_box) - 服务器状态和工具。
- [更多](https://github.com/lollipopkit) - 工具 & etc.


## 📝 协议
`GPL v3 lollipopkit`
