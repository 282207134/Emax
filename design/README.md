# Pixso 设计参考

来源：本次开发时 Pixso 中打开的 Emax 文件，当前页 Emax（`0:1`）。读取并导出了全部 34 个顶层界面。

- `frames.json`：设计节点 ID、名称、原始尺寸和对应图片路径。
- `reference/`：Pixso 原稿导出的 PNG，用于设计对照。
- App 运行截图位于 `../docs/screenshots/`，页面、路由与原稿对应关系见 `../docs/SCREENSHOTS.md`。

实现首先读取了 Pixso 的 Flutter 导出代码与页面截图，随后按功能整理为可交互的 Flutter 组件。临时代码导出文件及 localhost 资源地址已移除，实际使用的封面、头像、插画和 Logo 保存在 `../assets/images/`。
