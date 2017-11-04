//
//  ReportViewController.m
//  Twozapp
//
//  Created by Dipin on 17/03/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ReportViewController.h"
#import "NetworkManager.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"

@interface ReportViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *hudProgress;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomsend;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    _btnSend.layer.cornerRadius = 15.0f;
    _txtView.layer.cornerRadius = 10.0f;
    _txtView.placeholder = @"Please Enter Something";
    _lblCount.text = @"0/250";
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
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudProgress.delegate = self;
        
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        hudProgress.labelText = @"Loading";
        hudProgress.dimBackground = YES;
        [self sendReportAbuse];
    }
    else
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Please enter some message"];
    }
    
}

- (void)sendReportAbuse
{
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/reportabuse.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@&msg=%@",[defaults stringForKey:@"fb_id"],_selectedFriend.frd_fb_Id,_txtView.text];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"report result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                  [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"You have successfully reported to the admin."];
                    [self performSelector:@selector(actionDismiss) withObject:nil afterDelay:0.5];
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
         _bottomsend.constant =  70;
         [self.view needsUpdateConstraints];
         
     } completion:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification
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
         
         _bottomsend.constant = keyboardFrameBeginRect.size.height - 60;
         [self.view needsUpdateConstraints];
         
     } completion:nil];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

@end
