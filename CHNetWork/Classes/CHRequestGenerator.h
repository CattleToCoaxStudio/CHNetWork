//
//  CHRequestGenerator.h
// 
//
//  Created by ba on 16/6/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRequestGenerator : NSObject
+(instancetype)shardInstance;
-(NSURLRequest*)generatorGETRequestWithParams:(NSDictionary*)params;
-(NSURLRequest*)generatorPOSTRequestWithParams:(NSDictionary*)params;
-(NSURLRequest*)generatorPUTRequestWithParams:(NSDictionary*)params;
-(NSURLRequest*)generatorDELETERequestWithParams:(NSDictionary*)params;

@end
