//
//  NSOperationViewController.m
//  MultiThread
//
//  Created by WS on 2017/3/23.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSInvocationOperation *operation2;
@property (nonatomic, strong) NSInvocationOperation *operation1;
@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blueColor];
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    
    
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:@selector(operation2start)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
    inv.target = self;
    inv.selector = @selector(operation2start);
    
    self.operation2 = [[NSInvocationOperation alloc] initWithInvocation:inv];
    self.operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operation1start) object:nil];
    
    [self.operation1 addObserver:self forKeyPath:@"cancelled" options:NSKeyValueObservingOptionNew context:nil];
    [_operation1 addObserver:self forKeyPath:@"executing" options:NSKeyValueObservingOptionNew context:nil];
    [_operation1 addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew context:nil];
//    [operation2 addDependency:operation1];
//    self.queue.maxConcurrentOperationCount = 2;
    [self.queue addOperation:self.operation1];
    [self.queue addOperation:self.operation2];
    
    
}

- (void)operation1start{
//    [_queue cancelAllOperations];
    sleep(1);
    
    if ([self.operation1 isCancelled]) {
//        [NSThread exit];
        NSLog(@"op1 is Cancle");
        return;
    }
    if ([self.operation2 isConcurrent]) {
        NSLog(@"op1 is concurrent");
    }
    NSLog(@"operation1start");
}
- (void)operation2start{
    sleep(1);
    if ([self.operation2 isCancelled]) {
//        [NSThread exit];
        NSLog(@"op2 is Cancle");
    }
    NSLog(@"operation2start");
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@", change);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
