//
//  Global.m
//  Porsche Tower
//
//  Created by Daniel on 5/7/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "Global.h"
#import <UIKit/UIKit.h>

@implementation Global

+ (Global *)sharedInstance {
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.btnImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"elevator"],
                              [UIImage imageNamed:@"apartment"],
                              [UIImage imageNamed:@"garage"],
                              [UIImage imageNamed:@"wellness"],
                              [UIImage imageNamed:@"activities"],
                              [UIImage imageNamed:@"dining"],
                              [UIImage imageNamed:@"noticeboard"],
                              [UIImage imageNamed:@"info"],
                              nil];
        
        self.backImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Elevator01"],
                               [UIImage imageNamed:@"Apartment01"],
                               [UIImage imageNamed:@"Garage01"],
                               [UIImage imageNamed:@"Wellness01"],
                               [UIImage imageNamed:@"Activities01"],
                               [UIImage imageNamed:@"Dining01"],
                               [UIImage imageNamed:@"Noticeboard01"],
                               [UIImage imageNamed:@"Info01"],
                               nil];
        
        self.bottomItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
