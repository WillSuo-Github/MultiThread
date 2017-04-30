//
//  ViewController.m
//  MultiThread
//
//  Created by WS on 2017/3/22.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "ViewController.h"
#import "NSThreadViewController.h"
#import "NSOperationViewController.h"
#import "DisPViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *sourceArr;

@property (nonatomic, strong) DisPViewController *dispVc;
@end

@implementation ViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:tableView];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
}

#pragma mark -
#pragma mark - tapped response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self presentViewController:[[NSThreadViewController alloc] init] animated:true completion:nil];
            break;
        case 1:
            [self presentViewController:[[DisPViewController alloc] init] animated:true completion:nil];
            break;
        case 2:
            [self presentViewController:[[NSOperationViewController alloc] init] animated:true completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _sourceArr[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark - lazy
- (NSArray *)sourceArr{
    if (!_sourceArr) {
        _sourceArr = @[@"NSThread", @"Dispath", @"NSOperation"];
    }
    return _sourceArr;
}

- (DisPViewController *)dispVc{
    if (_dispVc == nil) {
        _dispVc = [[DisPViewController alloc] init];
    }
    return _dispVc;
}


@end
