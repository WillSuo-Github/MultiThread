//
//  Person.m
//  MultiThread
//
//  Created by WS on 2017/4/22.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark -
#pragma mark - life cycle
- (instancetype)init{
    if (self == [super init]) {
        NSLog(@"%@",[NSThread currentThread]);
    }
    return self;
}


- (void)dealloc{
    NSLog(@"person dealloc");
}
@end
