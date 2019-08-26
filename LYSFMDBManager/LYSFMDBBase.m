//
//  LYSFMDBBase.m
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBBase.h"

@interface LYSFMDBBase ()

@end

@implementation LYSFMDBBase

// Documents
+ (NSString *)document
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Library
+ (NSString *)library
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

// Caches
+ (NSString *)caches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

// 初始化
- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        self.filePath = filePath;
    }
    return self;
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
}

#pragma mark - 根据数据类型取数据 -
- (NSDictionary *)gotValueWithSet:(FMResultSet *)resultSet
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.columnDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"text"]) {
            NSString *value = [resultSet stringForColumn:key];
            [dict setObject:value forKey:key];
        }
        else if ([obj isEqualToString:@"date"]) {
            NSDate *value = [resultSet dateForColumn:key];
            [dict setObject:value forKey:key];
        }
        else if ([obj isEqualToString:@"integer"]) {
            NSInteger value = [resultSet intForColumn:key];
            [dict setObject:@(value) forKey:key];
        }
        else if ([obj isEqualToString:@"double"]) {
            double value = [resultSet doubleForColumn:key];
            [dict setObject:@(value) forKey:key];
        }
        else if ([obj isEqualToString:@"YES"]) {
            BOOL value = [resultSet boolForColumn:key];
            [dict setObject:@(value) forKey:key];
        }
        else if ([obj isEqualToString:@"Byte"]) {
            NSData *value = [resultSet dataForColumn:key];
            [dict setObject:value forKey:key];
        }
    }];
    return dict;
}
@end
