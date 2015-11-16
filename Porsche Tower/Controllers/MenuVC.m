//
//  MenuVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 08/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "MenuVC.h"
#import "Global.h"
#import "WebConnector.h"
#import <MBProgressHUD.h>
#import "DescriptionVC.h"
#import "CalendarVC.h"
#import "GymServiceVC.h"
#import "DescriptionWithCallVC.h"

@interface MenuVC () {
    NSArray *menuArray;
}

@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *bottomItems;

@end

@implementation MenuVC

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
    
    if ([self.type isEqualToString:@"gym"]) {
        menuArray = [NSArray arrayWithObjects:@"Personal Trainers", @"Classes", @"Equipment", nil];
        [self.tableView reloadData];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WebConnector *webConnector = [[WebConnector alloc] init];
        [webConnector getDataList:self.type completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            if ([result[@"status"] isEqualToString:@"success"]) {
                menuArray = [result[[NSString stringWithFormat:@"%@_list", self.type]] mutableCopy];
                [self.tableView reloadData];
            }
        } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
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

- (IBAction)onBtnHome:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.homeVC updateView];
    }];
}

- (IBAction)onBtnPlus:(id)sender {
    int status = 0;
    if ([self.type isEqualToString:@"service_car"] ||
        [self.type isEqualToString:@"detailing"]) {
        status = 2;
    }
    else if ([self.type isEqualToString:@"taxis"] ||
             [self.type isEqualToString:@"shuttles"] ||
             [self.type isEqualToString:@"car_rental"]) {
        status = 4;
    }
    else if ([self.type isEqualToString:@"spa"] ||
             [self.type isEqualToString:@"gym"] ||
             [self.type isEqualToString:@"gym_classes"] ||
             [self.type isEqualToString:@"gym_trainers"] ||
             [self.type isEqualToString:@"gym_equipment"] ||
             [self.type isEqualToString:@"beach_hire"] ||
             [self.type isEqualToString:@"pool"] ||
             [self.type isEqualToString:@"massage"] ||
             [self.type isEqualToString:@"barber"]) {
        status = 5;
    }
    else if ([self.type isEqualToString:@"roomservice"] ||
             [self.type isEqualToString:@"bars"] ||
             [self.type isEqualToString:@"restaurants"] ||
             [self.type isEqualToString:@"lounges"] ||
             [self.type isEqualToString:@"pool_restaurants"] ||
             [self.type isEqualToString:@"terraces"]) {
        status = 7;
    }
    
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
    self.tableView.hidden = NO;
    
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

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [cell.textLabel setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:28]];
    }
    else {
        [cell.textLabel setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:18]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if ([self.type isEqualToString:@"service_car"] ||
        [self.type isEqualToString:@"detailing"] ||
        [self.type isEqualToString:@"spa"] ||
        [self.type isEqualToString:@"barber"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"service"];
    }
    else if ([self.type isEqualToString:@"beach_hire"] ||
             [self.type isEqualToString:@"pool"] ||
             [self.type isEqualToString:@"massage"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"name"];
    }
    else if ([self.type isEqualToString:@"gym"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    }
    else if ([self.type isEqualToString:@"gym_classes"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"gym_class_name"];
    }
    else if ([self.type isEqualToString:@"gym_trainers"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"staff_name"];
    }
    else if ([self.type isEqualToString:@"gym_equipment"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"name"];
    }
    else if ([self.type isEqualToString:@"taxis"] ||
             [self.type isEqualToString:@"shuttles"] ||
             [self.type isEqualToString:@"car_rental"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"company"];
    }
    else if ([self.type isEqualToString:@"roomservice"] ||
             [self.type isEqualToString:@"bars"] ||
             [self.type isEqualToString:@"restaurants"] ||
             [self.type isEqualToString:@"lounges"] ||
             [self.type isEqualToString:@"pool_restaurants"] ||
             [self.type isEqualToString:@"terraces"]) {
        cell.textLabel.text = [menuArray objectAtIndex:indexPath.row][@"name"];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        height = 62;
    }
    else {
        height = 40;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.hidden = YES;
    
    if ([self.type isEqualToString:@"service_car"] ||
        [self.type isEqualToString:@"detailing"] ||
        [self.type isEqualToString:@"spa"] ||
        [self.type isEqualToString:@"gym_equipment"] ||
        [self.type isEqualToString:@"beach_hire"] ||
        [self.type isEqualToString:@"pool"] ||
        [self.type isEqualToString:@"massage"] ||
        [self.type isEqualToString:@"barber"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DescriptionVC *descriptionVC = [storyboard instantiateViewControllerWithIdentifier:@"DescriptionVC"];
        descriptionVC.view.backgroundColor = [UIColor clearColor];
        descriptionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        descriptionVC.homeVC = self.homeVC;

        descriptionVC.emailData = [[NSMutableDictionary alloc] init];
        if ([self.type isEqualToString:@"service_car"] ||
            [self.type isEqualToString:@"detailing"] ||
            [self.type isEqualToString:@"spa"] ||
            [self.type isEqualToString:@"barber"]) {
            [descriptionVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"service"] forKey:@"service"];
        }
        else if ([self.type isEqualToString:@"gym_equipment"] ||
                 [self.type isEqualToString:@"beach_hire"] ||
                 [self.type isEqualToString:@"pool"] ||
                 [self.type isEqualToString:@"massage"]) {
            [descriptionVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"name"] forKey:@"name"];
        }
        [descriptionVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"description"] forKey:@"description"];
        [descriptionVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"cat_id"] forKey:@"cat_id"];
        [descriptionVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"location"] forKey:@"location"];
        [descriptionVC.emailData setObject:self.type forKey:@"type"];
        
        self.definesPresentationContext = YES;
        [self presentViewController:descriptionVC animated:NO completion:^{
            return;
        }];
    }
    else if ([self.type isEqualToString:@"gym"]) {
        self.homeVC.lblSubTitle.text = [menuArray objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            self.type = @"gym_trainers";
        }
        else if (indexPath.row == 1) {
            self.type = @"gym_classes";
        }
        else if (indexPath.row == 2) {
            self.type = @"gym_equipment";
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WebConnector *webConnector = [[WebConnector alloc] init];
        [webConnector getDataList:self.type completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            if ([result[@"status"] isEqualToString:@"success"]) {
                menuArray = [result[@"service_list"] mutableCopy];
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
        } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else if ([self.type isEqualToString:@"gym_classes"] ||
             [self.type isEqualToString:@"gym_trainers"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GymServiceVC *gymServiceVC = [storyboard instantiateViewControllerWithIdentifier:@"GymServiceVC"];
        gymServiceVC.view.backgroundColor = [UIColor clearColor];
        gymServiceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        gymServiceVC.homeVC = self.homeVC;
        
        gymServiceVC.emailData = [[NSMutableDictionary alloc] init];
        if ([self.type isEqualToString:@"gym_classes"]) {
            [gymServiceVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"gym_class_name"] forKey:@"name"];
        }
        else {
            [gymServiceVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"staff_name"] forKey:@"name"];
        }
        [gymServiceVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"description"] forKey:@"description"];
        [gymServiceVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"phone"] forKey:@"phone"];
        [gymServiceVC.emailData setObject:self.type forKey:@"type"];
        
        NSURL *url = [NSURL URLWithString:[menuArray objectAtIndex:indexPath.row][@"image"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        gymServiceVC.imgStaff.image = image;
        
        self.definesPresentationContext = YES;
        [self presentViewController:gymServiceVC animated:NO completion:^{
            return;
        }];
    }
    else if ([self.type isEqualToString:@"taxis"] ||
             [self.type isEqualToString:@"shuttles"] ||
             [self.type isEqualToString:@"car_rental"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DescriptionWithCallVC *descriptionWithCallVC = [storyboard instantiateViewControllerWithIdentifier:@"DescriptionWithCallVC"];
        descriptionWithCallVC.view.backgroundColor = [UIColor clearColor];
        descriptionWithCallVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        descriptionWithCallVC.homeVC = self.homeVC;
        
        descriptionWithCallVC.emailData = [[NSMutableDictionary alloc] init];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"company"] forKey:@"company"];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"phone"] forKey:@"phone"];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"description"] forKey:@"description"];
        [descriptionWithCallVC.emailData setObject:self.type forKey:@"type"];
        
        self.definesPresentationContext = YES;
        [self presentViewController:descriptionWithCallVC animated:NO completion:^{
            return;
        }];
    }
    else if ([self.type isEqualToString:@"roomservice"] ||
             [self.type isEqualToString:@"bars"] ||
             [self.type isEqualToString:@"restaurants"] ||
             [self.type isEqualToString:@"lounges"] ||
             [self.type isEqualToString:@"pool_restaurants"] ||
             [self.type isEqualToString:@"terraces"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DescriptionWithCallVC *descriptionWithCallVC = [storyboard instantiateViewControllerWithIdentifier:@"DescriptionWithCallVC"];
        descriptionWithCallVC.view.backgroundColor = [UIColor clearColor];
        descriptionWithCallVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        descriptionWithCallVC.homeVC = self.homeVC;
        
        descriptionWithCallVC.emailData = [[NSMutableDictionary alloc] init];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"name"] forKey:@"name"];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"phone"] forKey:@"phone"];
        [descriptionWithCallVC.emailData setObject:[menuArray objectAtIndex:indexPath.row][@"description"] forKey:@"description"];
        [descriptionWithCallVC.emailData setObject:self.type forKey:@"type"];
        
        self.definesPresentationContext = YES;
        [self presentViewController:descriptionWithCallVC animated:NO completion:^{
            return;
        }];
    }
}

#pragma mark - TapGesture
- (void)handleTapBottom:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:NO completion:^{
        NSInteger index = 0;
        
        for (int i = 0; i < self.btnImageArray.count; i++)
            if ([self.btnImageArray objectAtIndex:i] == ((UIImageView *)[self.bottomItems objectAtIndex:tap.view.tag]).image)
                index = i;
        [self.homeVC gotoSubmenu:index];
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
