//
//  CalendarVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 10/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"
#import "PMCalendar.h"

@interface CalendarVC : UIViewController <PMCalendarControllerDelegate,
                                          UIAlertViewDelegate>

@property HomeVC *homeVC;
@property NSMutableDictionary *emailData;
@property NSDate *selectedDate;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end
