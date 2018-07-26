//
//  LYSFMDBManager.h
//  H5Dev
//
//  Created by liyangshuai on 2018/4/13.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * --- Documents 使用该路径放置关键数据，也就是不能通过App重新生成的数据。该路径可通过配置实现iTunes共享文件。可被iTunes备份。（现在保存在该路径下的文件还需要考虑iCloud同步),如数据库文件，或程序中浏览到的文件数据。如果进行备份会将此文件夹中的文件包括其中
 * --- Library 该路径下一般保存着用户配置文件。可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份
 *     -- Caches 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 *     -- Preferences 存储应用的默认设置及状态信息
 * --- tmp 提供一个即时创建临时文件的地方
 */

@interface LYSFMDBManager : NSObject

// Documents
+ (NSString *)document;
// Library
+ (NSString *)library;
// Caches
+ (NSString *)caches;

+ (instancetype)sharedManager;

/**
 初始化数据路径地址

 @param filePath 路径
 @return 返回LYSFMDBManager对象
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

/**
 创建数据库表

 @param indexDict 以JSON的形式描述数据的字段以及类型
 @param tableName 数据表的名字
 @param callBack 返回是否创建成功回调
 */
- (void)createTableWithIndexDict:(NSDictionary<NSString *, NSString *> *)indexDict
                       tableName:(NSString *)tableName
                        callBack:(void(^)(BOOL isSuccess))callBack;

/**
 添加数据

 @param valueDict 以JSON的形式向数据库中添加数据
 @param tableName 数据表的名字
 @param callBack 返回是否添加成功回调
 */
- (void)addLineWithDict:(NSDictionary<NSString *, id> *)valueDict
              tableName:(NSString *)tableName
               callBack:(void(^)(BOOL isSuccess))callBack;

/**
 删除数据

 @param dict 以JSON的形式匹配要删除的数据,并删除
 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)deleteLineWithDict:(NSDictionary<NSString *,id> *)dict
                 tableName:(NSString *)tableName
                  callBack:(void(^)(BOOL isSuccess))callBack;

/**
 更新数据

 @param dict 以JSON的形式匹配要更新的数据
 @param valueDict 以JSON的形式替换匹配要的数据
 @param tableName 数据表的名字
 @param callBack 返回是否更新成功
 */
- (void)updateLineWithDict:(NSDictionary<NSString *,id> *)dict
                 valueDict:(NSDictionary<NSString *,id> *)valueDict
                 tableName:(NSString *)tableName
                  callBack:(void(^)(BOOL isSuccess))callBack;

/**
 查询所有数据

 @param tableName 数据表的名字
 @param callBack 返回查询到的所有数据
 */
- (void)queryAllLineWithTableName:(NSString *)tableName
                         callBack:(void(^)(NSArray *resultAry))callBack;

/**
 查询给定条件下的数据

 @param dict 以JSON的形式匹配数据
 @param tableName 数据表的名字
 @param callBack 返回匹配到的数据
 */
- (void)queryLineWithDict:(NSDictionary<NSString *,id> *)dict
                tableName:(NSString *)tableName
                 callBack:(void(^)(NSArray *resultAry))callBack;

/**
 分页查询

 @param page 要查询的页数
 @param limit 每页的数据
 @param tableName 数据表的名字
 @param callBack 返回查询到的数据
 */
- (void)queryLineWithPage:(NSInteger)page limit:(NSInteger)limit
                tableName:(NSString *)tableName
                 callBack:(void(^)(NSArray *resultAry))callBack;

/**
 批量插入数据,事务

 @param valueAry 数组嵌套JSON的形式批量插入数据
 @param tableName 数据表的名字
 @param callBack 返回是否插入成功
 */
- (void)batchAddLineWithDict:(NSArray<NSDictionary<NSString *, id> *> *)valueAry
                   tableName:(NSString *)tableName
                    callBack:(void(^)(BOOL isSuccess))callBack;

/**
 批量删除数据,事务

 @param dictAry 数组嵌套JSON的形式批量删除数据
 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)batchDeleteLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry
                      tableName:(NSString *)tableName
                       callBack:(void(^)(BOOL isSuccess))callBack;

/**
 批量更新数据,事务

 @param dictAry 数组嵌套JSON的形式匹配数据
 @param valueAry 数组嵌套JSON的形式更新数据
 @param tableName 数据表的名字
 @param callBack 返回是否更新成功
 */
- (void)batchUpdateLineWithDict:(NSArray<NSDictionary<NSString *,id> *> *)dictAry
                      valueDict:(NSArray<NSDictionary<NSString *,id> *> *)valueAry
                      tableName:(NSString *)tableName callBack:(void(^)(BOOL isSuccess))callBack;


/**
 清空表格

 @param tableName 数据表的名字
 @param callBack 返回是否清除成功
 */
- (void)clearTableName:(NSString *)tableName
              callBack:(void(^)(BOOL isSuccess))callBack;

/**
 删除表格

 @param tableName 数据表的名字
 @param callBack 返回是否删除成功
 */
- (void)deleteTableName:(NSString *)tableName
               callBack:(void(^)(BOOL isSuccess))callBack;
@end
