//
//  DisPViewController.m
//  MultiThread
//
//  Created by WS on 2017/4/23.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "DisPViewController.h"

@interface DisPViewController ()

@end

@implementation DisPViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];
//    [self startThread1];
    [self startThread6];
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
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
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



@end
