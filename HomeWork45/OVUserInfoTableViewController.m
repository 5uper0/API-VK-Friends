//
//  OVUserInfoTableViewController.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVFollowersTableViewController.h"
#import "OVUserInfoTableViewController.h"
#import "OVUser.h"
#import "OVServerManager.h"
#import "OVSubscriptionsTableViewController.h"
#import "OVWallTableViewController.h"
#import "ViewController.h"
#import "UIImageView+AFNetworking.h"

@interface OVUserInfoTableViewController () <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *rowsTagsToShow;

@end

typedef enum : NSUInteger {
    OVSectionNameFriendInfo,
    OVSectionNameExplore,
    OVSectionNameSelfStory,
} OVSectionName;

typedef enum : NSUInteger {
    
    OVInfoLabelNamePhoneNumber  = 0,
    OVInfoLabelNameCountry      = 1,
    OVInfoLabelNameHometown     = 2,
    OVInfoLabelNameTwitter      = 3,
    OVInfoLabelNameSite         = 4,
    OVInfoLabelNameAbout        = 5,
    OVInfoLabelNameInterests    = 6,
    OVInfoLabelNameActivities   = 7,
    OVInfoLabelNameMusic        = 8,
    OVInfoLabelNameMovies       = 9,
    OVInfoLabelNameTV           = 10,
    OVInfoLabelNameBooks        = 11,
    OVInfoLabelNameQuotes       = 12
    
} OVInfoLabelName;

@implementation OVUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.title = self.user.firstName;
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    self.userNameLabel.hidden = NO;
    
    self.rowsTagsToShow = [NSMutableArray array];
    
    self.followersButton.enabled = NO;
    self.subscriptionsButton.enabled = NO;
    self.wallButton.enabled = NO;
    
    [self getUserInfoFromServer];
}

#pragma mark - Actions

- (IBAction)actionFollowers:(UIButton *)sender {
    
    OVFollowersTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersController"];
    vc.user = self.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionSubscriptions:(UIButton *)sender {
    
    OVSubscriptionsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionsController"];
    vc.user = self.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionWall:(UIButton *)sender {
    
    OVWallTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WallController"];
    vc.user = self.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - API

- (void)getUserInfoFromServer {
    
    [[OVServerManager sharedManager]
     getUserInfoWithID:self.user.userId
     onSuccess:^(OVUser *user) {
         
         NSString *onlineString = nil;
         
         if (user.isOnline) {
             onlineString = @"Online";
             self.userOnlineLabel.textColor = [UIColor greenColor];

         } else {
             onlineString = [NSString stringWithFormat:@"Last seen %ld day(s) ago", user.lastSeen];
         }
         
         self.user.isOnline = user.isOnline;
         
         NSString *cityAndAgeString = @"";
         
         if (user.city) {
             cityAndAgeString = user.city;
         }

         if (cityAndAgeString && user.age) {
             cityAndAgeString = [cityAndAgeString stringByAppendingString:@", "];
         }
         
         if (user.age) {
             NSString *age = [NSString stringWithFormat:@"%ld", user.age];
             cityAndAgeString = [cityAndAgeString stringByAppendingString:age];
         }
                  
         self.user = user;
         
         self.userCityAndAgeLabel.text = cityAndAgeString;
         self.userOnlineLabel.text = onlineString;
         self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followersCount];
         
         self.userOnlineLabel.hidden = NO;
         self.userCityAndAgeLabel.hidden = NO;
                  
         NSURLRequest *request = [NSURLRequest requestWithURL:self.user.imageOrigURL];
         
         __weak UIImageView *weakImageView = self.userImageView;
         
         [self.userImageView
          setImageWithURLRequest:request
          placeholderImage:nil
          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
              
              [self.indicatorView stopAnimating];
              weakImageView.image = image;
              [weakImageView layoutSubviews];
              
          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
              
          }];
         
         for (UILabel *label in self.detailInfoLabels) {
             
             switch (label.tag) {
                     
                 case OVInfoLabelNameAbout:
                     
                     if ([self.user.about length] > 0) {
                         
                         label.text = self.user.about;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }
                     
                     break;
                     
                 case OVInfoLabelNameActivities:
                     
                     if ([self.user.activities length] > 0) {
                         
                         label.text = self.user.activities;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameBooks:
                     
                     if ([self.user.books length] > 0) {
                         
                         label.text = self.user.books;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameCountry:
                     
                     if ([self.user.country length] > 0) {
                         
                         label.text = self.user.country;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameHometown:

                     if ([self.user.homeTown length] > 0) {
                         
                         label.text = self.user.homeTown;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }
                     
                     break;
                     
                 case OVInfoLabelNameInterests:
                     
                     if ([self.user.interests length] > 0) {
                         
                         label.text = self.user.interests;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameMovies:
                     
                     if ([self.user.movies length] > 0) {
                         
                         label.text = self.user.movies;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameMusic:
                     
                     if ([self.user.music length] > 0) {
                         
                         label.text = self.user.music;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNamePhoneNumber:
                     
                     if ([self.user.phoneNumber length] > 0) {
                         
                         label.text = self.user.phoneNumber;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameQuotes:
                     
                     if ([self.user.quotes length] > 0) {
                         
                         label.text = self.user.quotes;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameSite:
                     
                     if ([self.user.site length] > 0) {
                         
                         label.text = self.user.site;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameTV:
                     
                     if ([self.user.tv length] > 0) {
                         
                         label.text = self.user.tv;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
                     
                 case OVInfoLabelNameTwitter:
                     
                     if ([self.user.twitterId length] > 0) {
                         
                         label.text = self.user.twitterId;
                         [self.rowsTagsToShow addObject:@(label.tag)];
                     }

                     break;
 
                 default:
                     break;
             }
         }
         
         [self.tableView beginUpdates];
         [self.tableView endUpdates];
         
         self.followersButton.enabled = YES;
         self.subscriptionsButton.enabled = YES;
         self.wallButton.enabled = YES;
         
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@", [error localizedDescription]);
     }];
    
    NSLog(@"%@", self.user);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == OVSectionNameFriendInfo) {
        return @"Friend Info";
        
    } else if (section == OVSectionNameExplore) {
        return @"Explore";
        
    } else if (section == OVSectionNameSelfStory && [self.rowsTagsToShow count] > 0) {
        return @"Self Story";
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == OVSectionNameSelfStory) {
        
        if ([self.rowsTagsToShow containsObject:@(indexPath.row)]) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UILabel *label = (UILabel *)[self.view viewWithTag:indexPath.row];
            
            if (CGRectGetHeight(cell.bounds) < CGRectGetHeight(label.bounds)) {
                
                return CGRectGetHeight(label.bounds);

            }
            
        } else {
            
            return 0;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
