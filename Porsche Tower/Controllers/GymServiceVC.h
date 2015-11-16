//
//  GymServiceVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 09/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HomeVC.h"

@interface GymServiceVC : UIViewController <MFMailComposeViewControllerDelegate,
                                            UIAlertViewDelegate>

@property HomeVC *homeVC;
@property NSMutableDictionary *emailData;

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *viewImageBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imgStaff;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (IBAction)onBtnClose:(id)sender;
- (IBAction)onBtnCall:(id)sender;
- (IBAction)onBtnEmail:(id)sender;
- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end
