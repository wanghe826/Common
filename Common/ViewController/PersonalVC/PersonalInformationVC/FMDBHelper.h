//
//  FMDBHelper.h
//  个人信息
//
//  Created by lixiaofeng on 16/3/23.
//  Copyright © 2016年 lixiaofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"                             //数据库
#define KTableNameOne  @"personInformationData1111"  //第一张表

@interface FMDBHelper : NSObject
{
    FMDatabase * fmdata;
}

+(FMDBHelper *)shareManager;

/**
 插入一条数据到数据库中
 */
-(void)insertData:(NSArray *)dataArr andTableName:(NSString *)tableName andName:(NSString *)name andID:(NSString *)data;

/**
 从表中删除一条数据
 */
-(void)deleteData:(NSArray *)dataArr andTableName:(NSString *)tableName andName:(NSString *)name andID:(NSString *)data;

/**
 修改一条数据
 */
-(void)updateData:(NSArray *)dataArr andTableName:(NSString *)tableName  andName:(NSString *)name andID:(NSString *)data;

/**
 查询数据表中的所有数据
 */
-(NSArray *)queryAllWithName:(NSString *)tableName;

@end
