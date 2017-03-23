
//
//  Created by ba on 16/6/28.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CHPresistence.h"
#import "CHNetworkingConfig.h"
static NSTimeInterval CHPresistenceTimeSeconds = 1800;//持久化时间1800秒
@implementation CHPresistence
static CHPresistence *shard = nil;
+(instancetype)shardInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shard) {
            shard = [[CHPresistence alloc]init];
        }
    });
    return shard;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *databasePath = [cachesPath stringByAppendingPathComponent:@"CHPresistence.db"];
        self.chBase = [FMDatabase databaseWithPath:databasePath];
        [self.chBase clearCachedStatements];
        
    }
    return self;
}

-(void)creaeTable
{
    if ([self.chBase open]) {
        NSLog(@"------------打开库成功-------------");
        BOOL isOk = [self.chBase executeUpdate:@"create table if not exists Presistence (dataKey text primary key,time real,data real)"];
        
        if (isOk) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    }else{
        NSLog(@"----------打开库失败-----------");
    }
}
-(void)insertWiht:(NSString *)key andData:(NSData *)data
{
    NSDate *time = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.chBase executeUpdate:@"insert into Presistence (time,dataKey,data) values (?,?,?)",time,key,data];

}
-(void)insertToWiht:(NSString *)key andData:(NSData *)data
{   static int i;
    i = (arc4random()%100+2);
   
    NSString *y = [NSString stringWithFormat:@"%d",i];
    NSString *n = @"fdsdf";
    [self.chBase executeUpdate:@"insert into PresistenceTwo (id,name,dataKeyTwo) values (?,?,?)",y,n,key];
    
}
-(void)upDataWithKey:(NSString *)key andData:(NSData *)data
{
  //  NSDate *time = [NSDate dateWithTimeIntervalSinceNow:0];
 [self.chBase executeUpdate:@"update Presistence set data=? where dataKey=?",data,key];

}
-(void)deleteWithKey:(NSString *)key
{
    [self.chBase executeUpdate:@"delete from Presistence where dataKey=?",key];

}
-(NSData*)selectWithKey:(NSString*)key
{
    NSData *data = nil;
    
    FMResultSet *resultSet = [self.chBase executeQuery:@"select * from Presistence where datakey=?",key];
    
    while (resultSet.next) {
        
        if ([key isEqualToString:[resultSet stringForColumn:@"datakey"]]) {
            
            NSDate *time = [resultSet dateForColumn:@"time"];
            if ([self isOutdatedWith:time]) {
                data = [resultSet dataForColumn:@"data"];
                break;
            }else{
                [self deleteWithKey:key];
            }
        }
    }

    return data;
}
-(BOOL)isOutdatedWith:(NSDate*)date
{
    NSTimeInterval time = [[NSDate date]timeIntervalSinceDate:date];
    return time < [CHNetworkingConfig shardInstance].cacheTime;
    
}
//删除表中所有数据
- (void)deleteTableAllData{
    [self.chBase executeUpdate:@"delete from Presistence"];
}

@end
