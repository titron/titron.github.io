---
layout: post
title:  "docker v.s. wasm"
categories: basic
tags: docker wasm virtualization
author: David
---

* content
{:toc}

---

*参考*
[1. 原文链接](https://stateful.com/blog/webassembly-is-the-new-docker)

[2. docker与wasm很好的结合](https://collabnix.com/docker-and-wasm-containers-better-together)

*释义*
Docker是一个平台，允许您使用容器或与平台无关的独立环境在隔离状态下部署和运行您的应用程序，在该环境中，您的应用程序与运行所需的依赖项和资源一起打包。这种更快的访问使您的应用程序快速且高性能。

WebAssembly（也称为 Wasm）是万维网联盟发布的一种规范，用于创建可以以与容器相同的方式运行的高效二进制可执行文件。

![wasm定义](https://github.com/titron/titron.github.io/raw/master/img/2023-01-30-docker_vs_wasm-wasm.png)


*结论*

wasm特别适用于 Web 应用程序以及 Web 之外的服务器端应用程序。

在多种情况下，WebAssembly 将是比 Docker 或 containerd 更好的选择。

WebAssembly 有潜力成为 Docker 的重要替代部署单元。

Docker 的创建者 Solomon Hykes在 2019 年发推文说，“如果 WASM+WASI 在 2008 年存在，我们就不需要创建 Docker。”

它是如此强大。
