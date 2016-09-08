//
//  OVFollowersTableViewController.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "OVFollowersTableViewController.h"
#import "OVUserInfoTableViewController.h"
#import "OVServerManager.h"
#import "OVUser.h"

@interface OVFollowersTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *followersArray;
@property (assign, nonatomic) BOOL isDownloading;

@end

@implementation OVFollowersTableViewController

static NSInteger followersInRequest = 20;
static NSInteger contentBottomInset = 70;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld Followers", self.user.followersCount];
    self.navigationItem.backBarButtonItem.title = self.user.firstName;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, contentBottomInset, 0);
    
    self.followersArray = [NSMutableArray array];
    
    [self getFollowersFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionBack:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API

- (void)getFollowersFromServer {
    
    NSLog(@"isDownloading = YES");
    
    self.isDownloading = YES;

    [[OVServerManager sharedManager]
     getFollowersWithUserID:self.user.userId
     count:followersInRequest
     offset:[self.followersArray count]
     onSuccess:^(NSArray *followers) {
         
         [self.followersArray addObjectsFromArray:followers];
         
         NSMutableArray *newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.followersArray count] - (int)[followers count]; i < [self.followersArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
         [self.tableView.layer removeAllAnimations];
         
         NSLog(@"isDownloading = NO");
         
         self.isDownloading = NO;


     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
}

#pragma mark - Animation

- (void)animateCell:(UITableViewCell *)cell {
    
    [self.tableView.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         
                         cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             NSLog(@"FINIShED");
                             cell.backgroundColor = [UIColor whiteColor];
                         }
                     }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.followersArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.followersArray count]) {
        
        static NSString *loadIdentifier = @"LoadCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:loadIdentifier];
 
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];

        }
        
    } else {

        static NSString *identifier = @"FollowerCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            
        }
        
        OVUser *follower = [self.followersArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", follower.firstName, follower.lastName];
        [cell.imageView.layer setMasksToBounds:YES];
        [cell.imageView.layer setCornerRadius:cell.contentView.frame.size.height / 2];

        NSURLRequest *request = [NSURLRequest requestWithURL:follower.imageURL];
        
        __weak UITableViewCell *weakCell = cell;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:[UIImage imageNamed:@"user_male4_32px"]
         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             
             weakCell.imageView.image = image;
             [weakCell layoutSubviews];
             
         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             
         }];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OVUserInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoController"];
    vc.user = [self.followersArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
*/

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.followersArray count]) {
        
        if (!self.isDownloading) {
            [self animateCell:cell];
            [self getFollowersFromServer];
            
            NSLog(@"LOADING");

        } else {
            
            [tableView.layer removeAllAnimations];
            [self animateCell:cell];

        }
        
    }
}

@end
