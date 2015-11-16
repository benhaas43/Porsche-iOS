//
//  MaintenanceVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 27/08/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "MaintenanceVC.h"
#import "Global.h"
#import "WebConnector.h"
#import <MBProgressHUD.h>

@interface MaintenanceVC () {
    NSArray *building_maintenance;
}

@end

@implementation MaintenanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getDataList:@"building_maintenance" completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"success"]) {
            building_maintenance = [result[@"building_maintenance"] mutableCopy];
            [self.tableView reloadData];
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.viewEventContent.layer.borderColor = [UIColor redColor].CGColor;
    self.viewEventContent.layer.borderWidth = 2;
    
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        self.lblFrom.font = [UIFont systemFontOfSize:20];
        self.lblMaintenance.font = [UIFont systemFontOfSize:20];
    }
    else {
        self.lblFrom.font = [UIFont systemFontOfSize:10];
        self.lblMaintenance.font = [UIFont systemFontOfSize:10];
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
    return building_maintenance.count;
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
    lblFrom.text = [building_maintenance objectAtIndex:indexPath.row][@"from"];
    lblFrom.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    lblFrom.font = font;
    [cell addSubview:lblFrom];
    
    UILabel *lblEvent = [[UILabel alloc] initWithFrame:CGRectMake(lblFrom.frame.size.width + 20, 0, tableView.frame.size.width - lblFrom.frame.size.width - 20 - 50, height)];
    lblEvent.textColor = [UIColor whiteColor];
    lblEvent.text = [NSString stringWithFormat:@"%@ - %@", [building_maintenance objectAtIndex:indexPath.row][@"title"], [building_maintenance objectAtIndex:indexPath.row][@"description"]];
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
    self.txtEvent.text = [NSString stringWithFormat:@"%@\n%@\n%@", [building_maintenance objectAtIndex:indexPath.row][@"from"], [building_maintenance objectAtIndex:indexPath.row][@"title"], [building_maintenance objectAtIndex:indexPath.row][@"description"]];
    self.lblLocation.text = [building_maintenance objectAtIndex:indexPath.row][@"location"];
    self.lblDate.text = [NSString stringWithFormat:@"%@ ~ %@", [building_maintenance objectAtIndex:indexPath.row][@"start_date"], [building_maintenance objectAtIndex:indexPath.row][@"end_date"]];
    self.lblStartTime.text = [NSString stringWithFormat:@"Start Time: %@", [building_maintenance objectAtIndex:indexPath.row][@"start_time"]];
    self.lblEndTime.text = [NSString stringWithFormat:@"End Time: %@", [building_maintenance objectAtIndex:indexPath.row][@"end_time"]];
}

- (IBAction)onClose:(id)sender {
    self.viewEvent.hidden = YES;
}

- (IBAction)onBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
