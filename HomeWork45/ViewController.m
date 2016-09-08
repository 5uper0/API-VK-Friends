//
//  ViewController.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "ViewController.h"
#import "OVServerManager.h"
#import "OVUser.h"
#import "OVUserInfoTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (assign, nonatomic) BOOL isDownloading;

@end

@implementation ViewController

static NSInteger friendsInRequest = 20;
static NSInteger contentBottomInset = 70;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.friendsArray = [NSMutableArray array];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, contentBottomInset, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)getFriendsFromServer {
    
    NSLog(@"isDownloading = YES");
    
    self.isDownloading = YES;
        
    [[OVServerManager sharedManager]
     getFriendsWithOffset:[self.friendsArray count]
     count:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         
         NSMutableArray *newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.friendsArray count] - (int)[friends count];
              i < [self.friendsArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
         }
         
         [self.tableView.layer removeAllAnimations];
         
         [self.tableView beginUpdates];
         [self.tableView
          insertRowsAtIndexPaths:newPaths
          withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
         self.isDownloading = NO;
         
         NSLog(@"isDownloading = NO");
         
         [self simpleAnimate];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
                  
         [self.view.layer removeAllAnimations];
         
         [self showErrorMessage:error];
     }];
}

#pragma mark - Animation

- (void)simpleAnimate {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
    bluredView.frame = CGRectMake(CGRectGetMinX(self.tableView.bounds), CGRectGetMaxY(self.tableView.bounds), CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds) / 2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:bluredView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"HomeWork 45 API OV © 2016";
    
    [bluredView addSubview:label];
    
    [self.view addSubview:bluredView];
    
    [UIView animateWithDuration:3.5f
                          delay:0.4f
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         bluredView.frame = self.tableView.bounds;
                         
                     } completion:^(BOOL finished) {
                         
                         bluredView.hidden = YES;
                     }];
}

- (void)animateCell:(UITableViewCell *)cell {
    
    NSLog(@"ANIMATING");
    
    [self.tableView.layer removeAllAnimations];

    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         
                         cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             NSLog(@"ANIMATING FINIShED");
                             cell.backgroundColor = [UIColor whiteColor];
                             
                         }
                     }];

}

#pragma mark - Private Methods

- (void)showErrorMessage:(NSError *)error {
    
    [self.tableView.layer removeAllAnimations];
    
    CGRect labelRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) / 2, 80);
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:labelRect];
    
    errorLabel.center = self.view.center;
    errorLabel.numberOfLines = 4;
    errorLabel.text = [error localizedDescription];
    errorLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    [errorLabel sizeToFit];
    [self.view addSubview:errorLabel];
    [self.view bringSubviewToFront:errorLabel];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.friendsArray count]) {
        
        static NSString *loadIdentifier = @"LoadCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:loadIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        
    } else {
        
        static NSString *userIdentifier = @"UserCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:userIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        OVUser *friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:friend.imageURL];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OVUserInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoController"];
    vc.user = [self.friendsArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.friendsArray count]) {
        
        NSLog(@"willDisplayCell");
        
        if (!self.isDownloading) {
            
            [self animateCell:cell];
            [self getFriendsFromServer];
            [self.tableView layoutSubviews];
            
        } else {
            
            [self animateCell:cell];

        }
        
    }
        
}

@end