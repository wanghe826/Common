//
//  FMDBHelper.m
//  个人信息
//
//  Created by lixiaofeng on 16/3/23.
//  Copyright © 2016年 lixiaofeng. All rights reserved.
//

#import "FMDBHelper.h"

#define KSex @"sex"                             //性别
#define KBirthday @"birthday"                   //生日
#define KHight @"hight"                         //身高
#define KWight @"wight"                         //体重
#define KBloodType @"bloodType"                 //血型
#define KUnitSystem @"unitSystem"               //单位制
#define KName  @"name"                          //名字
#define KID @"ID"                               //特征号

@implementation FMDBHelper

+(FMDBHelper *)shareManager
{
    //创建单例
    static FMDBHelper * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FMDBHelper alloc]init];
    });
    return helper;
}

/**
 重写 init 方法
 */
-(id)init
{
    if (self = [super init]) {
        
        //创建数据库
        [self createDataBase];
        //创建表
        [self createDataTable];
        
    }
    return self;
}

//创建数据库
-(void)createDataBase
{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"InventoryList.db"];
    // NSLog(@"path:%@",path);
    
    fmdata = [FMDatabase databaseWithPath:path];
    
    if (![fmdata open]) {
        NSLog(@"打开数据库失败");
    }
}

//创建表
-(void)createDataTable
{
     //创建第一张表--保存个人界面的个人数据
    NSString * sql = [NSString stringWithFormat:@"create table if not exists %@(%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text primary key)",KTableNameOne,KSex,KBirthday,KHight,KWight,KBloodType,KUnitSystem,KName,KID];
    if (![fmdata executeUpdate:sql]) {
        NSLog(@"创建第一张表失败");
    }
}

/**
 插入一条数据到数据库中
 */
-(void)insertData:(NSArray *)dataArr andTableName:(NSString *)tableName andName:(NSString *)name andID:(NSString *)data
{
    NSString * sqlStr = [NSString stringWithFormat:@"insert into %@(%@,%@,%@,%@,%@,%@,%@,%@)values(?,?,?,?,?,?,?,?)",tableName,KSex,KBirthday,KHight,KWight,KBloodType,KUnitSystem,KName,KID];
    if (![fmdata executeUpdate:sqlStr,dataArr[0],dataArr[1],dataArr[2],dataArr[3],dataArr[4],dataArr[5],name,data]) {
        NSLog(@"插入失败");
    }
}

/**
 从表中删除一条数据
 */
-(void)deleteData:(NSArray *)dataArr andTableName:(NSString *)tableName andName:(NSString *)name andID:(NSString * )data
{
    NSString * sqlStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",tableName,KID];
    if (![fmdata executeUpdate:sqlStr,data]) {
         NSLog(@"删除失败");
    }
}

/**
 修改一条数据
 */
-(void)updateData:(NSArray *)dataArr andTableName:(NSString *)tableName  andName:(NSString *)name andID:(NSString *)data
{
    NSString * sqlStr = [NSString stringWithFormat:@"update %@ set %@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?where %@ = ?",tableName,KSex,KBirthday,KHight,KWight,KBloodType,KUnitSystem,KName,KID];
    if (![fmdata executeUpdate:sqlStr,dataArr[0],dataArr[1],dataArr[2],dataArr[3],dataArr[4],dataArr[5],name,data]) {
        NSLog(@"更新失败");
    }
}

/**
 查询数据表中的所有数据
 */
-(NSArray *)queryAllWithName:(NSString *)tableName
{
    NSString * sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    NSMutableArray * dataSource = [[NSMutableArray alloc]init];
    FMResultSet * result = [fmdata executeQuery:sqlStr];
    while ([result next]) {
        NSString * sexStr = [result stringForColumn:@"sex"];
        NSString * birthdayStr = [result stringForColumn:@"birthday"];
        NSString * hightStr = [result stringForColumn:@"hight"];
        NSString * wightStr = [result stringForColumn:@"wight"];
        NSString * bloodStr = [result stringForColumn:@"bloodType"];
        NSString * unitSystemStr = [result stringForColumn:@"unitSystem"];
        NSString * nameStr = [result stringForColumn:@"name"];
        NSString * ID = [result stringForColumn:@"ID"];

         NSMutableArray * dataARR = [[NSMutableArray alloc]initWithObjects:sexStr,birthdayStr,hightStr,wightStr,bloodStr,unitSystemStr,nameStr,ID,nil];
        
        [dataSource addObjectsFromArray:dataARR];
    }
    return dataSource;
}

@end
