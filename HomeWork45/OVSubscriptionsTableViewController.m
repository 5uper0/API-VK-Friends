//
//  OVSubscriptionsTableViewController.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "OVUserInfoTableViewController.h"
#import "OVServerManager.h"
#import "OVSubscriptionsTableViewController.h"
#import "OVSubscription.h"
#import "OVUser.h"

@interface OVSubscriptionsTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *subscriptionsArray;
@property (assign, nonatomic) BOOL isDownloading;

@end

@implementation OVSubscriptionsTableViewController

static NSInteger subscriptionsInRequest = 20;
static NSInteger contentBottomInset = 70;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscriptionsArray = [NSMutableArray array];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, contentBottomInset, 0);
    
    [self getSubscriptionsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)getSubscriptionsFromServer {
    
    NSLog(@"isDownloading = YES");
    
    self.isDownloading = YES;

    [[OVServerManager sharedManager]
     getSubscriptionsWithUserID:self.user.userId
     count:subscriptionsInRequest
     offset:[self.subscriptionsArray count]
     onSuccess:^(NSArray *subscriptions) {
         
         [self.subscriptionsArray addObjectsFromArray:subscriptions];
         
         NSMutableArray *newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.subscriptionsArray count] - (int)[subscriptions count]; i < [self.subscriptionsArray count]; i++) {
             
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
                         
                         cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             NSLog(@"FINIShED");
                             cell.backgroundColor = [UIColor whiteColor];
                         }
                     }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.subscriptionsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.subscriptionsArray count]) {
        
        static NSString *loadIdentifier = @"LoadCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:loadIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
           
        }
        
    } else {

    
        static NSString *identifier = @"SubscriptionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];

        }
        
        OVSubscription *subscription = [self.subscriptionsArray objectAtIndex:indexPath.row];
        
        if (subscription.pageType == OVSubscriptionTypeUser) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", subscription.firstName, subscription.lastName];
            
        } else {
            
            cell.textLabel.text = subscription.screenName;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:subscription.imageURL];
        
        cell.imageView.image = nil;
        
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
     vc.user = [self.subscriptionsArray objectAtIndex:indexPath.row];
 
     [self.navigationController pushViewController:vc animated:YES];
 
}
*/

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.subscriptionsArray count] && !self.isDownloading) {
        
        [self animateCell:cell];
        [self getSubscriptionsFromServer];
        
        NSLog(@"LOADING");

    }
}

@end
