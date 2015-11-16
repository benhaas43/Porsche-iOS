//
//  ViewController.h
//  Porsche Tower
//
//  Created by Daniel on 5/7/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//
#import "DLCustomScrollView.h"
#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController <DLCustomScrollViewDelegate,
                                      DLCustomScrollViewDataSource,
                                      UITableViewDelegate,
                                      UITableViewDataSource,
                                      UIPickerViewDataSource,
                                      UIPickerViewDelegate,
                                      UIAlertViewDelegate,
                                      UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topNavBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@property (weak, nonatomic) IBOutlet DLCustomScrollView *scrollViewBack;
@property (weak, nonatomic) IBOutlet DLCustomScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewPickerBackground;

@property (weak, nonatomic) IBOutlet UIImageView *bottomNavBar;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (void)updateView;
- (void)gotoSubmenu:(NSInteger)index;

- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end

