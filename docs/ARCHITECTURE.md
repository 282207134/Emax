# Emax 项目架构说明

## 分层与职责

```text
main.dart
  └─ SharedPreferences → AppStore
       └─ AppScope（InheritedNotifier）
            └─ EmaxApp（MaterialApp / 路由 / 主题）
                 ├─ features/* 页面与页面内 State
                 ├─ core/ui.dart 共用视觉组件
                 └─ core/speech_player.dart → 设备 TTS
```

| 层级 | 文件 | 职责 |
| --- | --- | --- |
| 启动与组合 | `lib/main.dart`、`lib/app.dart` | 创建依赖，统一主题，解析命名路由 |
| 应用状态 | `lib/core/app_store.dart` | 管理学习数据、偏好与本地持久化 |
| 内容数据 | `lib/data/catalog.dart` | 不可变课程、句子、主题与词卡模型；设计状态目录 |
| 页面与交互 | `lib/features/` | 展示数据、响应操作、组织学习流程 |
| 通用 UI | `lib/core/ui.dart` | 统一颜色、按钮、标签、导航、头像和成绩装饰 |
| 音频适配 | `lib/core/speech_player.dart` | 控制英文 TTS 朗读速度、取消和停止 |
| 验证 | `test/`、`test_driver/` | 逻辑与渲染检查、iOS 交互与截图 |

项目规模适合原生 `ChangeNotifier + InheritedNotifier`。页面以功能组织，避免为静态演示内容增加仓库接口、依赖注入框架或大型路由框架。

## 状态与数据流

用户在单词卡中选择答案，页面判断选择与 `VocabularyCard.answer` 是否一致，调用 `AppStore.answerWord`。答对时加入 `correct` 并移出 `wrong`；答错则反向处理。状态通知词卡页和资料页刷新，并把两份集合写入本地存储。重新进入应用时，从本地记录恢复。

| 持久化键 | 类型 | 含义 |
| --- | --- | --- |
| `onboarded` | bool | 是否完成引导/进入演示 |
| `language` | String | 母语偏好 |
| `topics` | List&lt;String&gt; | 已选词汇主题 |
| `bookmarks` | List&lt;String&gt; | 收藏的课程标识 |
| `subscriptions` | List&lt;String&gt; | 订阅频道名称 |
| `correct`、`wrong` | List&lt;String&gt; | 正确词和待复习词 |
| `lessons` | List&lt;String&gt; | 已完成口语课程 |
| `bestScore` | int | 记忆测试最高分 |

密码、输入中的答案、临时播放状态不进入持久化存储。表单控制器、启动计时器、测试倒计时和音频均在相应页面生命周期结束时清理。

## 页面与路由

底部的 Home / Search / Speak / Word / Profile 使用替换路由，避免切换主栏目时不断堆叠导航。详情页使用压栈路由；无返回历史时回到首页。

| 入口 | 主要路由 | 下一步 |
| --- | --- | --- |
| 引导 | `/splash`、`/onboarding/0..2` | 登录或注册 |
| 账号演示 | `/signin`、`/signup` | `/home` |
| 学习首页 | `/home` | `/post`、`/quiz/0` |
| 文章状态 | `/post`、`/post/dictionary`、`/post/repeat`、`/post/practice` | 练习或测试 |
| 记忆测试 | `/quiz/0..2` | `/result/test/<分数>` |
| 搜索发现 | `/search`、`/category/<分类>`、`/channel` | 情景文章 |
| 口语课程 | `/speak`、`/course`、`/conversation` | `/listen`、`/speaking` |
| 口语结果 | `/result/speaking/<分数>` | 首页或重试 |
| 词汇学习 | `/topics`、`/words` | 词卡弹窗与复习列表 |
| 词卡预览状态 | `/words/card`、`/words/correct`、`/words/wrong` | 与正常交互共用弹窗 |
| 升级 | `/level-up` | 首页 |
| 资料 | `/profile`、`/language` | 保存偏好 |
| 辅助功能 | `/bookmarks`、`/statistics`、`/subscriptions`、`/channels`、`/notifications` | 相应学习入口 |

`screenCatalog` 对原稿的 34 个节点建立唯一截图文件名和可执行路由。相同页面的不同状态复用同一套组件，避免为每张原稿复制一个页面文件。

## 核心流程

1. **记忆测试**：进入测试 → 选择答案 → 下一题 → 5 题完成或倒计时结束 → 计算正确率 → 更新历史最高分 → 成绩页。未选择答案时不能下一题。
2. **词卡学习**：选择主题 → 查看对应卡片 → 选择释义 → 检查答案 → 更新两份词集 → 查看正确/错误列表 → 重答错词 → 当前卡组全部正确后进入升级页。
3. **口语演示**：课程 → 对话 → 逐句英文朗读或进入练习 → 点击演示麦克风推进 3 句 → 保存课程完成状态 → 演示成绩页。
4. **资料设置**：选中母语 → Save → 保存本地偏好 → 返回资料。未保存前的选择只是页面内状态。

## 设计还原与适配

原稿以 375 × 812 为基础。实现采用 `SafeArea`、`Expanded`、`GridView` 和可滚动列表，在 iPhone 16e 的 390 × 844 逻辑尺寸上适配系统栏与内容区域。保留原稿主色、字体、课程封面和插画；导航图标使用 Flutter Cupertino 图标。

保留 `design/reference/` 中的全部原稿作为对照。运行时不把整张设计截图当成界面：文本、按钮、表单、列表和弹层均由 Flutter 原生 Widget 构建，图片只承担封面、头像、插画与品牌素材。

## 后续扩展位置

- **真实内容接口**：从 `catalog.dart` 的不可变模型开始，把静态内容读取替换为服务请求；保留页面组件。
- **真实账户**：在登录表单验证后接入认证服务；会话与凭证应采用专用安全存储，不能写入现有偏好存储。
- **视频播放**：在文章媒体区引入视频资源与播放器，保留句子、收藏、测试流程。
- **语音评估**：为 `ConversationScreen` 引入录音、识别和评分服务；当前演示按钮和演示分值不应当作为真实评估使用。
- **多语言内容**：把现有英语/越南语内容按 locale 组织；母语偏好仅作为选项来源。

[返回项目说明](../README.md) · [截图目录](SCREENSHOTS.md)
