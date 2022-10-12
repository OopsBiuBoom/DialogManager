//
//  DialogManager.h
//  DialogManger
//
//  Created by lzq on 2021/3/29.
//

#import <Foundation/Foundation.h>
@class DialogManager;

typedef enum : NSUInteger {
    DialogTaskPriorityLow     = 0,
    DialogTaskPriorityDefult  = 500,
    DialogTaskPriorityHigh    = 1000,
} DialogTaskPriority;

NS_ASSUME_NONNULL_BEGIN

typedef void (^DialogManagerBlock)(DialogManager* manager);

@interface DialogTask : NSObject
/* 标识符 */
@property (nonatomic, copy) NSString *identifier;
/*实际要执行的任务*/
@property(nonatomic, copy)DialogManagerBlock actionBlock;
/*优先级*/
@property(nonatomic, assign) DialogTaskPriority priority;

@end

#define DialogManagerInstance [DialogManager shared]

/* 弹窗管理器 */
@interface DialogManager : NSObject

/* 单例 */
+ (instancetype)shared;

/*
 暂停。
 暂停之后后续的任务将不会出队,不会影响正在执行的任务。
 需要`weakup`方法重新启动队列。
 */
@property (nonatomic, assign) BOOL pause;

/*
 把弹窗的显示行为交给管理队列管理
 @param identifier 唯一标识符
 @param block 写入弹窗逻辑代码
 */
- (void)addShowActionToQueueWithTaskIdentifier:(NSString*)identifier block:(DialogManagerBlock)block;

/*
 把弹窗的显示行为交给管理队列处理，并添加优先级
 @param identifier 唯一标识符
 @param priority 可以使用枚举，也可以自己写数字
 @param block 写入弹窗逻辑代码
 */
- (void)addShowActionToQueueWithTaskIdentifier:(NSString*)identifier priority:(NSUInteger)priority block:(DialogManagerBlock)block;

/*
 把弹窗隐藏操作告诉队列，出队暂停。直到调用`weakup`方法重新启动队列。适用于进入详情之后不再弹窗
 @param identifier 当前弹窗的标识
 @param completion 完成回调
 */
- (void)hideAndPauseActionFromQueueWithIdentifier:(NSString*)identifier completion:(_Nullable DialogManagerBlock)completion;

/*
 把弹窗隐藏操作告诉队列，继续执行下一个任务,只能隐藏正在显示的弹窗
 @param identifier 当前弹窗的标识
 @param completion 完成回调
 */
- (void)hideActionFromQueueWithIdentifier:(NSString*)identifier completion:(_Nullable DialogManagerBlock)completion;

/*
 把弹窗隐藏操作告诉队列，并清除之后所有的队列。适用于弹窗进入详情后，后面不再弹窗
 @param identifier 当前弹窗的标识
 @param completion 完成回调
 */
- (void)hideActionAndClearFromQueueWithIdentifier:(NSString*)identifier  completion:(_Nullable DialogManagerBlock)completion;

/// 清空队列
- (void)clearQueue;

/* 唤醒队列，继续往下执行 */
- (void)wakeup;

/* 通过Identifier查询是否存在弹窗 */
- (BOOL)taskIsExistBy:(NSString*)Identifier;

@end

NS_ASSUME_NONNULL_END
