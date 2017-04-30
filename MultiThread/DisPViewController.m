//
//  DisPViewController.m
//  MultiThread
//
//  Created by WS on 2017/4/23.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "DisPViewController.h"

@interface DisPViewController ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation DisPViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];
//    [self startThread1];
    [self groupStartRequestNetwork];
}

#pragma mark -
#pragma mark - thread start
- (void)startThread1{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"1");
    });
}

- (void)startThread2{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"2");
    });
}

- (void)startThread3{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        sleep(4);
        NSLog(@"1");
    });
    
    dispatch_group_async(group, queue, ^{
        sleep(5);
        NSLog(@"2");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"3");
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(7);
        NSLog(@"4");
        dispatch_group_leave(group);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"wait log");
    });
}

- (void)startThread4{
    dispatch_queue_t queue = dispatch_queue_create("ws", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        sleep(4);
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"2");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"3");
    });
    
    dispatch_async(queue, ^{
        sleep(6);
        NSLog(@"4");
    });
    
    dispatch_async(queue, ^{
        dispatch_apply(5, queue, ^(size_t i) {
            NSLog(@"%@", [NSThread currentThread]);
            NSLog(@"5");
        });
    });
    
}

- (void)startThread5{
    dispatch_queue_t queue = dispatch_queue_create("ws", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        sleep(4);
        NSLog(@"1");
    });
    
    
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        sleep(5);
        NSLog(@"2");
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_block_cancel(block2);
}

- (void)startThread6{
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_queue_create("ws", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"1");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        sleep(5);
        NSLog(@"2");
    });
    
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"3");
        dispatch_semaphore_signal(semaphore);
        NSLog(@"4");
    });
}

#pragma mark -
#pragma mark - network1
- (void)startRequestNetwork{
    [self reqeustAllApi:^(NSString *responseData) {
        NSLog(@"thread - %@, responseData - %@", [NSThread currentThread], responseData);
    }];
}

- (void)reqeustAllApi:(void(^)(NSString *responseData))successBlock{
    _semaphore = dispatch_semaphore_create(0);
    __block NSString *result1, *result2, *result3;
    
    
    [self request1:_semaphore successBlock:^(NSString *responseData) {
        
        result1 = responseData;
        NSLog(@"%@", result1);
    }];
    
    [self request2:_semaphore successBlock:^(NSString *responseData) {
        
        result2 = responseData;
        NSLog(@"%@", result2);
    }];
    
    [self request3:_semaphore successBlock:^(NSString *responseData) {
        
        result3 = responseData;
        NSLog(@"%@", result3);
    }];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        [self requestFinalresult1:result1
                          result2:result2
                          result3:result3
                     successBlock:^(NSString *responseData) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             successBlock(responseData);
                         });
                     }];
        
    });
    
}

- (void)request1:(dispatch_semaphore_t)semaphore successBlock:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"1");
        dispatch_semaphore_signal(semaphore);
    }];
}

- (void)request2:(dispatch_semaphore_t)semaphore successBlock:(void(^)(NSString *responseData))successBlock{
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"2");
        dispatch_semaphore_signal(semaphore);
    }];
}

- (void)request3:(dispatch_semaphore_t)semaphore successBlock:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"3");
        dispatch_semaphore_signal(semaphore);
    }];
}

- (void)requestFinalresult1:(NSString *)result1
                    result2:(NSString *)result2
                    result3:(NSString *)result3
               successBlock:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        
        NSString *finalResult = [NSString stringWithFormat:@"%@%@%@", result1, result2, result3];
        successBlock(finalResult);
    }];
}

- (void)apiRequest:(void(^)(NSString *responseData))successBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int sleepTime = arc4random() % 4 + 2;
        sleep(sleepTime);
        NSString *responseData = [NSString stringWithFormat:@"%d", sleepTime];
        successBlock(responseData);
    });
}

#pragma mark -
#pragma mark - network2
- (void)groupStartRequestNetwork{
    [self groupReqeustAllApi:^(NSString *responseData) {
        NSLog(@"thread - %@, responseData - %@", [NSThread currentThread], responseData);
    }];
}

- (void)groupReqeustAllApi:(void(^)(NSString *responseData))successBlock{
    
    dispatch_group_t group = dispatch_group_create();
    __block NSString *result1, *result2, *result3;
    
    
    dispatch_group_enter(group);
    [self groupRequest1:^(NSString *responseData) {
        
        result1 = responseData;
        NSLog(@"%@", result1);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self groupRequest2:^(NSString *responseData) {
        
        result2 = responseData;
        NSLog(@"%@", result2);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self groupRequest3:^(NSString *responseData) {
        
        result3 = responseData;
        NSLog(@"%@", result3);
        dispatch_group_leave(group);
    }];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        [self groupRequestFinalresult1:result1
                               result2:result2
                               result3:result3
                          successBlock:^(NSString *responseData) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  successBlock(responseData);
                              });
                          }];
        
    });
    
//    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//        
//        NSLog(@"%@", [NSThread currentThread]);
//        
//        [self groupRequestFinalresult1:result1
//                               result2:result2
//                               result3:result3
//                          successBlock:^(NSString *responseData) {
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  successBlock(responseData);
//                              });
//                          }];
//    });
    
}

- (void)groupRequest1:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"1");
    }];
}

- (void)groupRequest2:(void(^)(NSString *responseData))successBlock{
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"2");
    }];
}

- (void)groupRequest3:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        successBlock(@"3");
    }];
}

- (void)groupRequestFinalresult1:(NSString *)result1
                         result2:(NSString *)result2
                         result3:(NSString *)result3
                    successBlock:(void(^)(NSString *responseData))successBlock{
    
    [self apiRequest:^(NSString *responseData) {
        
        NSString *finalResult = [NSString stringWithFormat:@"%@%@%@", result1, result2, result3];
        successBlock(finalResult);
    }];
}

- (void)groupApiRequest:(void(^)(NSString *responseData))successBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int sleepTime = arc4random() % 4 + 2;
        sleep(sleepTime);
        NSString *responseData = [NSString stringWithFormat:@"%d", sleepTime];
        successBlock(responseData);
    });
}
@end
