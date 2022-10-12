//
//  DialogManager.m
//  DialogManger
//
//  Created by lzq on 2021/3/29.
//

#import "DialogManager.h"

@implementation DialogTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.priority = DialogTaskPriorityDefult;
        self.identifier = @"";
    }
    return self;
}

@end

@interface DialogManager ()
/* 弹窗队列 */
@property(nonatomic, strong) NSMutableArray<DialogTask*>* list;
/* 执行中的任务 */
@property(nonatomic, strong) DialogTask* currentTask;
@end

@implementation DialogManager

#pragma mark - life cycle
#pragma mark - public
+ (instancetype)shared {
    static DialogManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[DialogManager alloc] init];
            manager.pause = NO;
        }
    });
    return manager;
}

- (void)addShowActionToQueueWithTaskIdentifier:(NSString *)identifier block:(DialogManagerBlock)block {
    [self addShowActionToQueueWithTaskIdentifier:identifier priority:DialogTaskPriorityDefult block:block];
}

- (void)addShowActionToQueueWithTaskIdentifier:(NSString *)identifier priority:(NSUInteger)priority block:(DialogManagerBlock)block {
    if (!block) {
        NSLog(@"需要添加任务");
        return;
    }
    if (!identifier.length) {
        NSLog(@"需要标识符");
        return;
    }
    
    // 添加到队列
    DialogTask* task = [[DialogTask alloc] init];
    task.actionBlock = [block copy];
    task.priority = priority;
    task.identifier = identifier;
    [self.list addObject:task];
    NSLog(@"添加任务 - %@",identifier);

    // 出队
    [self next];
}

- (void)hideAndPauseActionFromQueueWithIdentifier:(NSString*)identifier completion:(DialogManagerBlock)completion {
    [self hideActionFromQueueWithIdentifier:identifier completion:^(DialogManager * _Nonnull manager) {
        self.pause = YES;
    }];
}

- (void)hideActionFromQueueWithIdentifier:(NSString *)identifier completion:(DialogManagerBlock)completion {
    if (!identifier.length) { return; }
    if (identifier != self.currentTask.identifier) { return; }
    NSLog(@"当前出栈 - %@",identifier);
    self.currentTask = nil;
    
    if (completion) { completion(self); }
    NSLog(@"当前剩余弹窗 - %@",@(self.list.count));
    // 继续执行下一个
    [self next];
}

- (void)hideActionAndClearFromQueueWithIdentifier:(NSString *)identifier completion:(DialogManagerBlock)completion {
    [self hideActionFromQueueWithIdentifier:identifier completion:^(DialogManager * _Nonnull manager) {
        [self clearQueue];
    }];
}

- (void)clearQueue {
    [self.list removeAllObjects];
}

- (void)wakeup {
    self.pause = NO;
    [self next];
}

- (BOOL)taskIsExistBy:(NSString *)identifier {
    __block BOOL flag = NO;
    if (self.currentTask.identifier == identifier) {
        flag = YES;
    } else {
        [self.list enumerateObjectsUsingBlock:^(DialogTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.identifier == identifier) {
                flag = YES;
                *stop = YES;
            }
        }];
    }
    return flag;
}

#pragma mark - private
// 出队逻辑
- (void)next {
    
    // 如果还有任务，就返回
    if (self.currentTask) { return; }
    // 是否暂停
    if (self.pause) { return; }
    
    // 执行下一个之前需要进行排序
    [self sort];
    
    // 执行下一个任务
    if (self.list.count > 0) {
        DialogTask* task = self.list[0];
        // 设置执行中的任务
        self.currentTask = task;
        // 出队
        [self.list removeObjectAtIndex:0];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            task.actionBlock(self);
        });
    }
}

// 排序
- (void)sort {
    if (self.list.count < 2) { return; }
    [self.list sortUsingComparator:^NSComparisonResult(DialogTask*  _Nonnull obj1, DialogTask*  _Nonnull obj2) {
        if (obj1.priority < obj2.priority) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
}

#pragma mark - event
#pragma mark get/set
- (NSMutableArray*)list {
    if (!_list) {
        _list = [NSMutableArray arrayWithCapacity:20];
    }
    return _list;
}
@end
