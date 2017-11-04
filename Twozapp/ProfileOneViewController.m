//
//  ProfileOneViewController.m
//  Twozapp
//
//  Created by Priya on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ProfileOneViewController.h"
#import "OnDeck.h"
#import "SlideAlertiOS7.h"
#import "AppDelegate.h"
#import "UserDetails.h"
#import "ProfileTwoViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface ProfileOneViewController ()<MBProgressHUDDelegate>
{
    NSArray *arrTime;
    NSArray *arrMonth;
    NSString *currentYear;
    MBProgressHUD *hudProgress;
    BOOL isBirthTimeNeeded;
    NSString *strBirthTime;
    float resety;
    BOOL lookingforFemale;
    BOOL lookingforMale;
    CGFloat animatedDistance;
    
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) IBOutlet UILabel *heightLbl;

@property (weak, nonatomic) IBOutlet UIView *viewTime;
- (IBAction)actionNoBirthTime:(id)sender;
@end

@implementation ProfileOneViewController
@synthesize actionType;
@synthesize clockView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSLog(@"User Country check: %@", [locale objectForKey: NSLocaleCountryCode]);
    
    if([[locale objectForKey: NSLocaleCountryCode] isEqualToString:@"IN"]){
        _heightLbl.text = @"Feet";
    } else {
        _heightLbl.text = @"cm";
    }
    
    
    [self.tblTime setValue:[UIColor redColor] forKeyPath:@"textColor"];
    
    self.txtHeight.delegate = self;
    self.txtWeight.delegate = self;
    
    _btnnext.layer.cornerRadius = 10.0f;
    self.navigationController.navigationBar.translucent = NO;
   
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    //[self.view addGestureRecognizer:tap];
    
    _txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    
    if ([actionType isEqualToString:@"edit"]) {
        
        self.navigationController.navigationBar.translucent = NO;
        
        _txtName.text = [UserDetails sharedInstance].full_name;
        _txtHeight.text = [UserDetails sharedInstance].height;
        _txtWeight.text = [UserDetails sharedInstance].weight;
        _txtEmail.text = [UserDetails sharedInstance].email;
        _txtEmail.userInteractionEnabled = false;
        resety = 0;
        NSString *strBirthDay = [UserDetails sharedInstance].dob;

        self.navigationItem.titleView.hidden = YES;
        //self.navigationController.navigationBar.topItem.title = @"";
        
        _backBtn.hidden = NO;
        //_btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y, 30, 30);
        //[_btnBack setBackgroundImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
        
        //[_btnBack setTitle:@"Profile" forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dob = [formatter dateFromString:strBirthDay];
        
        NSDateFormatter  *newformatter = [[NSDateFormatter alloc] init];
        [newformatter setDateFormat:@"dd-MMM-yyyy"];
        

        [OnDeck sharedInstance].strBirthday = [newformatter stringFromDate:dob];
        NSArray *arrdob = [[OnDeck sharedInstance].strBirthday componentsSeparatedByString:@"-"];
        _txtYear.text = arrdob[2];
        _txtMonth.text = arrdob[1]; 
        _txtDay.text = arrdob[0];
        [OnDeck sharedInstance].strGender = [UserDetails sharedInstance].gender;
        if ([[UserDetails sharedInstance].lookingfor isEqualToString:@"1"]) {
            lookingforMale = YES;
            _imgLMale.image = [UIImage imageNamed:@"tinzCheck"];
            _imgLFemale.image = [UIImage imageNamed:@"tinzUncheck"];
        }
        else if ([[UserDetails sharedInstance].lookingfor isEqualToString:@"2"])
        {
            lookingforFemale = YES;
            _imgLMale.image = [UIImage imageNamed:@"tinzUncheck"];
            _imgLFemale.image = [UIImage imageNamed:@"tinzCheck"];
            
        }
        else if ([[UserDetails sharedInstance].lookingfor isEqualToString:@"3"])
        {
            lookingforMale = YES;
            lookingforFemale = YES;
            _imgLMale.image = [UIImage imageNamed:@"tinzCheck"];
            _imgLFemale.image = [UIImage imageNamed:@"tinzCheck"];
        }
        [OnDeck sharedInstance].strLookingfor = [UserDetails sharedInstance].lookingfor;
        
        if ([[OnDeck sharedInstance].strGender isEqualToString:@"1"]) {
            _imgGMale.image = [UIImage imageNamed:@"tinzCheck"];
        }
        else
        {
            _imgGfemale.image = [UIImage imageNamed:@"tinzCheck"];
        }
        
        
        if ([[UserDetails sharedInstance].birthtime isEqualToString:@"(null)"]) {
            _lblBirthday.text = @"";
        }
        else if ([[UserDetails sharedInstance].birthtime isEqualToString:@"-- --"]) {
            _lblBirthday.text = @"-- --";
        }
        else
        {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *time = [timeFormatter dateFromString:[UserDetails sharedInstance].birthtime];
        
        NSDateFormatter *newtimeFormatter = [[NSDateFormatter alloc] init];
        [newtimeFormatter setDateFormat:@"hh:mm a"];
        
        NSString *birthTime = [newtimeFormatter stringFromDate:time];
        
        _lblBirthday.text = [NSString stringWithFormat:@"%@",birthTime];
        strBirthTime = [NSString stringWithFormat:@"%@",birthTime];
        }
        [self actionBlackBox];
    }
   else
    {
        self.navigationItem.titleView.hidden = YES;
        _backBtn.hidden = YES;

        //_btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y, 102, 24);
        //[_btnBack setTitle:@"PROFILE" forState:UIControlStateNormal];

        //[_btnBack setBackgroundImage:[UIImage imageNamed:@"GrabDate_title"] forState:UIControlStateNormal];
        //self.navigationItem.leftBarButtonItem.title = @"Back";
      
        resety = 0;
    }
    
    
    [OnDeck sharedInstance].strName = _txtName.text;
    [OnDeck sharedInstance].strEmail = _txtEmail.text;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    currentYear = [formatter1 stringFromDate:[NSDate date]];
    [OnDeck sharedInstance].strBirthday = [NSString stringWithFormat:@"%@-%@-%@",_txtDay.text, _txtMonth.text,_txtYear.text];

    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:238/255.0 green:52/255.0 blue:85/255.0 alpha:1.0f]];
    //self.navigationController.navigationBar.translucent = NO;
    
    [_rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:20], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    
    arrTime = @[@"12:00am - 01:00am", @"01:00am - 02:00am", @"02:00am - 03:00am", @"03:00am - 04:00am", @"04:00am - 05:00am", @"05:00am - 06:00am", @"06:00am - 07:00am", @"07:00am - 08:00am", @"08:00am - 09:00am", @"09:00am - 10:00am", @"10:00am - 11:00am", @"11:00am - 12:00pm", @"12:00pm - 01:00pm", @"01:00pm - 02:00pm", @"02:00pm - 03:00pm", @"03:00pm - 04:00pm", @"04:00pm - 05:00pm", @"05:00pm - 06:00pm", @"06:00pm - 07:00pm", @"07:00pm - 08:00pm", @"08:00pm - 09:00pm", @"09:00pm - 10:00pm", @"10:00pm - 11:00pm", @"11:00pm - 12:00am"];
    
    arrMonth = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    _tblday.hidden = YES;
    _viewTime.hidden = YES;
    //_viewPickerBackground.hidden = _tblTime.hidden;
    _tblMonth.hidden = YES;
    _tblYear.hidden = YES;
    
    _tblday.layer.borderWidth = 1.0f;
    _tblday.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _tblday.layer.cornerRadius = 5.0f;
    
//    _tblTime.layer.borderWidth = 1.0f;
//    _tblTime.layer.borderColor = [UIColor redColor].CGColor;
//    _tblTime.layer.cornerRadius = 5.0f;
    _viewPickerBackground.layer.borderWidth = 1.0f;
    _viewPickerBackground.layer.borderColor = [UIColor redColor].CGColor;
    _viewPickerBackground.layer.cornerRadius = 5.0f;
    
    
    UIColor *color = [UIColor colorWithRed:238/255.0 green:199/255.0 blue:206/255.0 alpha:1.0f];
    _txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Name" attributes:@{NSForegroundColorAttributeName: color}];
    _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Email" attributes:@{NSForegroundColorAttributeName: color}];
    _txtHeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Height" attributes:@{NSForegroundColorAttributeName: color}];
    _txtWeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Weight" attributes:@{NSForegroundColorAttributeName: color}];
    _txtDay.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Date" attributes:@{NSForegroundColorAttributeName: color}];
    _txtMonth.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Month" attributes:@{NSForegroundColorAttributeName: color}];
    _txtYear.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Year" attributes:@{NSForegroundColorAttributeName: color}];
    
    _tblMonth.layer.borderWidth = 1.0f;
    _tblMonth.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _tblMonth.layer.cornerRadius = 5.0f;
    
    _tblYear.layer.borderWidth = 1.0f;
    _tblYear.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _tblYear.layer.cornerRadius = 5.0f;
    
    
    _txtEmail.layer.cornerRadius = 5.0f;
    _txtEmail.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _txtEmail.layer.borderWidth = 1.0f;
    
    _txtName.layer.cornerRadius = 5.0f;
    _txtName.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _txtName.layer.borderWidth = 1.0f;
    
    _textHeightView.layer.cornerRadius = 5.0f;
    _textHeightView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _textHeightView.layer.borderWidth = 1.0f;
    
    _txtWeightView.layer.cornerRadius = 5.0f;
    _txtWeightView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _txtWeightView.layer.borderWidth = 1.0f;
    
    _nextBtnView.layer.cornerRadius = 5.0f;
    _nextBtnView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _nextBtnView.layer.borderWidth = 1.0f;

    _dayView.layer.cornerRadius = 5.0f;
    _dayView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _dayView.layer.borderWidth = 1.0f;

    
    _monthView.layer.cornerRadius = 5.0f;
    _monthView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _monthView.layer.borderWidth = 1.0f;

    
    _yearView.layer.cornerRadius = 5.0f;
    _yearView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
    _yearView.layer.borderWidth = 1.0f;
    
}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


/*-(void)hideKeyBoard {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];
}*/


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Show the top navigation bar.
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        
        [_txtName resignFirstResponder];
        [_txtEmail resignFirstResponder];
        [_txtWeight resignFirstResponder];
        [_txtHeight resignFirstResponder];
        
        _tblYear.hidden = YES;
        _viewTime.hidden = YES;
        _viewPickerBackground.hidden = _viewTime.hidden;
        _tblday.hidden = YES;
        _tblMonth.hidden = YES;
    }*/
    [[self view] endEditing:true];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtName)
    {
        [_txtName resignFirstResponder];
    }
    if (textField == _txtWeight) {
        [_txtWeight resignFirstResponder];
    }
    if (textField == _txtHeight) {
        [_txtHeight resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _txtEmail){
        [_txtName resignFirstResponder];
        [_txtEmail resignFirstResponder];
        [_txtWeight resignFirstResponder];
        [_txtHeight resignFirstResponder];

    }
    _tblMonth.hidden = YES;
    _tblYear.hidden = YES;
    _tblday.hidden = YES;
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == _txtHeight || textField == _txtWeight) {
        
        
        
    }
    
    return YES;
}

/*
- (void)keyboardDidShow:(NSNotification *)notification
{
    
    
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
     } completion:nil];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
    [self.view setFrame:CGRectMake(0,resety,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
         } completion:nil];
}

*/


- (IBAction)actionNext:(id)sender{
    NSLog(@"One date = %@",[OnDeck sharedInstance].strBirthday);
    if (_txtName.text.length == 0) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please enter your Name"];
        return;
    }
    else if ([OnDeck sharedInstance].strGender.length == 0)
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please select your Gender"];
        return;
    }
    else if (_txtDay.text.length == 0 || _txtMonth.text.length == 0 ||_txtYear.text.length == 0)
    {
      [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please enter your Birthday"];
        return;
    }
    
    else if (lookingforFemale == NO && lookingforMale == NO)
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please select who you are looking for"];
        return;
    }
    
//else if (isBirthTimeNeeded == YES && (strBirthTime.length == 0 || [_lblBirthday.text isEqualToString:@"-- --"]))
//{
//    [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please select your Birth Time"];
//    return;
//}
    else
    {
        
        if (lookingforMale && lookingforFemale) {
           [OnDeck sharedInstance].strLookingfor = @"3"
            ;        }
        else if (lookingforMale && lookingforFemale == NO)
        {
            [OnDeck sharedInstance].strLookingfor = @"1";
        }
        else if (lookingforFemale && lookingforMale == NO)
        {
            [OnDeck sharedInstance].strLookingfor = @"2";
        }
    [OnDeck sharedInstance].strName = _txtName.text;
    [OnDeck sharedInstance].strEmail = _txtEmail.text;
    [OnDeck sharedInstance].strBirthday = [NSString stringWithFormat:@"%@-%@-%@",_txtDay.text, _txtMonth.text,_txtYear.text];
        if (![_lblBirthday.text isEqualToString:@"-- --"]) {
            [OnDeck sharedInstance].strBirthtime = _lblBirthday.text;
        }
    
    [OnDeck sharedInstance].strHeight = _txtHeight.text;
    [OnDeck sharedInstance].strWeight = _txtWeight.text;
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ProfileTwoViewController *profileTwo = (ProfileTwoViewController *)[story instantiateViewControllerWithIdentifier:@"ProfileTwoViewController"];
//        profileTwo.actionType = actionType;
//    [self.navigationController pushViewController:profileTwo animated:YES];
        [self performSegueWithIdentifier:@"toprofiletwo" sender:actionType];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toprofiletwo"]) {
        ProfileTwoViewController *prfile = (ProfileTwoViewController *)segue.destinationViewController;
        prfile.actionType = sender;
    }
}

- (IBAction)actionDay:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    _tblMonth.hidden = YES;
    _tblYear.hidden = YES;
    _viewTime.hidden = YES;
   // _viewPickerBackground.hidden = _tblTime.hidden;
    _tblday.hidden = !_tblday.hidden;
    [_tblday reloadData];
   /*[UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];*/
    
}

/*- (IBAction)actionBack:(id)sender {
    
    if ([actionType isEqualToString:@"edit"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}*/

- (IBAction)actionTime:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    _tblMonth.hidden = YES;
    _tblYear.hidden = YES;
    _tblday.hidden = YES;
    _viewTime.hidden = !_viewTime.hidden;
    //_viewPickerBackground.hidden = _tblTime.hidden;
    if (strBirthTime.length == 0) {
        strBirthTime = arrTime[0];
    }
    
   /* [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];*/
    //[self showClockView];
    
}



- (void)actionBlackBox
{
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_new_webservices/blackbox.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[OnDeck sharedInstance].strBirthday];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"blackboxdate=%@",[newFormatter stringFromDate:birthDate]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        if(error) {
            NSLog(@"error : %@", [error description]);
            [self hudWasHidden:hudProgress];
        } else {
            // This is the expected result
            NSLog(@"Blackbox result : %@", result);
            dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result.count >0) {
                if ([result[@"status"]  isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    isBirthTimeNeeded = NO;
                    _lblBirthTIME.text = @"Birth Time:";
                }
                else
                {
                    isBirthTimeNeeded = YES;
                    _lblBirthTIME.text = @"Birth Time*:";
                }
                
                          
            }
            else
            {
                [self hudWasHidden:hudProgress];
            }
                });
        }
    }];
}

- (IBAction)actionMonth:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    _tblMonth.hidden = !_tblMonth.hidden;
    _tblYear.hidden = YES;
    _viewTime.hidden = YES;
    //_viewPickerBackground.hidden = _tblTime.hidden;
    _tblday.hidden = YES;
    [_tblday reloadData];
   /* [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];*/
}

- (IBAction)actionyear:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    
    _tblMonth.hidden = YES;
    _tblYear.hidden = !_tblYear.hidden;
    _viewTime.hidden = YES;
    //_viewPickerBackground.hidden = _tblTime.hidden;
    _tblday.hidden = YES;
    [_tblday reloadData];
    /*[UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil]; */
}

- (IBAction)actionDatePicker:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    UIDatePicker *picker  = (UIDatePicker *)sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    _lblBirthday.text = [formatter stringFromDate:picker.date];
    strBirthTime = [formatter stringFromDate:picker.date];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (tableView == _tblMonth)
    {
        return arrMonth.count;
    }
    else if (tableView == _tblYear)
    {
        return 100;
    }
    else
    {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        // Set your year and month here
        [components setYear:_txtYear.text.integerValue];
        [components setMonth:[arrMonth indexOfObject:_txtMonth.text] + 1];
        
        NSDate *date = [calendar dateFromComponents:components];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        
        NSLog(@"%d", (int)range.length);
        
        
//        NSString *strDate = [NSString stringWithFormat:@"03/%@/%@",_txtMonth.text,_txtYear.text];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd/MMM/YYYY"];
//        NSDate *selDate = [dateFormatter dateFromString:strDate];
//        NSCalendar *c = [NSCalendar currentCalendar];
//        NSRange days = [c rangeOfUnit:NSDayCalendarUnit
//                               inUnit:NSMonthCalendarUnit
//                              forDate:selDate];
        
//        NSLog(@"days = %lu",(unsigned long)days.length);
        
        
    return (int)range.length;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (tableView == _tblMonth)
    {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            UILabel *lbl = (UILabel *)[cell viewWithTag:10];
            lbl.text = [NSString stringWithFormat:@"%@",arrMonth[indexPath.row]];
        
            return cell;
    }
    else if (tableView == _tblYear)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        UILabel *lbl = (UILabel *)[cell viewWithTag:10];
        lbl.text = [NSString stringWithFormat:@"%ld", currentYear.intValue - (long)indexPath.row];
        
        return cell;
    }
    else
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lbl = (UILabel *)[cell viewWithTag:10];
    lbl.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _tblMonth){
        _txtMonth.text = [NSString stringWithFormat:@"%@",arrMonth[indexPath.row]];
        [_tblday reloadData];
        _tblMonth.hidden = YES;
        [OnDeck sharedInstance].strBirthday = [NSString stringWithFormat:@"%@-%@-%@",_txtDay.text, _txtMonth.text,_txtYear.text];
        [self actionBlackBox];
        
    }else if (tableView == _tblYear){
        _txtYear.text = [NSString stringWithFormat:@"%ld", currentYear.intValue - (long)indexPath.row];
        [_tblday reloadData];
        _tblYear.hidden = YES;
        [OnDeck sharedInstance].strBirthday = [NSString stringWithFormat:@"%@-%@-%@",_txtDay.text, _txtMonth.text,_txtYear.text];
        [self actionBlackBox];
    }
    else if (tableView == _tblday){
        _txtDay.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        _tblday.hidden = YES;
        [OnDeck sharedInstance].strBirthday = [NSString stringWithFormat:@"%@-%@-%@",_txtDay.text, _txtMonth.text,_txtYear.text];
        [self actionBlackBox];
        
    }
}

- (IBAction)actionGMale:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    _imgGMale.image = [UIImage imageNamed:@"tinzCheck"];
    [OnDeck sharedInstance].strGender = @"1";
    
    _imgGfemale.image = [UIImage imageNamed:@"tinzUncheck"];
    /*[UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil]; */
}

- (IBAction)actionGFemale:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

        _imgGfemale.image = [UIImage imageNamed:@"tinzCheck"];
        [OnDeck sharedInstance].strGender = @"2";
    
    _imgGMale.image = [UIImage imageNamed:@"tinzUncheck"];
    /*[UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil]; */
    
}

- (IBAction)actionLMale:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    
    lookingforMale = !lookingforMale;
    if (lookingforMale) {
       _imgLMale.image = [UIImage imageNamed:@"tinzCheck"];
    }
    else
    {
        _imgLMale.image = [UIImage imageNamed:@"tinzUncheck"];
    }
    
        [OnDeck sharedInstance].strLookingfor = @"1";
   
   /* [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];*/
}

- (IBAction)actionLFemale:(id)sender {
    [_txtName resignFirstResponder];
    [_txtHeight resignFirstResponder];
    [_txtWeight resignFirstResponder];

    lookingforFemale = !lookingforFemale;
    if (lookingforFemale) {
        _imgLFemale.image = [UIImage imageNamed:@"tinzCheck"];
    }
    else
    {
        _imgLFemale.image = [UIImage imageNamed:@"tinzUncheck"];
    }
    [OnDeck sharedInstance].strLookingfor = @"2";
    
    /*[UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];*/
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)actionTap
{
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

-(void)showClockView{
    
    clockView = [[CustomTimePicker alloc] initWithView:self.view withDarkTheme:false];
    clockView.delegate = self;
    [self.view addSubview:clockView];
}


-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode{
    
    strBirthTime = [NSString stringWithFormat:@"%@:%@ %@",hours,minutes,timeMode];
    _lblBirthday.text = strBirthTime;
    
}

- (IBAction)actionNoBirthTime:(id)sender {
    _lblBirthday.text = @"-- --";
    strBirthTime = @"-- --";
    _viewTime.hidden = YES;
    [OnDeck sharedInstance].strBirthtime = strBirthTime;
}
@end
