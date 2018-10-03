//
//  LYSFMDBCreateTable.h
//  LYSFMDBManagerDemo
//
//  Created by liyangshuai on 2018/10/3.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import "LYSFMDBBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSFMDBCreateTable : LYSFMDBBase
/**
 创建数据库表
 
 @param indexDict 以JSON的形式描述数据的字段以及类型
 @param tableName 数据表的名字
 @param callBack 返回是否创建成功回调
 */
- (void)createTableWithIndexDict:(NSDictionary<NSString *, NSString *> *)indexDict
                       tableName:(NSString *)tableName
                        callBack:(void(^)(BOOL isSuccess))callBack;
@end

NS_ASSUME_NONNULL_END
