# iOS弹窗管理

## 应用场景
弹窗需要按指定顺序去显示，就可以使用这个来管理，使用起来也很简单，适用老项目和新项目。

## 导入
把`DialogManager`文件夹下内容添加到项目，在使用的地方引入即可

## 使用方法
### 具体可以看demo
添加任务
```
    // 获取单例
    DialogManager *manager = [DialogManager shared];
    // 添加弹窗1
    [manager addShowActionToQueueWithTaskIdentifier:@"1" block:^(DialogManager * _Nonnull manager) {
        [self showAlertA];
    }];
    // 添加弹窗2
    [manager addShowActionToQueueWithTaskIdentifier:@"2" block:^(DialogManager * _Nonnull manager) {
        [self showAlertB];
    }];
    // 添加弹窗3
    [manager addShowActionToQueueWithTaskIdentifier:@"3" block:^(DialogManager * _Nonnull manager) {
        [self showAlertC];
    }];
```

关闭弹窗时
```
// 弹窗A
- (void)showAlertA {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗1" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 关闭弹窗需要调用
        [[DialogManager shared] hideActionFromQueueWithIdentifier:@"1" completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertB

...

```


