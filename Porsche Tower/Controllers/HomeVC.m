//
//  ViewController.m
//  Porsche Tower
//
//  Created by Daniel on 5/7/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "HomeVC.h"
#import "Global.h"
#import "MenuVC.h"
#import "ShowroomBookingVC.h"
#import "PersonalNotificationsVC.h"
#import "EventNotificationsVC.h"
#import "MaintenanceVC.h"

#define TIME 1.4
#define TAG_BOTTOM_BUTTON   20

@interface HomeVC ()<DLCustomScrollViewDelegate,DLCustomScrollViewDataSource>

{
    NSInteger status;
    
    BOOL isSubMenu;
    NSArray *subMenuArray;
    
    NSMutableArray *bottomItems;
}

@property (nonatomic) CGFloat viewSize;
@property (nonatomic) CGSize viewBackSize;
@property (nonatomic) NSArray *btnImageArray;
@property (nonatomic) NSArray *backImageArray;
@property (nonatomic) NSMutableArray *pickerData;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sub Title Font
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        [self.lblSubTitle setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:27]];
    }
    else {
        [self.lblSubTitle setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:17]];
    }
    
    self.pickerData = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"Request Car Elevator", @"Schedule Car Elevator", nil],
                       [NSArray arrayWithObjects:@"Request Maintenance", @"Request House Keeping", nil],
                       [NSArray arrayWithObjects:@"Service Car", @"Detailing", nil],
                       [NSArray arrayWithObjects:@"Solon Spa", @"Fitness", @"Beach Hire", @"Pool", nil],
                       [NSArray arrayWithObjects:@"Golf Sim", @"Racing Sim", @"Theater", @"Community Room", nil],
                       [NSArray arrayWithObjects:@"In House Dinning", @"Local Restaurants", nil],
                       [NSArray arrayWithObjects:@"Warranties", @"Owners Manual", @"Contractors Manual", @"Condominium Documents", nil],
                       [NSArray arrayWithObjects:@"Directory", @"Personal Notifications", @"Building Maintenance", @"Building Events", nil],
                       nil];
    
    Global *global = [Global sharedInstance];
    self.btnImageArray = global.btnImageArray;
    self.backImageArray = global.backImageArray;
    
    isSubMenu = NO;
    subMenuArray = [self.pickerData objectAtIndex:0];
    self.tableView.hidden = YES;
    self.pickerView.hidden = YES;
    self.viewPickerBackground.hidden = YES;
    
    UITapGestureRecognizer *submenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSubmenu:)];
    [self.pickerView addGestureRecognizer:submenuTap];
    submenuTap.delegate = self;
    
    UIPanGestureRecognizer *submenuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSubmenu:)];
    [self.pickerView addGestureRecognizer:submenuPan];
    submenuPan.delegate = self;
    
    self.imgTopLeft.hidden = YES;
    
    bottomItems = global.bottomItems;
    
    self.scrollView.dataSource = self;
    self.scrollView.maxScrollDistance = 5;
    self.scrollView.delegate = self;
    self.scrollView.tag = 1;
    
    self.scrollViewBack.dataSource = self;
    self.scrollViewBack.maxScrollDistance = 5;
    self.scrollViewBack.delegate = nil;
    self.scrollViewBack.tag = 2;
    
    status = -1;
    
    UIImage *img1 = [self.btnImageArray objectAtIndex:0];
    self.viewSize = img1.size.width / TIME;
    
    UIImage *img = [self.backImageArray objectAtIndex:0];
    
    NSLog(@"%f %f", self.view.bounds.size.width, self.scrollView.bounds.size.width);
    
    
    //Background Image Size for each device
    if (self.view.bounds.size.width == 736)
        self.viewBackSize = CGSizeMake(self.scrollView.bounds.size.width / 1.4f, img.size.height);
    else if (self.view.bounds.size.width == 667)
        self.viewBackSize = CGSizeMake(self.scrollView.bounds.size.width / 1.5, img.size.height * 1.3f);
    else if (self.view.bounds.size.width == 568)
        self.viewBackSize = CGSizeMake(self.scrollView.bounds.size.width / 1.8f, img.size.height);
    else if (self.view.bounds.size.width == 1024) {
        self.viewSize = img1.size.width;
        self.viewBackSize = CGSizeMake(self.scrollView.bounds.size.width, img.size.height / img.size.width * self.scrollView.bounds.size.width);
    }
    else
        self.viewBackSize = CGSizeMake(img.size.width, img.size.height);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (status == -1) {
        status = 0;
        
        [self.scrollView reloadData];
        [self.scrollViewBack reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    isSubMenu = !isSubMenu;
    
    if (isSubMenu) {
//        self.tableView.hidden = NO;
        self.pickerView.hidden = NO;
        self.viewPickerBackground.hidden = NO;
    }
    else {
        self.tableView.hidden = YES;
        self.pickerView.hidden = YES;
        self.viewPickerBackground.hidden = YES;

        switch (status) {
            case 0:
                self.lblSubTitle.text = @"Car Elevator";
                break;
                
            case 1:
                self.lblSubTitle.text = @"In-Unit";
                break;
                
            case 2:
                self.lblSubTitle.text = @"Car Concierge";
                break;
                
            case 3:
                self.lblSubTitle.text = @"Wellness";
                break;
                
            case 4:
                self.lblSubTitle.text = @"Activities";
                break;
            
            case 5:
                self.lblSubTitle.text = @"Dining";
                break;
                
            case 6:
                self.lblSubTitle.text = @"Documents";
                break;
                
            case 7:
                self.lblSubTitle.text = @"Information Board";
                break;
                
            default:
                break;
        }
    }
    
    self.imgTopLeft.hidden = !self.imgTopLeft.hidden;
    self.scrollView.hidden = !self.scrollView.hidden;
    
    [self updateBottomButtons];
}

- (void)gotoSubmenu:(NSInteger)index {
    if (isSubMenu)
        [self updateView];
    
    self.imgTopLeft.image = [self.btnImageArray objectAtIndex:index];
    status = index;
    
    [self updateView];
    
    [self.scrollView scrollToIndex:status animated:YES];
    
    subMenuArray = [self.pickerData objectAtIndex:index];
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:subMenuArray.count*500 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self.pickerView reloadAllComponents];
}

- (IBAction)onBtnPlus:(id)sender {
    if (isSubMenu)
    {
        for (UIImageView* imgView in bottomItems)
            if ([self.btnImageArray objectAtIndex:status] == imgView.image)
                return;
        if (bottomItems.count == self.btnImageArray.count)
            [bottomItems removeObjectAtIndex:0];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[self.btnImageArray objectAtIndex:status]];
        [bottomItems addObject:imgView];
        [self updateBottomButtons];
    }
}

- (void)updateBottomButtons {
    for (int i = 0; i < bottomItems.count; i++ ) {
        UIImageView *imgView = [bottomItems objectAtIndex:i];
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

- (IBAction)onBtnHome:(id)sender {
    if (isSubMenu)
    {
        [self updateView];
//        status = 0;
//        [self.scrollView scrollToIndex:status animated:YES];
        
    }
}

//# pragma mark - Touch Handler
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//}

# pragma mark - DLCustomScrollView dataSource
- (NSInteger)numberOfViews:(DLCustomScrollView *)scrollView
{
    return 100000;
}

- (CGFloat)widthOfView:(DLCustomScrollView *)scrollView
{
    NSLog(@"scrollWidth: %@", NSStringFromCGRect(scrollView.bounds));
    if (scrollView.tag == 1) {
        return (scrollView.bounds.size.width / 3.5f);
    } else {
        return (scrollView.bounds.size.width /1.7f);
    }
}

# pragma mark - DLCustomScrollView delegate
- (UIView *)scrollView:(DLCustomScrollView *)scrollView viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    //First ScrollView
    if (scrollView.tag == 1)
    {
        //If view was already created
        if (view) {
            if (index < 0)
            {
                if (((-index) % self.btnImageArray.count) == 0)
                {
                    ((UIImageView*)view).image = (UIImage*)[self.btnImageArray objectAtIndex:0];
                    view.tag = 0;
                }
                else
                {
                    ((UIImageView*)view).image = (UIImage*)[self.btnImageArray objectAtIndex:(self.btnImageArray.count - ((-index) % self.btnImageArray.count))];
                    view.tag = self.btnImageArray.count - ((-index) %  self.btnImageArray.count);
                    NSLog(@"ind %lu", (long)index);
                    NSLog(@"tag %lu", (long)view.tag);
                }
            }
            else
            {
                ((UIImageView*)view).image = (UIImage*)[self.btnImageArray objectAtIndex:(index % self.btnImageArray.count)];
                view.tag = index % self.btnImageArray.count;
            }
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [view addGestureRecognizer:singleTap];
            return view;
        }
        //If view is empty
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize, self.viewSize)];
        if (index < 0)
        {
            if ((-index) % self.btnImageArray.count == 0)
            {
                imgView.image = (UIImage*)[self.btnImageArray objectAtIndex:0];
                imgView.tag = 0;
            }
            else
            {
                imgView.image = (UIImage*)[self.btnImageArray objectAtIndex:(self.btnImageArray.count - ((-index) %  self.btnImageArray.count))];
                imgView.tag = self.btnImageArray.count - ((-index) %  self.btnImageArray.count);
            }
        }
        else
        {
            imgView.image = (UIImage*)[self.btnImageArray objectAtIndex:(index % self.btnImageArray.count)];
            imgView.tag = index % self.btnImageArray.count;
        }
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [imgView addGestureRecognizer:singleTap];
        return imgView;
    }
    
    //Background ScrollView
    
    //If view is already created
    if (view) {
        if (index < 0)
            if ((-index) % self.backImageArray.count == 0)
            {
                ((UIImageView*)view).image = (UIImage*)[self.backImageArray objectAtIndex:0];
            }
            else
            {
                ((UIImageView*)view).image = (UIImage*)[self.backImageArray objectAtIndex:(self.backImageArray.count - ((-index) %  self.backImageArray.count))];
            }
            else
            {
                ((UIImageView*)view).image = (UIImage*)[self.backImageArray objectAtIndex:(index % self.backImageArray.count)];
            }
        view.contentMode = UIViewContentModeScaleToFill;
        return view;
    }
    //If view is empty
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewBackSize.width , self.viewBackSize.height)];
    if (index < 0)
        if ((-index) % self.backImageArray.count == 0)
            imgView.image = (UIImage*)[self.backImageArray objectAtIndex:0];
        else
            imgView.image = (UIImage*)[self.backImageArray objectAtIndex:(self.backImageArray.count - ((-index) %  self.backImageArray.count))];
        else
            imgView.image = (UIImage*)[self.backImageArray objectAtIndex:(index % self.backImageArray.count)];
    imgView.contentMode = UIViewContentModeScaleToFill;
    return imgView;
}

- (void)scrollView:(DLCustomScrollView *)scrollView updateView:(UIView *)view withDistanceToCenter:(CGFloat)distance scrollDirection:(ScrollDirection)direction
{
    // you can appy animations duration scrolling here
    if (scrollView.tag == 1)
    {
        CGFloat percent = distance / CGRectGetWidth(self.view.bounds) * 3;
        
        if (percent > -0.05 && percent < 0.05) {
            NSInteger index = view.tag;
            NSLog(@"Center Index: %ld", (long)index);
            
            if (index < 0)
                if ((-index) % self.btnImageArray.count == 0)
                    index = 0;
                else
                    index = self.btnImageArray.count - ((-index) % self.btnImageArray.count);
                else
                    index = index % self.btnImageArray.count;
            
            switch (index) {
                case 0:
                    self.lblSubTitle.text = @"Car Elevator";
                    break;
                    
                case 1:
                    self.lblSubTitle.text = @"In-Unit";
                    break;
                    
                case 2:
                    self.lblSubTitle.text = @"Car Concierge";
                    break;
                    
                case 3:
                    self.lblSubTitle.text = @"Wellness";
                    break;
                    
                case 4:
                    self.lblSubTitle.text = @"Activities";
                    break;
                    
                case 5:
                    self.lblSubTitle.text = @"Dining";
                    break;
                    
                case 6:
                    self.lblSubTitle.text = @"Documents";
                    break;
                    
                case 7:
                    self.lblSubTitle.text = @"Information Board";
                    break;
                    
                default:
                    break;
            }
            
        }
        
        CATransform3D transform = CATransform3DIdentity;
        
        // scale transform
        CGFloat size = self.viewSize;
        CGPoint center = view.center;
        view.center = center;
        size = size * (TIME - 0.3 * (fabs(percent)));
        view.frame = CGRectMake(0, 0, size, size);
        view.layer.cornerRadius = size / 2;
        view.center = center;
        
        // translate
        CGFloat translate = self.viewSize / 3 * percent;
        if (percent > 1) {
            translate = self.viewSize / 3;
        } else if (percent < -1) {
            translate = -self.viewSize / 3;
        }
        transform = CATransform3DTranslate(transform, translate, 0, 0);
        
        view.layer.transform = transform;
    }
    else
    {
        CGFloat percent = distance / CGRectGetWidth(self.view.bounds) * 3;
        
        CATransform3D transform = CATransform3DIdentity;
        
        // scale
        CGFloat size = self.viewSize;
        CGPoint center = view.center;
        view.center = center;
        size = size * (TIME - 0.3 * (fabs(percent)));
        view.frame = CGRectMake(0, 0, size, size);
        view.layer.cornerRadius = size / 2;
        view.center = center;
        
        // translate
        CGFloat translate = self.viewSize / 3 * percent;
        if (percent > 1) {
            translate = self.viewSize / 3;
        } else if (percent < -1) {
            translate = -self.viewSize / 3;
        }
        transform = CATransform3DTranslate(transform, translate, 0, 0);
        
        view.layer.transform = transform;
    }
    
}

- (void)scrollView:(DLCustomScrollView *)scrollView didScrollToOffset:(CGPoint)offset
{
    if (scrollView.tag == 1) {
        NSLog(@"didScrollToOffset");
        CGFloat maxOffset = [scrollView contentSize].width - CGRectGetWidth(scrollView.bounds);
        CGFloat percentage = offset.x / maxOffset;
        CGFloat backMaxOffset = [self.scrollViewBack contentSize].width - CGRectGetWidth(self.scrollViewBack.bounds);
        [self.scrollViewBack scrollToOffset:CGPointMake(percentage * backMaxOffset, 0) animated:NO];
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return subMenuArray.count * 1000;
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
    
    cell.textLabel.text = [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count];
    
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
    
    if (status == 0) {
        self.lblSubTitle.text = [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count];
        
        if (indexPath.row%subMenuArray.count == 1) {
            self.pickerView.hidden = YES;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShowroomBookingVC *showroomBookingVC = [storyboard instantiateViewControllerWithIdentifier:@"ShowroomBookingVC"];
            showroomBookingVC.view.backgroundColor = [UIColor clearColor];
            showroomBookingVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            showroomBookingVC.homeVC = self;
            
            self.definesPresentationContext = YES;
            [self presentViewController:showroomBookingVC animated:NO completion:^{
                
            }];
        }
    }
    else if (status == 1) {
        self.lblSubTitle.text = [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count];
        
        if (indexPath.row%subMenuArray.count == 0) {
            
            self.tableView.hidden = YES;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
            menuVC.view.backgroundColor = [UIColor clearColor];
            menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            menuVC.homeVC = self;
            menuVC.type = @"service_car";
            
            self.definesPresentationContext = YES;
            [self presentViewController:menuVC animated:NO completion:^{
                
            }];
        }
        else if (indexPath.row%subMenuArray.count == 1) {
            
            self.tableView.hidden = YES;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
            menuVC.view.backgroundColor = [UIColor clearColor];
            menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            menuVC.homeVC = self;
            menuVC.type = @"detailing";
            
            self.definesPresentationContext = YES;
            [self presentViewController:menuVC animated:NO completion:^{
                
            }];
        }
    }
    else if (status == 2) {
        self.lblSubTitle.text = [NSString stringWithFormat:@"%@ Menu", [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count]];
        
        self.tableView.hidden = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        menuVC.view.backgroundColor = [UIColor clearColor];
        menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        menuVC.homeVC = self;
        
        if (indexPath.row%subMenuArray.count == 0) {
            menuVC.type = @"spa";
        }
        else if (indexPath.row%subMenuArray.count == 1) {
            menuVC.type = @"gym";
        }
        else if (indexPath.row%subMenuArray.count == 2) {
            menuVC.type = @"beach_hire";
        }
        else if (indexPath.row%subMenuArray.count == 3) {
            menuVC.type = @"pool";
        }
        else if (indexPath.row%subMenuArray.count == 4) {
            menuVC.type = @"massage";
        }
        else if (indexPath.row%subMenuArray.count == 5) {
            menuVC.type = @"barber";
        }
        
        self.definesPresentationContext = YES;
        [self presentViewController:menuVC animated:NO completion:^{
            
        }];
    }
    else if (status == 3) {
        self.lblSubTitle.text = [NSString stringWithFormat:@"%@", [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count]];
        
        self.tableView.hidden = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        menuVC.view.backgroundColor = [UIColor clearColor];
        menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        menuVC.homeVC = self;
        
        if (indexPath.row%subMenuArray.count == 0) {
            
        }
        else if (indexPath.row%subMenuArray.count == 3) {
            menuVC.type = @"taxis";
        }
        else if (indexPath.row%subMenuArray.count == 4) {
            menuVC.type = @"shuttles";
        }
        else if (indexPath.row%subMenuArray.count == 5) {
            menuVC.type = @"car_rental";
        }
        
        self.definesPresentationContext = YES;
        [self presentViewController:menuVC animated:NO completion:^{
            
        }];
    }
    else if (status == 4) {
        self.lblSubTitle.text = [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count];
        
        if (indexPath.row%subMenuArray.count == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PersonalNotificationsVC *personalNotificationsVC = [storyboard instantiateViewControllerWithIdentifier:@"PersonalNotificationsVC"];
            personalNotificationsVC.view.backgroundColor = [UIColor clearColor];
            personalNotificationsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            personalNotificationsVC.homeVC = self;
            
            self.definesPresentationContext = YES;
            [self presentViewController:personalNotificationsVC animated:NO completion:^{
                
            }];
        }
        else if (indexPath.row%subMenuArray.count == 1) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EventNotificationsVC *eventNotificationsVC = [storyboard instantiateViewControllerWithIdentifier:@"EventNotificationsVC"];
            eventNotificationsVC.view.backgroundColor = [UIColor clearColor];
            eventNotificationsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            eventNotificationsVC.homeVC = self;
            
            self.definesPresentationContext = YES;
            [self presentViewController:eventNotificationsVC animated:NO completion:^{
                
            }];
        }
        else if (indexPath.row%subMenuArray.count == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MaintenanceVC *maintenanceVC = [storyboard instantiateViewControllerWithIdentifier:@"MaintenanceVC"];
            maintenanceVC.view.backgroundColor = [UIColor clearColor];
            maintenanceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            maintenanceVC.homeVC = self;
            
            self.definesPresentationContext = YES;
            [self presentViewController:maintenanceVC animated:NO completion:^{
                
            }];
        }
    }
    else if (status == 5) {
        self.lblSubTitle.text = [subMenuArray objectAtIndex:indexPath.row%subMenuArray.count];
        
        self.tableView.hidden = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        menuVC.view.backgroundColor = [UIColor clearColor];
        menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        menuVC.homeVC = self;
        
        if (indexPath.row%subMenuArray.count == 0) {
            menuVC.type = @"roomservice";
        }
        else if (indexPath.row%subMenuArray.count == 1) {
            menuVC.type = @"bars";
        }
        else if (indexPath.row%subMenuArray.count == 2) {
            menuVC.type = @"restaurants";
        }
        else if (indexPath.row%subMenuArray.count == 3) {
            menuVC.type = @"lounges";
        }
        else if (indexPath.row%subMenuArray.count == 4) {
            menuVC.type = @"pool_restaurants";
        }
        else if (indexPath.row%subMenuArray.count == 5) {
            menuVC.type = @"terraces";
        }
        
        self.definesPresentationContext = YES;
        [self presentViewController:menuVC animated:NO completion:^{
            
        }];
    }
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return subMenuArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        CGSize size = [pickerView rowSizeForComponent:component];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        if ([[UIDevice currentDevice].model containsString:@"iPad"])
            [label setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:28]];
        else
            [label setFont:[UIFont fontWithName:NAME_OF_MAINFONT size:18]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        label.numberOfLines=1;
        label.text=[subMenuArray objectAtIndex:row];
        [view addSubview:label];
    }
    
    return view;
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    CGFloat height;
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        height = 62;
    }
    else {
        height = 40;
    }
    return height;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//}

#pragma mark - TapGesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    return true;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return true;
//}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    NSLog(@"Index: %ld", (long)index);

    if (index < 0)
        if ((-index) % self.btnImageArray.count == 0)
            status = 0;
        else
            status = self.btnImageArray.count - ((-index) % self.btnImageArray.count);
        else
            status = index % self.btnImageArray.count;
    
    self.imgTopLeft.image = [self.btnImageArray objectAtIndex:status];
    
    [self.scrollView scrollToIndex:index animated:YES];
    
    [self updateView];
    
    subMenuArray = [self.pickerData objectAtIndex:status];
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:subMenuArray.count*500 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)handleTapSubmenu:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.pickerView];
    CGSize rowSize = [self.pickerView rowSizeForComponent:0];
    CGSize pickerSize = self.pickerView.frame.size;
    
    if ((touchPoint.y > pickerSize.height / 2 - rowSize.height / 2 + 10) && (touchPoint.y < pickerSize.height / 2 + rowSize.height / 2 - 10)) {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        
        if (status == 0) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            self.pickerView.hidden = YES;
            
            if (index == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ShowroomBookingVC *showroomBookingVC = [storyboard instantiateViewControllerWithIdentifier:@"ShowroomBookingVC"];
                showroomBookingVC.view.backgroundColor = [UIColor clearColor];
                showroomBookingVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                showroomBookingVC.homeVC = self;
                
                self.definesPresentationContext = YES;
                [self presentViewController:showroomBookingVC animated:NO completion:^{
                    
                }];
            }
        }
        else if (status == 1) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            self.pickerView.hidden = YES;
        }
        else if (status == 2) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            self.pickerView.hidden = YES;
            
            if (index == 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
                menuVC.view.backgroundColor = [UIColor clearColor];
                menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                menuVC.homeVC = self;
                menuVC.type = @"service_car";
                
                self.definesPresentationContext = YES;
                [self presentViewController:menuVC animated:NO completion:^{
                    
                }];
            }
            else if (index == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
                menuVC.view.backgroundColor = [UIColor clearColor];
                menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                menuVC.homeVC = self;
                menuVC.type = @"detailing";
                
                self.definesPresentationContext = YES;
                [self presentViewController:menuVC animated:NO completion:^{
                    
                }];
            }
        }
        else if (status == 3) {
            self.lblSubTitle.text = [NSString stringWithFormat:@"%@ Menu", [subMenuArray objectAtIndex:index]];
            
            self.pickerView.hidden = YES;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
            menuVC.view.backgroundColor = [UIColor clearColor];
            menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            menuVC.homeVC = self;
            
            if (index == 0) {
                menuVC.type = @"spa";
            }
            else if (index == 1) {
                menuVC.type = @"gym";
            }
            else if (index == 2) {
                menuVC.type = @"beach_hire";
            }
            else if (index == 3) {
                menuVC.type = @"pool";
            }
            
            self.definesPresentationContext = YES;
            [self presentViewController:menuVC animated:NO completion:^{
                
            }];
        }
        else if (status == 4) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            
            self.pickerView.hidden = YES;
        }
        else if (status == 5) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            
            self.pickerView.hidden = YES;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
            menuVC.view.backgroundColor = [UIColor clearColor];
            menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            menuVC.homeVC = self;
            
            if (index == 0) {
                menuVC.type = @"roomservice";
            }
            else if (index == 1) {
                menuVC.type = @"restaurants";
            }
            
            self.definesPresentationContext = YES;
            [self presentViewController:menuVC animated:NO completion:^{
                
            }];
        }
        else if (status == 6) {
            self.lblSubTitle.text = [NSString stringWithFormat:@"%@", [subMenuArray objectAtIndex:index]];
            
            self.pickerView.hidden = YES;
            
        }
        else if (status == 7) {
            self.lblSubTitle.text = [subMenuArray objectAtIndex:index];
            
            if (index == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PersonalNotificationsVC *personalNotificationsVC = [storyboard instantiateViewControllerWithIdentifier:@"PersonalNotificationsVC"];
                personalNotificationsVC.view.backgroundColor = [UIColor clearColor];
                personalNotificationsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                personalNotificationsVC.homeVC = self;
                
                self.definesPresentationContext = YES;
                [self presentViewController:personalNotificationsVC animated:NO completion:^{
                    
                }];
            }
            else if (index == 2) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MaintenanceVC *maintenanceVC = [storyboard instantiateViewControllerWithIdentifier:@"MaintenanceVC"];
                maintenanceVC.view.backgroundColor = [UIColor clearColor];
                maintenanceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                maintenanceVC.homeVC = self;
                
                self.definesPresentationContext = YES;
                [self presentViewController:maintenanceVC animated:NO completion:^{
                    
                }];
            }
            else if (index == 3) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EventNotificationsVC *eventNotificationsVC = [storyboard instantiateViewControllerWithIdentifier:@"EventNotificationsVC"];
                eventNotificationsVC.view.backgroundColor = [UIColor clearColor];
                eventNotificationsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                eventNotificationsVC.homeVC = self;
                
                self.definesPresentationContext = YES;
                [self presentViewController:eventNotificationsVC animated:NO completion:^{
                    
                }];
            }
        }
    }
}

- (void)handlePanSubmenu:(UIPanGestureRecognizer *)pan {
    
}

- (void)handleTapBottom:(UITapGestureRecognizer *)tap {
    if (isSubMenu)
        [self updateView];
    
    NSInteger index = 0;
    
    for (int i = 0; i < self.btnImageArray.count; i++)
        if ([self.btnImageArray objectAtIndex:i] == ((UIImageView *)[bottomItems objectAtIndex:tap.view.tag]).image)
            index = i;
    
    self.imgTopLeft.image = [self.btnImageArray objectAtIndex:index];
    status = index;
    
    [self updateView];
    
    [self.scrollView scrollToIndex:status animated:YES];
    
    subMenuArray = [self.pickerData objectAtIndex:index];
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:subMenuArray.count*500 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)handleLongPressBottom:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateEnded && bottomItems.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove Shortcut" message:@"Are you sure you want to remove this shortcut from the toolbar?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        alertView.tag = longPress.view.tag;
        
        [alertView show];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSInteger index = alertView.tag;
        
        UIImageView *imgView = [bottomItems objectAtIndex:index];
        
        [bottomItems removeObjectAtIndex:index];
        
        [imgView removeFromSuperview];
        
        [self updateBottomButtons];
    }
}

@end
