//
//  NSThreadViewController.m
//  MultiThread
//
//  Created by WS on 2017/3/22.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "NSThreadViewController.h"
#import "Person.h"

@interface NSThreadViewController ()

@property (nonatomic, strong) Person *p;
@end

@implementation NSThreadViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    [self startThread2];
}


#pragma mark -
#pragma mark - thread
- (void)startThread1{
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        sleep(2);
        NSLog(@"%@", [NSThread currentThread]);
    }];
    [thread start];
    NSLog(@"start thread");
}

- (void)startThread2{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(start2) object:nil];
    [thread start];
    NSLog(@"start thread");
}
- (void)start2{
    
    NSLog(@"start2%@", [[NSThread currentThread] threadDictionary]);
    sleep(2);
    self.p = [[Person alloc] init];
    NSLog(@"start2%@", [NSThread currentThread]);
}

- (void)startThread3{
    [NSThread detachNewThreadWithBlock:^{
        sleep(2);
        NSLog(@"startThread3%@", [NSThread currentThread]);
    }];
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)startThread4{
    NSLog(@"startThread4-----%d", [NSThread isMultiThreaded]);
    [NSThread detachNewThreadSelector:@selector(start4) toTarget:self withObject:nil];
    NSLog(@"startThread4-----%@", [NSThread currentThread]);
}
- (void)start4{
    NSLog(@"start4------%d", [NSThread isMultiThreaded]);
    sleep(2);   
    NSLog(@"start4------%@", [NSThread currentThread]);
}

#pragma mark -
#pragma mark - tapped response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
