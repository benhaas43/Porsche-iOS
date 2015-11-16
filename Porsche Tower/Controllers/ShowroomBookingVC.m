//
//  ShowroomBookingVC.m
//  Porsche Tower
//
//  Created by Povel Sanrov on 27/07/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "ShowroomBookingVC.h"
#import "Global.h"
#import <MBProgressHUD.h>
#import "WebConnector.h"
#import "CalendarVC.h"

@interface ShowroomBookingVC () {
    NSMutableArray *carInfoArray;
}

@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *bottomItems;

@end

@implementation ShowroomBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getDataList:@"car_information" completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"success"]) {
            carInfoArray = [[NSMutableArray alloc] initWithArray:[result[@"car_info_list"] mutableCopy]];
            
            for (int i = 0; i < carInfoArray.count; i++) {
                NSMutableDictionary *carInfo = [carInfoArray[i] mutableCopy];
                NSURL *url = [NSURL URLWithString:carInfo[@"image"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                [carInfo setObject:image forKey:@"imageData"];
                [carInfoArray replaceObjectAtIndex:i withObject:carInfo];
            }
            
            [self.collectionView reloadData];
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    Global *global = [Global sharedInstance];
    self.btnImageArray = global.btnImageArray;
    self.backImageArray = global.backImageArray;
    self.bottomItems = global.bottomItems;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
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

- (IBAction)onBtnHome:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.homeVC updateView];
    }];
}

- (IBAction)onBtnPlus:(id)sender {
    for (UIImageView* imgView in self.bottomItems)
        if ([self.btnImageArray objectAtIndex:2] == imgView.image)
            return;
    if (self.bottomItems.count == self.btnImageArray.count)
        [self.bottomItems removeObjectAtIndex:0];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self.btnImageArray objectAtIndex:2]];
    [self.bottomItems addObject:imgView];
    [self updateBottomButtons];
}

- (void)updateBottomButtons {
    self.collectionView.hidden = NO;
    
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

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return carInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarImageCell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    imageView.alpha = 1.0;
    
    [imageView setImage:carInfoArray[indexPath.row][@"imageData"]];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:102];
    lblName.text = carInfoArray[indexPath.row][@"name"];

    return cell;
}

#pragma mark - UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width - 10) / 2, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarVC *calendarVC = [storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
    calendarVC.view.backgroundColor = [UIColor clearColor];
    calendarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    calendarVC.homeVC = self.homeVC;
    
    calendarVC.emailData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *carInfo = carInfoArray[indexPath.row];
    [calendarVC.emailData setObject:[carInfo objectForKey:@"name"] forKey:@"car_name"];
    [calendarVC.emailData setObject:[carInfo objectForKey:@"id"] forKey:@"car_id"];
    [calendarVC.emailData setObject:[carInfo objectForKey:@"location"] forKey:@"location"];
    [calendarVC.emailData setObject:[carInfo objectForKey:@"cat_id"] forKey:@"cat_id"];
    [calendarVC.emailData setObject:@"showroom_booking" forKey:@"type"];
    
    self.definesPresentationContext = YES;
    self.collectionView.hidden = YES;
    [self presentViewController:calendarVC animated:NO completion:^{
        return;
    }];
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
