//
//  SelectTimeVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 14/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HomeVC.h"

@interface SelectTimeVC : UIViewController <MFMailComposeViewControllerDelegate,
                                            UIAlertViewDelegate>

@property HomeVC *homeVC;
@property NSMutableDictionary *emailData;
@property NSDate *selectedDate;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end
