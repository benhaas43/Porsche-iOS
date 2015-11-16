//
//  MenuVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 08/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

@interface MenuVC : UIViewController <UITableViewDelegate,
                                      UITableViewDataSource,
                                      UIAlertViewDelegate>

@property HomeVC *homeVC;
@property NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (void)updateBottomButtons;

- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end
