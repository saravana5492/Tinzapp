
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "MatchesViewController.h"
#import "MainViewController.h"
#import "ChatListViewController.h"
#import "allChatListViewController.h"
#import "UserDetails.h"
#import "HelpDesk.h"
#import "ProfileOneViewController.h"
#import "SplashViewController.h"
#import "ConnectFacebookViewController.h"
#import "ProfileTwoViewController.h"
#import "MyIconDownloader.h"
#import "NetworkManager.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"





@interface RearViewController()
{
    NSInteger _presentedRow;
    NSArray *menuImg;
    NSArray *menuName;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation RearViewController



#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    menuImg = @[@"", @"", @"", @"", @"", @""];
    menuName = @[@"one", @"two", @"three", @"four", @"five", @"six"];
    
    _rearCollectView.scrollEnabled = NO;
    
   self.scrollView.contentSize = CGSizeMake(1, 100);
    
    _logoutView.layer.cornerRadius = 5.0f;

    
    //self.title = NSLocalizedString(@"Rear View", nil);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return menuName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:11];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:12];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    } else if (indexPath.row == 2) {
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:13];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    } else if (indexPath.row == 3) {
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:14];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    } else if (indexPath.row == 4) {
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:15];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    } else {
        NSString *cellIdentifier = [menuName objectAtIndex:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIImageView *menuImageView = (UIImageView*)[cell viewWithTag:16];
        
        menuImageView.image = [menuImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [menuImageView setTintColor:[UIColor redColor]];
        
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth = 1.0f;
        
        return cell;
        
    }
    
    
    //return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.rearCollectView.frame.size.width - 20) / 2, 100.0f);
}


#pragma mark -  <UICollectionViewDelegateFlowLayout>
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}



- (IBAction)logoutAction:(id)sender {
    
    NSLog(@"Log Out button clicked!!");

    //NSLog(@"parent = %@ and parent's parent = %@",[(UINavigationController *)[self parentViewController] viewControllers], self.parentViewController.presentingViewController);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"email"];
    [defaults setObject:@"" forKey:@"fb_id"];
    [defaults synchronize];
    
    [[OnDeck sharedInstance] clearOnDeck];
    if ([[self.parentViewController.presentingViewController class] isEqual:[SplashViewController class]]) {
        
        NSLog(@"First One!!");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logged Out succesfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            SplashViewController *splash = (SplashViewController *)self.parentViewController.presentingViewController;
            [[UserDetails sharedInstance] clearUserDetails];
            [self.parentViewController dismissViewControllerAnimated:NO completion:^{
                
                ConnectFacebookViewController *connect = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectFacebookViewController"];
                [splash presentViewController:connect animated:NO completion:nil];
            }];

        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
     }
    else if ([[self.parentViewController.presentingViewController class] isEqual:[ConnectFacebookViewController class]])
    {
        
        NSLog(@"Second One!!");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logged Out succesfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // UINavigationController *splash = (UINavigationController *)self.parentViewController;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"email"];
            [defaults setObject:@"" forKey:@"fb_id"];
            [defaults synchronize];
            [[UserDetails sharedInstance] clearUserDetails];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            SplashViewController *splash = (SplashViewController *)self.parentViewController.presentingViewController;
            [[UserDetails sharedInstance] clearUserDetails];
            [self.parentViewController dismissViewControllerAnimated:NO completion:^{
                
                ConnectFacebookViewController *connect = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectFacebookViewController"];
                [splash presentViewController:connect animated:NO completion:nil];
            }];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        
        NSLog(@"Third One!!");
        
        UINavigationController *splash = (UINavigationController *)self.parentViewController.presentingViewController;
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            
            [splash dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
}


@end