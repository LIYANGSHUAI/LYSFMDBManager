//
//  ViewController.m
//  LYSFMDBManagerDemo
//
//  Created by HENAN on 2018/7/26.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "ViewController.h"
#import "LYSFMDBManager.h"

@interface ViewController ()
@property (nonatomic, strong)LYSFMDBManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [[LYSFMDBManager library] stringByAppendingPathComponent:@"test.db"];
    NSLog(@"%@",filePath);
    self.manager = [[LYSFMDBManager alloc] initWithFilePath:filePath];
    [self.manager createTableWithIndexDict:@{
                                             @"name": @"text",
                                             @"age": @"integer",
                                             @"sig": @"integer"
                                             } tableName:@"list" callBack:^(BOOL isSuccess) {
                                                 if (isSuccess) {
                                                     NSLog(@"成功!");
                                                     
                                                 } else {
                                                     NSLog(@"失败!");
                                                 }
                                             }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.manager addLineWithDict:@{
                                    @"name": @"lys",
                                    @"age": @17,
                                    @"sig": @1
                                    } tableName:@"list" callBack:^(BOOL isSuccess) {
                                        
                                    }];
    
    
    [self.manager queryAllLineWithTableName:@"list" callBack:^(NSArray * _Nonnull resultAry) {
        NSLog(@"%@",resultAry);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
