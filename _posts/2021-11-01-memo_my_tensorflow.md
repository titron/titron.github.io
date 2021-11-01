---
layout: post
title:  "objcopy的用法"
categories: software
tags: linux, software
author: David
---

* content
{:toc}

---

## 第一部分 神经网络-机器学习的几个不错的网址
(1) [Google机器学习课程，免费](https://developers.google.com/machine-learning/crash-course/)

(2) [Theano内自带的教程，例子非常具体：Deep Learning Tutorials](http://www.deeplearning.net/tutorial/)

(3) [stanford教程](http://ufldl.stanford.edu/wiki/index.php/UFLDL)

(4) [stanford公开课，经典，知名](http://open.163.com/special/opencourse/machinelearning.html)

(5) 莫烦Python和Tensorflow, 这个网址链接不错，我就按照这个走了一遍！

[莫烦Python和Tensorflow_1](https://morvanzhou.github.io/tutorials/machine-learning/tensorflow/1-1-why/)

[莫烦Python和Tensorflow_2](https://mofanpy.com/tutorials/machine-learning/tensorflow/)

(6) [keras vs Tensorflow](https://gist.github.com/ricgu8086/0ba44ce3aab19ec50425383a4d778b50)

(7) [python实现机器学习](http://scikit-learn.org)

(8) [Caffe](http://caffe.berkeleyvision.org/)

(9) [Caffe2](https://caffe2.ai/)


## 第二部分 ML主要术语	
		
* [1]（监督式）机器学习	
  
机器学习系统通过学习如何组合输入信息来对从未见过的数据做出有用的预测。	

在监督式学习中，机器学习算法通过以下方式构建模型：检查多个样本并尝试找出<font color=#FF000>可最大限度地减少损失的模型</font>；这一过程称为<font color=#FF000>经验风险最小化 </font>。	
		
* [2] 标签	

在简单线性回归中，标签是我们要预测的事物，即 y 变量。	

标签可以是小麦未来的价格、图片中显示的动物品种、音频剪辑的含义或任何事物。	
		
* [3] 特征
  	
在简单线性回归中，特征是输入变量，即 x 变量。

简单的机器学习项目可能会使用单个特征，而比较复杂的机器学习项目可能会使用数百万个特征，按如下方式指定：	
		
	{x1,x2,...xN}	
		
在垃圾邮件检测器示例中，特征可能包括：	

   --- 电子邮件文本中的字词	

   --- 发件人的地址	

   --- 发送电子邮件的时段	

   --- 电子邮件中包含“一种奇怪的把戏”这样的短语。	
		
* [4] 样本	
  
样本是指数据的特定实例：**x**。

（我们采用粗体 **x** 表示它是一个矢量。）

我们将样本分为以下两类：	

---有标签样本	

---无标签样本	
		
<font color=#FF000>有标签样本</font>同时包含特征和标签。即：	
    
    labeled examples: {features, label}: (x, y)	

我们使用有标签样本来训练模型。在我们的垃圾邮件检测器示例中，有标签样本是用户明确标记为“垃圾邮件”或“非垃圾邮件”的各个电子邮件。	
		
<font color=#FF000>无标签样本</font>包含特征，但不包含标签。即：	

    unlabeled examples: {features, ?}: (x, ?)	
	
在使用有标签样本训练了我们的模型之后，我们会使用该模型来预测无标签样本的标签。在垃圾邮件检测器示例中，无标签样本是用户尚未添加标签的新电子邮件。	
		
* [5] 模型	

模型定义了特征与标签之间的关系。例如，垃圾邮件检测模型可能会将某些特征与“垃圾邮件”紧密联系起来。我们来重点介绍一下模型生命周期的两个阶段：	

<font color=#FF000>训练</font>表示创建或学习模型。也就是说，您向模型展示有标签样本，让模型逐渐学习特征与标签之间的关系。简单来说，训练模型表示通过有标签样本来学习（确定）所有权重和偏差的理想值。	

<font color=#FF000>推断</font>表示将训练后的模型应用于无标签样本。也就是说，您使用训练后的模型来做出有用的预测 (y')。例如，在推断期间，您可以针对新的无标签样本预测 medianHouseValue。	
		
* [6] 回归与分类	
	
<font color=#FF000>回归</font>模型可预测连续值。例如，回归模型做出的预测可回答如下问题：

加利福尼亚州一栋房产的价值是多少？	

用户点击此广告的概率是多少？	
		
<font color=#FF000>分类</font>模型可预测离散值。例如，分类模型做出的预测可回答如下问题：	

某个指定电子邮件是垃圾邮件还是非垃圾邮件？	

这是一张狗、猫还是仓鼠图片？	
		
* [7] 平方损失：一种常见的损失函数	

线性回归模型使用的是一种称为平方损失（又称为 L2 损失）的损失函数。单个样本的平方损失如下：	

	  = the square of the difference between the label and the prediction	

	  = (observation - prediction(x))2	

	  = (y - y')2	

均方误差 (MSE) 指的是每个样本的平均平方损失。要计算 MSE，请求出各个样本的所有平方损失之和，然后除以样本数量：	
	
	  MSE=1N∑(x,y)∈D(y−prediction(x))2	
		
	其中：	

	(x,y) 指的是样本，其中	

	x 指的是模型进行预测时使用的特征集（例如，温度、年龄和交配成功率）。	

	y 指的是样本的标签（例如，每分钟的鸣叫次数）。	

	prediction(x) 指的是权重和偏差与特征集 x 结合的函数。	

	D 指的是包含多个有标签样本（即 (x,y)）的数据集。	

	N 指的是 D 中的样本数量。	

虽然 MSE 常用于机器学习，但它既不是唯一实用的损失函数，也不是适用于所有情形的最佳损失函数。	
		
* [8] 降低损失
  	
迭代方法：	

		通过计算整个数据集中ω每个可能值的损失函数来找到收敛点

梯度下降法：	

		梯度矢量具有方向和大小。

		梯度始终指向损失函数中增长最为迅猛的方向。梯度下降法算法会沿着负梯度的方向走一步，以便尽快降低损失。

		梯度下降法依赖于负梯度。

学习速率

	梯度下降法算法用梯度乘以一个称为学习速率（有时也称为步长）的标量，以确定下一个点的位置。

随机梯度下降法	

*随机梯度下降法 (SGD)* 将这种想法运用到极致，它每次迭代只使用一个样本（批量大小为 1）。

如果进行足够的迭代，SGD 也可以发挥作用，但过程会非常杂乱。“随机”这一术语表示构成各个批量的一个样本都是随机选择的。
		
*小批量随机梯度下降法（小批量 SGD）* 是介于全批量迭代与 SGD 之间的折衷方案。
小批量通常包含 10-1000 个随机选择的样本。

小批量 SGD 可以减少 SGD 中的杂乱样本数量，但仍然比全批量更高效。

**梯度下降法也适用于包含多个特征的特征集。**
		
* [9] 将数据区分成训练集、验证集、测试集	

对于任何指定特征或列，训练集和验证集之间的值得分布应该大致相同。	

![训练集vs测试集](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_data_class.png)


* [10] 机器学习中的调试通常是<font color=#FF000>数据</font>调试而不是代码调试。	
	
* [11] 良好的机器学习依赖于良好的数据。	
  
我们假定用于训练和测试的所有数据都是值得信赖的。在现实生活中，数据集中的很多样本是不可靠的，原因有以下一种或多种：	

*遗漏值*。 例如，有人忘记为某个房屋的年龄输入值。	

*重复样本*。 例如，服务器错误地将同一条记录上传了两次。	

*不良标签*。 例如，有人错误地将一颗橡树的图片标记为枫树。	

*不良特征值*。 例如，有人输入了多余的位数，或者温度计被遗落在太阳底下。	

一旦检测到存在这些问题，您通常需要将相应样本从数据集中移除，从而“修正”不良样本。要检测遗漏值或重复样本，您可以编写一个简单的程序。	
	
* [12] 可以通过降低复杂模型的复杂度来防止过拟合，这种原则称为正则化。	
  
并非只是以最小化损失（经验风险最小化）为目标：	

*minimize(Loss(Data|Model))*
	
而是以最小化损失和复杂度为目标，这称为结构风险最小化：	

*minimize(Loss(Data|Model) + complexity(Model))*
	
现在，我们的训练优化算法是一个由两项内容组成的函数：一个是损失项，用于衡量模型与数据的拟合度，另一个是正则化项，用于衡量模型复杂度。	
	
* [13]《DeepLearning深度学习》学习笔记	

根据Google图书中短语“控制论”、“联结主义”或“神经网络”频率衡量的人工神经网络研究的历史浪潮	

![DeepLearning深度学习](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_data_year_vs_frequencyofwordorphrase.png)

（图中展示了三次浪潮的前两次，第三次最近才出现）	

第一浪潮开始于20世纪40年代到20世纪60年代的控制论，随着生物学习理论的发展和第一个模型的实现，能实现单个神经元的训练。	

$f(x,w)$ = $x_1w_1$+...+$x_nw_n$
	
该简单线性模型，是第一波神经网络研究呗称为控制论。	

无法学习异或（XOR）函数。	
	
第二次浪潮开始于1980-1995年间的联结主义方法，可以使用反向传播训练具有一两个隐藏层的神经网络。	
	
当前第三次浪潮，也就是深度学习大约始于2006年。

已经开始着眼于新的无监督学习技术和深度模型在小数据集的泛化能力，但目前更多的兴趣点仍是比较传统的监督学习算法和深度模型充分利用大型标注数据集的能力。	
	
神经科学被视为深度学习研究的一个重要灵感来源，但它已不再是该领域的主要指导。	

现代深度学习从许多领域获取灵感，特别是应用数学的基本内容如线性代数、概率论、信息论和数值优化。	

尽管一些深度学习的研究人员引用神经科学座位灵感的重要来源，然而其他学者完全不关心神经科学。	
	
深度学习领域主要关注如何构建计算机系统，从而成功解决需要智能才能解决的任务。	

而计算神经科学领域主要关注构建大脑如何真实工作的比较精确的模型。	

## 第三部分 安装与学习笔记

参考[原贴链接](https://www.tensorflow.org/install/install_linux)。

* A problem was encountered as below when installing

![遇到的问题1](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_problem_1_when_installing.png)


* Code1, Hello
  
Run a short TensorFlow program

![Run a short TensorFlow program](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_code_hello.png)


* install Pycharm Community Edition

* Code 2, linear function trainning

refer code [here](https://github.com/MorvanZhou/tutorials/blob/master/tensorflowTUT/tf5_example2/full_code.py)

![example2](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_code_exampl2.png)

建议：

为保持练习目录的干净/统一，建议更换到当前练习代码目录下再运行代码：

![example2](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_clean_code.png)

* ImportError: No module named matplotlib.pyplot

```
$unset all_proxy
$unset ALL_PROXY
$sudo apt-get install python-matplotlib
```

* 可视化好助手 Tensorboard不显示图形

code please refer example7.py

(1) 而且与 tensorboard 兼容的浏览器是 “Google Chrome”. 使用其他的浏览器不保证所有内容都能正常显示.
Firefox可以显示。

(2) 同时注意, 如果使用 http://0.0.0.0:6006 网址打不开的朋友们, 请使用 http://localhost:6006, 大多数朋友都是这个问题.

(3) 请确保你的 tensorboard 指令是在你的 logs 文件根目录执行的. 如果在其他目录下, 比如 Desktop 等, 可能不会成功看到图. 比如在下面这个目录, 你要 cd 到 project 这个地方执行 /project > tensorboard --logdir logs
- project
   - logs
  
   model.py

   env.py

![generate data](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_gerate_datas.png)

也可以用这个命令，产生图示所用的数据:

![generate data 2](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_generate_data2.png)


* IOError: [Errno socket error] [SSL: UNKNOWN_PROTOCOL] unknown protocol (_ssl.c:590)

据说是被墙了，未深究。

从[这个地址](https://github.com/MorvanZhou/tfnn/tree/master/MNIST_data)下载训练数据：

然后，copy到 当前目录下的MINIST_data目录下，如下图 home/MINIST_data/

如果当前目录如下：

![当前目录](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_current_folder.png)

就copy到当前目录的 MNIST_data目录下：

![MINIST_data](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_copy_to_minist_data.png)

如果当前目录如下：

![当前目录2](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_current_folder2.png)

就copy到当前目录的 MNIST_data目录下：

![MINIST_data2](https://github.com/titron/titron.github.io/raw/master/img/2021-11-01-TensorFlow_copy_to_minist_data2.png)

* 安装sklearn, scipy, numpy

```
# python 2+ 版本复制:
$pip install -U scikit-learn
$sudo apt-get install python-numpy
$sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose

```

## 第四部分 源码下载链接
学习code可以来[这里](https://github.com/titron/myTensorFlow)下载。