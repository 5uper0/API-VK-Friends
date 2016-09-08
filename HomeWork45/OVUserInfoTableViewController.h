//
//  OVUserInfoTableViewController.h
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OVUser;

@interface OVUserInfoTableViewController : UITableViewController

@property (strong, nonatomic) OVUser *user;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionsButton;
@property (weak, nonatomic) IBOutlet UIButton *wallButton;

@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCityAndAgeLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *detailInfoLabels;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

- (IBAction)actionFollowers:(UIButton *)sender;
- (IBAction)actionSubscriptions:(UIButton *)sender;
- (IBAction)actionWall:(UIButton *)sender;

@end
