//
//  FeedbackViewController.m
//  Twozapp
//
//  Created by Dipin on 23/03/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "FeedbackViewController.h"
#import "NetworkManager.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"
#import "ContentViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"


@interface FeedbackViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *hudProgress;
}
@end

@implementation FeedbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tap];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    _btnSend.layer.cornerRadius = 15.0f;
    _txtView.layer.cornerRadius = 10.0f;
    _txtView.layer.borderWidth = 1.0f;
    _txtView.tintColor = [UIColor blackColor];
    _txtView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    //UIColor *color = [UIColor colorWithRed:238/255.0 green:199/255.0 blue:206/255.0 alpha:1.0f];
    //_txtView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Name" attributes:@{NSForegroundColorAttributeName: color}];
    _txtView.placeholder = @"Type your valuable feedback";
    _lblCount.text = @"0/500";
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:238/255.0 green:52/255.0 blue:85/255.0 alpha:1.0f]];
    //self.navigationController.navigationBar.translucent = NO;
    
    /*[_rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"Segoe Print" size:20.0], NSFontAttributeName,
                                             [UIColor whiteColor], NSForegroundColorAttributeName,
                                             nil]
                                   forState:UIControlStateNormal];*/

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 500 && ![text isEqualToString:@""]) {
        return NO;
    }
    else
    {
        _lblCount.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)textView.text.length];
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)actionSend:(id)sender {
    
    if (_txtView.text.length > 0) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
        } else {
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudProgress.delegate = self;
        
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        hudProgress.labelText = @"Loading";
        hudProgress.dimBackground = YES;
        //[self performSelector:@selector(sendFeedbackDummy) withObject:nil afterDelay:1.5f];
        [self sendFeedback];
        }
    }
    else
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Please enter some message"];
    }
    
}

- (void)sendFeedbackDummy
{
    [self hudWasHidden:hudProgress];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"revealCont"];
    [self presentViewController:profileTwo animated:YES completion:nil];
    
    
}

- (void)sendFeedback
{
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/sendfeedback.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"emailid=%@&feedback=%@",[defaults stringForKey:@"email"],_txtView.text];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"report result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Thank you for your feedback"];
                    [self performSelector:@selector(sendFeedbackDummy) withObject:nil afterDelay:0.5];
                }
                else
                {
                    [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Sorry we were unable to send your feedback. Please Try again later."];
                }
                
            }
            
        }
        [self hudWasHidden:hudProgress];
    }];
}
- (void)actionDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)actionTap:(UITapGestureRecognizer *)tap
{
    [_txtView resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
             [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
             _bottomSend.constant =  70;
             [self.view needsUpdateConstraints];
         
     } completion:nil];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



/*- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
             [self.view setFrame:CGRectMake(0,-100,self.view.frame.size.width,self.view.frame.size.height)];

             _bottomSend.constant = keyboardFrameBeginRect.size.height - 60;
             [self.view needsUpdateConstraints];
         
     } completion:nil];
}*/

@end
