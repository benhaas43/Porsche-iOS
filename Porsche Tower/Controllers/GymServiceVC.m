//
//  GymServiceVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 09/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "GymServiceVC.h"
#import "Global.h"
#import "MenuVC.h"

@interface GymServiceVC ()

@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *bottomItems;

@end

@implementation GymServiceVC

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
    
    self.viewImageBorder.layer.borderColor = [UIColor redColor].CGColor;
    self.viewImageBorder.layer.borderWidth = 2;
    
    self.txtDescription.text = [NSString stringWithFormat:@"%@\n%@", [self.emailData objectForKey:@"name"], [self.emailData objectForKey:@"description"]];
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

- (IBAction)onBtnClose:(id)sender {
    MenuVC *menuVC = (MenuVC *)self.presentationController.presentingViewController;
    [menuVC updateBottomButtons];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)onBtnCall:(id)sender {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", [self.emailData objectForKey:@"phone"]]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Call is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)onBtnEmail:(id)sender {
    BOOL ok = [MFMailComposeViewController canSendMail];
    if (!ok) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device not configured to send mail...!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSString *email = @"bhaas@unlimitedcompanies.com";
        NSString *emailTitle = @"";
        
        NSString *messageBody = @"";
        
        NSArray *toRecipents = [NSArray arrayWithObject:email];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
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
    for (UIImageView* imgView in self.bottomItems)
        if ([self.btnImageArray objectAtIndex:5] == imgView.image)
            return;
    if (self.bottomItems.count == self.btnImageArray.count)
        [self.bottomItems removeObjectAtIndex:0];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self.btnImageArray objectAtIndex:5]];
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
