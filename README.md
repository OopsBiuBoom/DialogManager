# iOS弹窗管理

## 应用场景
旧项目要求弹窗需要按指定顺序去显示，就可以使用这个来管理。使用方法很简单。使用`addShowActionToQueueWithTaskIdentifier`方法按顺序添加弹窗。关闭弹窗时调用`hideActionFromQueueWithIdentifier`方法，后续的弹窗就会在前一个关闭之后弹出来

## 导入
把`DialogManager`文件夹下内容添加到项目即可

## 使用方法
1. 获取单例
2. 使用`addShowActionToQueueWithTaskIdentifier:block:`方法，在`block`添加你自己的弹窗逻辑。
3. 当你关闭弹窗的时候需要调用`hideActionFromQueueWithIdentifier:completion`等方法。

具体可以看demo
