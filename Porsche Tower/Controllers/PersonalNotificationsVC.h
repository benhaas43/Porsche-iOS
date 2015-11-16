//
//  PersonalNotificationsVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 04/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

@interface PersonalNotificationsVC : UIViewController <UITableViewDelegate,
                                                       UITableViewDataSource>

@property HomeVC *homeVC;

@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (weak, nonatomic) IBOutlet UIView *viewMessageContent;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

- (IBAction)onClose:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
