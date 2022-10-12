//
//  ViewController.m
//  Demo
//
//  Created by Bii on 2022/10/12.
//

#import "ViewController.h"
#import "DialogManager/DialogManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (void)showAlertA {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗1" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 关闭弹窗需要调用
        [[DialogManager shared] hideActionFromQueueWithIdentifier:@"1" completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertB {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗2" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 关闭弹窗需要调用
        [[DialogManager shared] hideActionFromQueueWithIdentifier:@"2" completion:nil];

    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗3" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 关闭弹窗需要调用
        [[DialogManager shared] hideActionFromQueueWithIdentifier:@"3" completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
