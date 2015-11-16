//
//  WebConnector.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 19/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "WebConnector.h"

@implementation WebConnector

- (id)init {
    if (self = [super init]) {
//        baseUrl = @"http://localhost/CodeIgniter-3.0.0/index.php/mobile/Mobile/";
        baseUrl = @"http://52.26.240.113/Porsche/index.php/mobile/Mobile/";
        NSURL *url = [NSURL URLWithString:baseUrl];
        
        httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];        
    }
    
    return self;
}

- (void)login:(NSString *)email password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:password forKey:@"password"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [prefs objectForKey:@"DeviceToken"];
    [parameters setObject:deviceToken forKey:@"device_token"];
//    [parameters setObject:@"1bfe0817206ea50c7e62cd66a89286ed39c09892133d26e841bf828c3aeb0b75" forKey:@"device_token"];
    
    [httpManager POST:@"login" parameters:parameters success:completed failure:errorBlock];
}

- (void)getDataList:(NSString *)type completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *owner = [prefs objectForKey:@"CurrentUser"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:owner[@"owner_index"] forKey:@"owner"];
    
    [httpManager POST:[NSString stringWithFormat:@"get_%@", type] parameters:parameters success:completed failure:errorBlock];
}

- (void)addToCalendar:(NSString *)categoryId name:(NSString *)name description:(NSString *)description date:(NSDate *)date completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *owner = [prefs objectForKey:@"CurrentUser"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%@,%@", categoryId, owner[@"cat_id"]] forKey:@"cat_id"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:description forKey:@"description"];
    [parameters setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
    [parameters setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
    [parameters setObject:[NSNumber numberWithInteger:day] forKey:@"day"];
    [parameters setObject:[NSNumber numberWithInteger:hour > 12 ? hour - 12 : hour] forKey:@"entry_hour"];
    [parameters setObject:[NSNumber numberWithInteger:minute] forKey:@"entry_minute"];
    [parameters setObject:hour >= 12 ? @"pm" : @"am" forKey:@"entry_ampm"];
    
    [httpManager POST:@"add_to_calendar" parameters:parameters success:completed failure:errorBlock];
}

@end
