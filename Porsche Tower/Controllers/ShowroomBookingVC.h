//
//  ShowroomBookingVC.h
//  Porsche Tower
//
//  Created by Povel Sanrov on 27/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

@interface ShowroomBookingVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,
                                                 UIAlertViewDelegate>

@property HomeVC *homeVC;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

- (void)updateBottomButtons;

- (IBAction)onBtnHome:(id)sender;
- (IBAction)onBtnPlus:(id)sender;

@end
