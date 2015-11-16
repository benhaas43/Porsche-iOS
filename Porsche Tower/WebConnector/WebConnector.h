//
//  WebConnector.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 19/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface WebConnector : NSObject {
    AFHTTPRequestOperationManager *httpManager;
    NSString *baseUrl;
}

typedef void (^CompleteBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^ErrorBlock)(AFHTTPRequestOperation *operation, NSError *error);

- (void)login:(NSString *)email password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getDataList:(NSString *)type completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)addToCalendar:(NSString *)categoryId name:(NSString *)name description:(NSString *)description date:(NSDate *)date completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;

@end
