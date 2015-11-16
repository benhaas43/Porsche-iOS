//
//  SelectTimeVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 14/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "SelectTimeVC.h"
#import "MenuVC.h"
#import "Global.h"
#import "WebConnector.h"
#import <MBProgressHUD.h>

@interface SelectTimeVC ()

@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *bottomItems;

@end

@implementation SelectTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timePicker.backgroundColor = [UIColor blackColor];
    [self.timePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    Global *global = [Global sharedInstance];
    self.btnImageArray = global.btnImageArray;
    self.backImageArray = global.backImageArray;
    self.bottomItems = global.bottomItems;
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [self.btnCancel.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [self.btnSave.titleLabel setFont:[UIFont systemFontOfSize:25]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (IBAction)onBtnCancel:(id)sender {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [menuVC updateBottomButtons];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)onBtnSave:(id)sender {
    BOOL ok = [MFMailComposeViewController canSendMail];
    if (!ok) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device not configured to send mail...!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSDate *date = [self.timePicker date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger hour = [timeComponents hour];
        NSInteger minute = [timeComponents minute];
        
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.selectedDate];
        [components setHour:hour];
        [components setMinute:minute];
        self.selectedDate = [calendar dateFromComponents:components];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeZone:[calendar timeZone]];
        NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        [timeFormatter setTimeZone:[calendar timeZone]];
        NSString *timeString = [timeFormatter stringFromDate:self.selectedDate];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *owner = [prefs objectForKey:@"CurrentUser"];
        
        NSString *emailTitle = @"";
        
        NSString *messageBody = @"";
        NSString *emailType = [self.emailData objectForKey:@"type"];
        if ([emailType isEqualToString:@"service_car"] ||
            [emailType isEqualToString:@"detailing"] ||
            [emailType isEqualToString:@"spa"] ||
            [emailType isEqualToString:@"barber"]) {
            messageBody = [NSString stringWithFormat:@"The owner, %@ %@, from unit %@ requests an %@ on %@ at %@", owner[@"first_name"], owner[@"last_name"], owner[@"number"], [self.emailData objectForKey:@"service"], dateString, timeString];
        }
        else if ([emailType isEqualToString:@"gym_equipment"] ||
                 [emailType isEqualToString:@"beach_hire"] ||
                 [emailType isEqualToString:@"pool"] ||
                 [emailType isEqualToString:@"massage"]) {
            messageBody = [NSString stringWithFormat:@"The owner, %@ %@, from unit %@ requests an %@ on %@ at %@", owner[@"first_name"], owner[@"last_name"], owner[@"number"], [self.emailData objectForKey:@"name"], dateString, timeString];
        }
        else if ([emailType isEqualToString:@"showroom_booking"]) {
            messageBody = [NSString stringWithFormat:@"The owner, %@ %@, from unit %@ has requested the %@ %@ to be picked-up on %@ at %@", owner[@"first_name"], owner[@"last_name"], owner[@"number"], [self.emailData objectForKey:@"car_name"], [self.emailData objectForKey:@"car_id"], dateString, timeString];
        }
        
        NSMutableArray *toRecipents = [[NSMutableArray alloc] init];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WebConnector *webConnector = [[WebConnector alloc] init];
        [webConnector getDataList:@"locations" completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            if ([result[@"status"] isEqualToString:@"success"]) {
                NSMutableArray *locations = [result[@"locations_list"] mutableCopy];
                for (int i = 0; i < locations.count; i++) {
                    NSMutableDictionary *location = [locations[i] mutableCopy];
                    if ([location[@"name"] isEqualToString:self.emailData[@"location"]] ||
                        [location[@"name"] isEqualToString:@"Building Managers Office"]) {
                        [toRecipents addObject:location[@"email"]];
                    }
                }
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                
                [self presentViewController:mc animated:YES completion:NULL];
            }
        } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        NSString *eventName = @"";
        if ([emailType isEqualToString:@"service_car"] ||
            [emailType isEqualToString:@"detailing"] ||
            [emailType isEqualToString:@"spa"] ||
            [emailType isEqualToString:@"barber"]) {
            eventName = [self.emailData objectForKey:@"service"];
        }
        else if ([emailType isEqualToString:@"gym_equipment"] ||
                 [emailType isEqualToString:@"beach_hire"] ||
                 [emailType isEqualToString:@"pool"] ||
                 [emailType isEqualToString:@"massage"]) {
            eventName = [self.emailData objectForKey:@"name"];
        }
        else if ([emailType isEqualToString:@"showroom_booking"]) {
            eventName = [NSString stringWithFormat:@"%@ %@", [self.emailData objectForKey:@"car_name"], [self.emailData objectForKey:@"car_id"]];
        }
        
        [webConnector addToCalendar:[self.emailData objectForKey:@"cat_id"] name:eventName description:messageBody date:self.selectedDate completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
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

#pragma mark - MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled");
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            [self messageAlert:@"Mail cancelled: you cancelled the operation and no email message was queued." stats:@"Cancelled"];
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved");
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            [self messageAlert:@"Mail saved: you saved the email message in the drafts folder." stats:@"Saved"];
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail sent");
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [self messageAlert:@"Mail send: the email message is queued in the outbox. It is ready to send." stats:@"Sent"];
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            //NSLog(@"Due to some error your email sending failed.");
            [self messageAlert:@"Due to some error your email sending failed" stats:@"Failed"];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void) messageAlert:(NSString*)str stats:(NSString*)status {
    if ([status isEqualToString:@"Failed"]) {
        UIAlertView *connectionAlert = [[UIAlertView alloc] init];
        [connectionAlert setTitle:@"Error"];
        [connectionAlert setMessage:str];
        [connectionAlert setDelegate:self];
        [connectionAlert setTag:1];
        [connectionAlert addButtonWithTitle:@"Ok"];
        [connectionAlert show];
    }
    else {
        UIAlertView *connectionAlert = [[UIAlertView alloc] init];
        [connectionAlert setTitle:@""];
        [connectionAlert setMessage:str];
        [connectionAlert setDelegate:self];
        [connectionAlert setTag:1];
        [connectionAlert addButtonWithTitle:@"Ok"];
        [connectionAlert show];
        
        if (![status isEqualToString:@"Cancelled"]) {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
    }
}

@end
