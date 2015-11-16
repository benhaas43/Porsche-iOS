//
//  Global.h
//  Porsche Tower
//
//  Created by Daniel on 5/7/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

//String
#define NAME_OF_MAINFONT @"PorscheDesignFont"

@interface Global : NSObject

+ (Global *)sharedInstance;

@property (strong, nonatomic, readwrite) NSArray *btnImageArray;
@property (strong, nonatomic, readwrite) NSArray *backImageArray;
@property (strong, nonatomic, readwrite) NSMutableArray *bottomItems;

@end
