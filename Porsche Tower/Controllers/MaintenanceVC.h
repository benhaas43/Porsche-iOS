//
//  MaintenanceVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 27/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

@interface MaintenanceVC : UIViewController <UITableViewDelegate,
                                            UITableViewDataSource>

@property HomeVC *homeVC;

@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblMaintenance;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewEvent;
@property (weak, nonatomic) IBOutlet UIView *viewEventContent;
@property (weak, nonatomic) IBOutlet UITextView *txtEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;

- (IBAction)onClose:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
