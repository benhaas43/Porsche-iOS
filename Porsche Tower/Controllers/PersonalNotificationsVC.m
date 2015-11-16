//
//  PersonalNotificationsVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 04/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "PersonalNotificationsVC.h"
#import "Global.h"
#import "WebConnector.h"
#import <MBProgressHUD.h>

@interface PersonalNotificationsVC () {
    NSArray *personalNotifications;
}

@end

@implementation PersonalNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getDataList:@"personal_notifications" completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"success"]) {
            personalNotifications = [result[@"personal_notifications"] mutableCopy];
            [self.tableView reloadData];
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.viewMessageContent.layer.borderColor = [UIColor redColor].CGColor;
    self.viewMessageContent.layer.borderWidth = 2;
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        self.lblFrom.font = [UIFont systemFontOfSize:20];
        self.lblMessage.font = [UIFont systemFontOfSize:20];
    }
    else {
        self.lblFrom.font = [UIFont systemFontOfSize:10];
        self.lblMessage.font = [UIFont systemFontOfSize:10];
    }
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [self.txtMessage setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    else {
        [self.txtMessage setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    }
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

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personalNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor blackColor];
    }
    else {
        cell.backgroundColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    CGFloat height;
    UIFont *font = [UIFont systemFontOfSize:17];
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        height = 62;
        font = [UIFont systemFontOfSize:27];
    }
    else {
        height = 35;
    }
    
    UILabel *lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width / 5, height)];
    lblFrom.textColor = [UIColor whiteColor];
    lblFrom.text = [personalNotifications objectAtIndex:indexPath.row][@"from"];
    lblFrom.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lblFrom.font = font;
    [cell addSubview:lblFrom];
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblFrom.frame.size.width + 20, 0, tableView.frame.size.width - lblFrom.frame.size.width - 20 - 50, height)];
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.text = [NSString stringWithFormat:@"%@ - %@", [personalNotifications objectAtIndex:indexPath.row][@"subject"], [personalNotifications objectAtIndex:indexPath.row][@"message"]];
    lblMessage.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lblMessage.font = font;
    [cell addSubview:lblMessage];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        height = 62;
    }
    else {
        height = 35;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewMessage.hidden = NO;
    self.txtMessage.text = [NSString stringWithFormat:@"%@\n%@\n%@", [personalNotifications objectAtIndex:indexPath.row][@"from"], [personalNotifications objectAtIndex:indexPath.row][@"subject"], [personalNotifications objectAtIndex:indexPath.row][@"message"]];
}

- (IBAction)onClose:(id)sender {
    self.viewMessage.hidden = YES;
}

- (IBAction)onBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
