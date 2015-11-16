//
//  DescriptionVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 09/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "DescriptionVC.h"
#import "Global.h"
#import "MenuVC.h"
#import "CalendarVC.h"

@interface DescriptionVC ()

@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *bottomItems;

@end

@implementation DescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Global *global = [Global sharedInstance];
    self.btnImageArray = global.btnImageArray;
    self.backImageArray = global.backImageArray;
    self.bottomItems = global.bottomItems;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.viewContent.layer.borderColor = [UIColor redColor].CGColor;
    self.viewContent.layer.borderWidth = 2;
    
    self.txtDescription.text = [self.emailData objectForKey:@"description"];
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [self.txtDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    else {
        [self.txtDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    }
    
    [self updateBottomButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnSelect:(id)sender {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CalendarVC *calendarVC = [storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
        calendarVC.view.backgroundColor = [UIColor clearColor];
        calendarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        calendarVC.homeVC = self.homeVC;
        
        calendarVC.emailData = [self.emailData mutableCopy];
        
        menuVC.definesPresentationContext = YES;
        [menuVC presentViewController:calendarVC animated:NO completion:^{
            return;
        }];
    }];
}

- (IBAction)onBtnClose:(id)sender {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [menuVC updateBottomButtons];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)onBtnHome:(id)sender {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [menuVC dismissViewControllerAnimated:NO completion:^{
            [self.homeVC updateView];
        }];
    }];
}

- (IBAction)onBtnPlus:(id)sender {
    int status = 0;
    NSString *type = [self.emailData objectForKey:@"type"];
    if ([type isEqualToString:@"service_car"] ||
        [type isEqualToString:@"detailing"]) {
        status = 2;
    }
//    else if ([type isEqualToString:@"taxis"] ||
//             [type isEqualToString:@"shuttles"] ||
//             [type isEqualToString:@"car_rental"]) {
//        status = 4;
//    }
    else if ([type isEqualToString:@"spa"] ||
//             [type isEqualToString:@"gym"] ||
//             [type isEqualToString:@"gym_classes"] ||
//             [type isEqualToString:@"gym_trainers"] ||
             [type isEqualToString:@"gym_equipment"] ||
             [type isEqualToString:@"beach_hire"] ||
             [type isEqualToString:@"pool"] ||
             [type isEqualToString:@"massage"] ||
             [type isEqualToString:@"barber"]) {
        status = 5;
    }
//    else if ([type isEqualToString:@"roomservice"] ||
//             [type isEqualToString:@"bars"] ||
//             [type isEqualToString:@"restaurants"] ||
//             [type isEqualToString:@"lounges"] ||
//             [type isEqualToString:@"pool_restaurants"] ||
//             [type isEqualToString:@"terraces"]) {
//        status = 7;
//    }
    
    for (UIImageView* imgView in self.bottomItems)
        if ([self.btnImageArray objectAtIndex:status] == imgView.image)
            return;
    if (self.bottomItems.count == self.btnImageArray.count)
        [self.bottomItems removeObjectAtIndex:0];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self.btnImageArray objectAtIndex:status]];
    [self.bottomItems addObject:imgView];
    [self updateBottomButtons];
}

- (void)updateBottomButtons {
    for (int i = 0; i < self.bottomItems.count; i++ ) {
        UIImageView *imgView = [self.bottomItems objectAtIndex:i];
        imgView.frame = CGRectMake(self.btnHome.frame.origin.x + ((self.btnPlus.frame.origin.x - self.btnHome.frame.origin.x) / self.btnImageArray.count) * (i+ 1), self.btnHome.frame.origin.y, self.btnHome.frame.size.width, self.btnHome.frame.size.height);
        imgView.tag = i;
        
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapBottom:)];
        [imgView addGestureRecognizer:singleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressBottom:)];
        [imgView addGestureRecognizer:longPress];
        
        [self.view addSubview:imgView];
    }
}

#pragma mark - TapGesture
- (void)handleTapBottom:(UITapGestureRecognizer *)tap {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [menuVC dismissViewControllerAnimated:NO completion:^{
            NSInteger index = 0;
            
            for (int i = 0; i < self.btnImageArray.count; i++)
                if ([self.btnImageArray objectAtIndex:i] == ((UIImageView *)[self.bottomItems objectAtIndex:tap.view.tag]).image)
                    index = i;
            [self.homeVC gotoSubmenu:index];
        }];
    }];
}

- (void)handleLongPressBottom:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateEnded && self.bottomItems.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove Shortcut" message:@"Are you sure you want to remove this shortcut from the toolbar?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        alertView.tag = longPress.view.tag;
        
        [alertView show];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSInteger index = alertView.tag;
        
        UIImageView *imgView = [self.bottomItems objectAtIndex:index];
        
        [self.bottomItems removeObjectAtIndex:index];
        
        [imgView removeFromSuperview];
        
        [self updateBottomButtons];
    }
}

@end
