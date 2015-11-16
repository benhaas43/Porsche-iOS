//
//  LoginVC.m
//  Porsche Tower
//
//  Created by Daniel on 5/9/15.
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import "LoginVC.h"
#import "Global.h"
#import "HomeVC.h"
#import <MBProgressHUD.h>
#import "WebConnector.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *font = [UIFont fontWithName:NAME_OF_MAINFONT size:11.0f];
    [self.lblLogin setFont:font];
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

- (IBAction)onLogin:(id)sender {
    NSString *email = self.txtEmail.text;
    NSString *password = self.txtPassword.text;
    
    if ([email isEqualToString:@""] || [password isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector login:email password:password completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"success"]) {
            NSDictionary *owner = result[@"owner"];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:owner forKey:@"CurrentUser"];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeVC *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            
            [self.navigationController pushViewController:homeVC animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Failed to login" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
