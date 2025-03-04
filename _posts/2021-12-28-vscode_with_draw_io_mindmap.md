---
layout: post
title:  "使用vscode的插件（draw.io或mindmap）绘制思维导图"
categories: tools
tags: vscode drawio diagrams mindmap mindmap
author: David
---

* content
{:toc}

---
##  1. 插件：draw.io
参考:

[链接1](https://www.codenong.com/cs110689765/)

[链接2](https://mp.weixin.qq.com/s/04Wd8q0HIsAFLV1WiU4BIg)

diagrams.net（前身是draw.io）是开源免费的流程图绘制工具，非常好用。但给出的默认模板里没有思维导图。

* vscode上的draw.io插件

插件名称：Draw.io Integration

![vscode上的draw.io插件](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_draw_io_mindmap_plugin.png)

* 新建draw.io文件

安装完成后，新建文件，扩展名为"*.drawio"，

![create draw.io文件](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_draw_io_mindmap_new_file.png)

* Open新建的draw.io文件
  
![open draw.io文件](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_draw_io_mindmap_open_file.png)

![打开draw.io文件后的窗口](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_draw_io_mindmap_open_window.png)

* 绘制思维导图

绘制思维导图的元素：Central Idea，Branch，Sub Topic，OrgChart，Organization，Division，Sub Sections

![mind map元素](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_draw_io_mindmap_elements.png)


## 2. MindMap
专为 VSCode 设计的轻量级脑图插件。

**安装**：搜索并安装插件 Mindmap。
![MindMap插件](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_mindmap_elements.png)

**特点**：
- 简单易用，快捷键丰富；
- 支持 .km 格式文件。

**使用**：

1. 新建 .km 文件。
2. 使用快捷键操作：
- Insert：添加子节点。
- Enter：添加同级节点。
- Delete：删除节点。

![MindMap Example](https://github.com/titron/titron.github.io/raw/master/img/2021-12-28-vscode_with_mindmap_example.png)
