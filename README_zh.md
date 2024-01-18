简体中文 | [English](README.md)

<h2 align="center">Flutter GPT Box</h2>

<p align="center">
一个支持 OpenAI API 的 第三方全平台客户端。
<br>
<a href="https://gpt.lolli.tech/">尝试网页版</a> （推荐使用客户端以获得更好的性能）
</p>

<!-- Badges-->
<p align="center">
  <img alt="lang" src="https://img.shields.io/badge/lang-dart-pink">
  <img alt="countly" src="https://img.shields.io/badge/analysis-countly-pink">
  <img alt="license" src="https://img.shields.io/badge/license-GPLv3-pink">
</p>


## 🪄 特性
- 从 [ChatGPT Next Web](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web) 恢复
- 与 WebDAV / iCloud 同步
- 全平台支持


## 🏙️ 截屏
<table>
  <tr>
    <td>
	    <img width="277px" src="media/main.png">
    </td>
    <td>
	    <img width="277px" src="media/history.png">
    </td>
    <td>
	    <img width="277px" src="media/settings.png">
    </td>
  </tr>
</table>


## ⬇️ 使用
[iOS](https://apps.apple.com/app/id6476033062) / [Android](https://res.lolli.tech/gpt/latest.apk) / [macOS](https://apps.apple.com/app/id6476033062) / [Linux](https://res.lolli.tech/gpt/latest.AppImage) / [Windows](https://res.lolli.tech/gpt/latest.win.zip) / [Web](https://gpt.lolli.tech/)

- 由于中国政策原因，且**目前**无法完成[备案](https://github.com/lollipopkit/flutter_server_box/discussions/180)。请移步 AppStore 其他区下载。
- 关于安全：
  - 为了防止注入攻击等因素，请勿从不可信来源下载。
  - 由于 `Linux / Windows` 使用了默认签名，因此建议[自行构建](https://github.com/lollipopkit/flutter_server_box/wiki/%E4%B8%BB%E9%A1%B5#%E8%87%AA%E7%BC%96%E8%AF%91)。


## 🆘 帮助

- 吹水、参与开发、了解如何使用，QQ群 **762870488**

反馈前须知：
1. 反馈问题请附带 log（点击首页右上角），并以 bug 模版提交。
2. 反馈问题前请检查是否是 本app 的问题。
3. 欢迎所有有效、正面的反馈，主观（比如你觉得其他UI更好看）的反馈不一定会接受

确认了解上述内容后：
- 如果你有**任何问题或者功能请求**，请在 [讨论](https://github.com/lollipopkit/flutter_gpt_box/discussions/new/choose) 中交流。
- 如果 app 有**任何 bug**，请在 [问题](https://github.com/lollipopkit/flutter_gpt_box/issues/new) 中反馈。


## 🧱 贡献
**任何正面的贡献都欢迎**。

### 🌍 l10n
1. Fork 本项目，并 Clone 你 Fork 的项目至你的电脑
2. 在 `lib/l10n/` 文件夹内创建 `.arb` 本地化文件
   - 文件名应该类似 `intl_XX.arb`,  `XX` 是语言标识码。 例如 `intl_en.arb` 是给英语的， `intl_zh.arb` 是给中文的
3. 向 `.arb` 本地化文件添加内容。 你可以查看 `intl_en.arb` 和 `intl_zh.arb` 的内容，并理解其含义，来创建新的本地化文件
4. 运行 `flutter gen-l10n` 来生成所需文件
5. Commit 变更到你 Fork 的 Repo
6. 在我的项目中发起 Pull Request


## 📝 协议
`GPL v3 lollipopkit`
