
🔥Flutter 那些花里胡哨的底部菜单🔥 进来绝不后悔
====
### 前言
前段时间，学习到了Flutter动画，正愁不知道写个项目练习巩固，突然有一天产品在群里发了一个链接【ios中的动画标签】(下面有例图)，我心里直呼"好家伙"，要是产品都要求做成这样，产品经理和程序员又又又又又又得打起来! 还好只是让我们参考，刚好可以拿来练习。

GitHub地址：[https://github.com/longer96/flutter-demo](https://github.com/longer96/flutter-demo)

【图片t01】

我们每天都会看到底部导航菜单，它们在应用程序内引导用户，允许他们在不同的tag之间快速切换。但是谁说切换标签就应该很无聊？
让我们一起探索标签栏中有趣的动画。虽然你在应用程序中可能不会使用到，但看看它的实现可能会给你提供一些灵感、设计参考。

如果恰好能给你带来一点点帮助，那是再好不过啦~   路过的帅逼帮忙点个 star





### 先上几张花里胡哨的底部菜单 参考图

【例图s01】【例图s02】【例图s03】【例图s04】



### 效果分析
咳咳，有的动效确实挺难的，需要设计师的鼎力支持，我只好选软的柿子捏

【图片p00】
首先我们观察，它是由文字和指示器组成的。点击之后指示器切换，文字缩放。

- 每个tag 均分了屏幕宽度
- 点击之后，指示器从之前的tag中部位置拉长到选中tag的中部位置
- 指示器到达选中tag之后，长度立马向选中tag位置收缩

稍微复杂一点的是指示器的动画，看上去有3个变量：左边距、右边距、指示器宽度。
但变量越多，越不方便控制，细心想一下 我们发现其实只需要控制： 左、右边距就可以了，指示器宽度设置成自适应（或者只控制左边距和指示器宽度）

实现效果
【效果图 P11】

其实很多类似底部菜单都可以如法炮制，指示器位于tag后面，根据不同的条件调整位置和尺寸。
【效果图d00】
【效果图d01】
【效果图d02】




### 实现一款底部菜单
常见的还有另一种展开类似的菜单，比如这样
【效果图x00】

咱们还是先简单分析一下
 - 由一个按钮、多个tag按钮组成
 - 点击之后，tag呈扇状展开或收缩

看上去只有2步，还是很简单的嘛

第一步：我们用帧布局叠放按钮和tag
```
Stack(
    children: [
      // tag菜单

      // 菜单/关闭 按钮
    ]
  )
```


第二步：管理好tag的位置
简单介绍一下Flow，Flutter中Flow是一个对子组件尺寸以及位置调整非常高效的控件。

> Flow用转换矩阵在对子组件进行位置调整的时候进行了优化：在Flow定位过后，如果子组件的尺寸或者位置发生了变化，在FlowDelegate中的paintChildren()方法中调用context.paintChild 进行重绘，而context.paintChild在重绘时使用了转换矩阵，并没有实际调整组件位置。

使用起来也很简单，只需要实现FlowDelegate的paintChildren()方法，就可以自定义布局策略。所以我们需要计算好每一个tag的轨迹位置。

经过你的细心观察，你发现tag的轨迹呈半圆状展开，对 没错 就是需要翻出三角函数

【图片sjhs】


【图片f00】

经过你的又一次细心观察，你发现有5个tag，半圆实际可以放7个，但是为了有更好的显示效果，可以将需要展示的tag放在中间位置（过滤掉第一个和最后一个）

所以我们可以列出简单的计算
```
final total = context.childCount + 1;

for (int i = 0; i < childCount; i++) {
  x = cos(pi * (total - i - 1) / total) * Radius;
  y = sin(pi * (total - i - 1) / total) * Radius;
}
```

你发现太规整的圆其实并不是那么好看，优化一下
- 将x轴半径设置为 父级约束宽度的一半
- 将Y轴半径设置为 父级约束高度
- 给动画加上曲线，让tag有类似回弹效果
- 注意y轴得转换为负数，因为我们的坐标点位于下方
【图片a003】

微调一下，好啦   恭喜你!
3句代码，让产品经理给你点了18杯茶
【图片b001】


```
class FlowAnimatedCircle extends FlowDelegate {
  final Animation<double> animation;

  /// icon 尺寸
  final double iconSize = 48.0;

  /// 菜单左右边距
  final paddingHorizontal = 8.0;

  FlowAnimatedCircle(this.animation) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    // 进度等于0，也就是收起来的时候不绘制
    final progress = animation.value;
    if (progress == 0) return;

    final xRadius = context.size.width / 2 - paddingHorizontal;
    final yRadius = context.size.height - iconSize;

    // 开始(0,0)在父组件的中心
    double x = 0;
    double y = 0;

    final total = context.childCount + 1;

    for (int i = 0; i < context.childCount; i++) {
      x = progress * cos(pi * (total - i - 1) / total) * xRadius;
      y = progress * sin(pi * (total - i - 1) / total) * yRadius;

      // 使用Matrix定位每个子组件
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
            x, -y + (context.size.height / 2) - (iconSize / 2), 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowAnimatedCircle oldDelegate) => false;
}
```

只要理解到了上面的实现，下面这3种也能很轻松完成
【图片b000】
【图片b002】
【图片b003】





### 最后
收集、参考实现了几个底部导航，当然可能很多地方需要优化，大家不要喷我哦

- 有很棒的底部菜单希望推荐
- 需要使用的，建议大家clone下来，直接引入，具体需求(如未读消息)自己添加
- 欢迎Fork & pr贡献您的代码，大家共同学习❤
- Android 体验下载 http://d.cc53.cn/sn6c
- Web在线体验 http://footer.eeaarr.cn




### Flutter动画相关教程
- [Flutter动画 教程B站王叔](https://space.bilibili.com/589533168/channel/detail?cid=130705)
- [Flutter|老孟 Flow](http://laomengit.com/flutter/widgets/Flow.html#%E5%8D%8A%E5%9C%86%E8%8F%9C%E5%8D%95%E5%B1%95%E5%BC%80-%E6%94%B6%E8%B5%B7)
