
//  Created by ba on 16/6/28.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface CHPresistence : NSObject
@property(nonatomic,strong)FMDatabase *chBase;
+(instancetype)shardInstance;
-(void)creaeTable;
-(void)insertWiht:(NSString*)key andData:(NSData*)data;
-(NSData*)selectWithKey:(NSString*)key;
-(void)upDataWithKey:(NSString *)key andData:(NSData *)data;
-(void)deleteWithKey:(NSString *)key;
-(void)insertToWiht:(NSString *)key andData:(NSData *)data;
@end
