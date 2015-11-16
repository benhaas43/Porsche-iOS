//
//  EventNotificationsVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 04/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "EventNotificationsVC.h"
#import "Global.h"
#import "WebConnector.h"
#import <MBProgressHUD.h>

@interface EventNotificationsVC () {
    NSArray *eventNotifications;
}

@end

@implementation EventNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getDataList:@"event_notifications" completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"success"]) {
            eventNotifications = [result[@"event_notifications"] mutableCopy];
            [self.tableView reloadData];
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.viewEventContent.layer.borderColor = [UIColor redColor].CGColor;
    self.viewEventContent.layer.borderWidth = 2;
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        self.lblFrom.font = [UIFont systemFontOfSize:20];
        self.lblEvent.font = [UIFont systemFontOfSize:20];
    }
    else {
        self.lblFrom.font = [UIFont systemFontOfSize:10];
        self.lblEvent.font = [UIFont systemFontOfSize:10];
    }
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [self.txtEvent setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    else {
        [self.txtEvent setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
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
    return eventNotifications.count;
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
    lblFrom.text = [eventNotifications objectAtIndex:indexPath.row][@"from"];
    lblFrom.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lblFrom.font = font;
    [cell addSubview:lblFrom];
    
    UILabel *lblEvent = [[UILabel alloc] initWithFrame:CGRectMake(lblFrom.frame.size.width + 20, 0, tableView.frame.size.width - lblFrom.frame.size.width - 20 - 50, height)];
    lblEvent.textColor = [UIColor whiteColor];
    lblEvent.text = [NSString stringWithFormat:@"%@ - %@", [eventNotifications objectAtIndex:indexPath.row][@"brief_description"], [eventNotifications objectAtIndex:indexPath.row][@"detailed_description"]];
    lblEvent.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lblEvent.font = font;
    [cell addSubview:lblEvent];
    
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
    self.viewEvent.hidden = NO;
    self.txtEvent.text = [NSString stringWithFormat:@"%@\n%@\n%@", [eventNotifications objectAtIndex:indexPath.row][@"from"], [eventNotifications objectAtIndex:indexPath.row][@"brief_description"], [eventNotifications objectAtIndex:indexPath.row][@"detailed_description"]];
    self.lblLocation.text = [eventNotifications objectAtIndex:indexPath.row][@"location"];
    self.lblDate.text = [eventNotifications objectAtIndex:indexPath.row][@"date"];
    self.lblStartTime.text = [NSString stringWithFormat:@"Start Time: %@", [eventNotifications objectAtIndex:indexPath.row][@"start"]];
    self.lblEndTime.text = [NSString stringWithFormat:@"End Time: %@", [eventNotifications objectAtIndex:indexPath.row][@"end"]];
}

- (IBAction)onClose:(id)sender {
    self.viewEvent.hidden = YES;
}

- (IBAction)onBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
