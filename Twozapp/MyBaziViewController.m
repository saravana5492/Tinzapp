//
//  MyBaziViewController.m
//  Twozapp
//
//  Created by Priya on 21/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "MyBaziViewController.h"
#import "UserDetails.h"
#import "NetworkManager.h"
#import "Reachability.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"
#import "CNPPopupController.h"
#import "OnDeck.h"
#import "ContentViewController.h"
#import "MainViewController.h"
#import "MyIconDownloader.h"

@interface MyBaziViewController ()<CNPPopupControllerDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *hudProgress;
    NSString *boxStatus;
    NSMutableArray *peachesDates;
    NSMutableArray *nobleDates;
    NSDictionary *baziCalander;
    NSString *strDate;
    NSDictionary *dayMaster;
    NSMutableDictionary *imageDownloadsInProgress;
    

    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peachDatesHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nobledtaesheight;
@end

@implementation MyBaziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBoxStatus];
    [self getNobleStar];
    [self getPeachStar];
    nobleDates = [[NSMutableArray alloc] init];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    

    peachesDates = [[NSMutableArray alloc] init];
    baziCalander = @{@"1" : @{@"Chinese symbol" : @"甲", @"Chinese Name" :@"Jia", @"Element" : @"Yang \nWood"}, @"2" : @{@"Chinese symbol" : @"乙", @"Chinese Name" :@"Yi", @"Element" : @"Yin \nWood"}, @"3" : @{@"Chinese symbol" : @"丙", @"Chinese Name" :@"Bing", @"Element" : @"Yang \nFire"}, @"4" : @{@"Chinese symbol" : @"丁", @"Chinese Name" :@"Ding", @"Element" : @"Yang \nFire"}, @"5" : @{@"Chinese symbol" : @"戊", @"Chinese Name" :@"Wu", @"Element" : @"Yang \nEarth"},@"6" : @{@"Chinese symbol" : @"己", @"Chinese Name" :@"Ji", @"Element" : @"Yin \nEarth"}, @"7" : @{@"Chinese symbol" : @"庚", @"Chinese Name" :@"Geng", @"Element" : @"Yang \nMetal"}, @"8" : @{@"Chinese symbol" : @"辛", @"Chinese Name" :@"Xin", @"Element" : @"Yin \nMetal"}, @"9" : @{@"Chinese symbol" : @"壬", @"Chinese Name" :@"Ren", @"Element" : @"Yang \nWater"}, @"10" : @{@"Chinese symbol" : @"癸", @"Chinese Name" :@"Gui", @"Element" : @"Yin \nWater"}, @"11" : @{@"Chinese symbol" : @"子", @"Chinese Name" :@"Zi", @"Element" : @"Yang \nWater", @"Zodiac Animal" : @"Rat"},  @"12" : @{@"Chinese symbol" : @"丑", @"Chinese Name" :@"Chou", @"Element" : @"Yin \nWater", @"Zodiac Animal" : @"Ox"},  @"13" : @{@"Chinese symbol" : @"寅", @"Chinese Name" :@"Yin", @"Zodiac Animal" : @"Tiger", @"Element" : @"Yang \nWood"}, @"14" : @{@"Chinese symbol" : @"卯", @"Chinese Name" :@"Mao", @"Zodiac Animal" : @"Rabbit", @"Element" : @"Yin \nWood"}, @"15" : @{@"Chinese symbol" : @"辰", @"Chinese Name" :@"Chen", @"Zodiac Animal" : @"Dragon", @"Element" : @"Yang \nEarth"}, @"16" : @{@"Chinese symbol" : @"巳", @"Chinese Name" :@"Si", @"Zodiac Animal" : @"Snake", @"Element" : @"Yin \nFire"}, @"17" : @{@"Chinese symbol" : @"午", @"Chinese Name" :@"Wu", @"Zodiac Animal" : @"Horse", @"Element" : @"Yang \nFire"}, @"18" : @{@"Chinese symbol" : @"未", @"Chinese Name" :@"Wei", @"Zodiac Animal" : @"Sheep", @"Element" : @"Yin \nEarth"}, @"19" : @{@"Chinese symbol" : @"申", @"Chinese Name" :@"Shen", @"Zodiac Animal" : @"Monkey", @"Element" : @"Yang \nMetal"}, @"20" : @{@"Chinese symbol" : @"酉", @"Chinese Name" :@"You", @"Zodiac Animal" : @"Rooster", @"Element" : @"Yin \nMetal"}, @"21" : @{@"Chinese symbol" : @"戌", @"Chinese Name" :@"Xu", @"Zodiac Animal" : @"Dog", @"Element" : @"Yang \nEarth"}, @"22" : @{@"Chinese symbol" : @"亥", @"Chinese Name" :@"Hai", @"Zodiac Animal" : @"Pig", @"Element" : @"Yin \nWater"}};
    
    
    dayMaster = @{@"1" : @"甲 Yang Wood is like a Tree. You are upright, tough, unyielding. You are a person of principle and you mean what you say. You are goal orientated and push through aggressively to get what you want. You are kind and honest. On the flip side, you can be stubborn, inflexible and uncompromising. If you find yourself in a stressful situation, explore how you can make the best of the situation with positive outcomes for everyone.", @"2" : @"乙 Yin Wood is like a Flower or Shrub. You are flexible and adjust to your environment easily. In a positive way, you can survive in the toughest times in life. You recover from setbacks easily as you are very resilient. You are also moderate and gentle in nature. You are skilled with your hands, and in artistic work such as crafting objects and playing music. On the flipside, you need to be more confident of yourself." , @"3" : @"丙 Yang Fire is like a Sun. You are warm-hearted, forthright and frank. Your candid and caring nature makes you approachable to others and allows you to make friends easily. On the flip side, you may scare everyone and cause unintentional hurt when you lose your temper. Your outbursts may be short but you will feel sorry after that. Be mindful of your outspoken manner. You have the energy to work hard to achieve your goals." , @"4" : @"丁 Yin Fire is like a Fire Flame. You are warm and gentle. You are sensitive and considerate to others. You take care of people around you. You are polite when meeting new friends at first. On the flip side, you can be too emotional and may tend to bottle up your feelings until you let it all out at once. You tend to worry too much and this can cause undue emotional stress. You are meticulous and like to go into the finer details." , @"5" : @"戊 Yang Earth is like a Mountain. You are grounded, steady and reliable. You can be counted upon and trusted by others. You can be forceful and firm in your ways. You are independent and do not rely on others. You take longer than others to make up your mind. On the flip side, when you finally made your decision, it is not easy to persuade you to think otherwise. Open your mind to see from the other party’s perspective." , @"6" : @"己 Yin Earth is like a Garden. You are resourceful and nurturing. You find joy in giving and helping others. You are charming, relaxed and peaceful. You are kind and intellectual. You like mentally stimulating subjects and enjoy the process of solving problems. You have creative ideas and approach matters with fresh perspectives. On the flip side, you may feel disappointed when your ideas are not taken into consideration." , @"7" : @"庚 Yang Metal is like a Sword. You thrive under pressure and actually enjoy challenges. You have innate masculine leadership qualities. You are brave and have a strong sense of justice. When you set your mind on a goal, you can work aggressively towards it. If you allow yourself to become idle, you will become rusty. You gloss over details. You are at your best when the going gets tough. Most importantly, you must first get going." , @"8" : @"辛 Yin Metal is like Jewelry. You value your appearance and usually are fair of face. You are sensitive in nature and you prefer to be treated with a softer demeanour. You can be charming as it come naturally to you. You possess an imaginative and creative intellect. On the flip side, you can be cold and harsh like a dagger. Learn to control your impulses. Master your ego. Be self-confident and do not take things personally", @"9" : @"壬 Yang Water is like the Ocean. You are energetic, forceful and dynamic. You are determined to achieve your goals. You are enthusiastic and sometimes impulsive. You are full of drive and ideas. You are sociable and like to experience fun stuff. On the flip side, you can be too pushy and have too many ideas at the same time. You see the big picture easily and have brilliant strategies. You are strong and adapt to all situations." , @"10" : @"癸 Yin Water is like Mist. You are moderate, humble and patient. You can accommodate to others and have good people skills. You analyse matters and can make meaningful conclusions easily. You refrain from imposing your will on others. You tend not to voice your opinions unless asked. On the flip side, you tend to worry too much and this may cause undue stress. Be firm and call yourself forth to be recognised and rewarded."};
//    _lblAnimal1.layer.cornerRadius = 10.0;
//    [_lblAnimal1. layer setMasksToBounds:YES];
//    _lblAnimal2.layer.cornerRadius = 10.0;
//    [_lblAnimal2. layer setMasksToBounds:YES];
//    _lblAnimal3.layer.cornerRadius = 10.0;
//    [_lblAnimal3. layer setMasksToBounds:YES];
//    _lblAnimal4.layer.cornerRadius = 10.0;
//    [_lblAnimal4. layer setMasksToBounds:YES];
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 400);
//    
//    _view1.layer.cornerRadius = 7.0;
//    [_view1. layer setMasksToBounds:YES];
//    _view2.layer.cornerRadius = 7.0;
//    [_view2. layer setMasksToBounds:YES];
//    _view3.layer.cornerRadius = 7.0;
//    [_view3. layer setMasksToBounds:YES];
//    _view4.layer.cornerRadius = 7.0;
//    [_view4. layer setMasksToBounds:YES];
//    _view5.layer.cornerRadius = 7.0;
//    [_view5. layer setMasksToBounds:YES];
//    _view6.layer.cornerRadius = 7.0;
//    [_view6. layer setMasksToBounds:YES];
//    _view7.layer.cornerRadius = 7.0;
//    [_view7. layer setMasksToBounds:YES];
//    _view8.layer.cornerRadius = 7.0;
//    [_view8. layer setMasksToBounds:YES];
//    
//    _lblName.text = [UserDetails sharedInstance].full_name;
//    if ([[UserDetails sharedInstance].gender isEqualToString:@"2"])
//         _lblGender.text = @"Female";
//    else
//        _lblGender.text = @"Male";
//    
//    
//    if ([[UserDetails sharedInstance].bazivalue1 isEqualToString:@"0"]) {
//        
//    }
//    else
//    {
//    NSDictionary *bazi1 = baziCalander[[UserDetails sharedInstance].bazivalue1];
//    NSDictionary *bazi2 = baziCalander[[UserDetails sharedInstance].bazivalue2];
//    NSDictionary *bazi3 = baziCalander[[UserDetails sharedInstance].bazivalue3];
//    NSDictionary *bazi4 = baziCalander[[UserDetails sharedInstance].bazivalue4];
//    NSDictionary *bazi5 = baziCalander[[UserDetails sharedInstance].bazivalue5];
//    NSDictionary *bazi6 = baziCalander[[UserDetails sharedInstance].bazivalue6];
//    NSDictionary *bazi7 = baziCalander[[UserDetails sharedInstance].bazivalue7];
//    NSDictionary *bazi8 = baziCalander[[UserDetails sharedInstance].bazivalue8];
//    
//    _lblChineseName1.text = bazi1[@"Element"];
//    _lblChineseSymbol1.text = bazi1[@"Chinese symbol"];
//    
//    _lblChineseName2.text = bazi2[@"Element"];
//    _lblChineseSymbol2.text = bazi2[@"Chinese symbol"];
//        _lblAnimal1.text = bazi2[@"Zodiac Animal"];x
//    
//    _lblChineseName3.text = bazi3[@"Element"];
//    _lblChineseSymbol3.text = bazi3[@"Chinese symbol"];
//    
//    _lblChineseName4.text = bazi4[@"Element"];
//    _lblChineseSymbol4.text = bazi4[@"Chinese symbol"];
//        _lblAnimal2.text = bazi4[@"Zodiac Animal"];
//    
//    
//    _lblChineseName5.text = bazi5[@"Element"];
//    _lblChineseSymbol5.text = bazi5[@"Chinese symbol"];
//    
//    _lblChineseName6.text = bazi6[@"Element"];
//    _lblChineseSymbol6.text = bazi6[@"Chinese symbol"];
//        _lblAnimal3.text = bazi6[@"Zodiac Animal"];
//    
//    _lblChineseName7.text = bazi7[@"Element"];
//    _lblChineseSymbol7.text = bazi7[@"Chinese symbol"];
//    
//    _lblChineseName8.text = bazi8[@"Element"];
//    _lblChineseSymbol8.text = bazi8[@"Chinese symbol"];
//        _lblAnimal4.text = bazi8[@"Zodiac Animal"];
//    }
//    if ([[UserDetails sharedInstance].chinese_element isEqualToString:@"water_wood"]) {
//        _view2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0];
//    }
}


- (void)getBoxStatus
{
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
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_webservices/blackbox.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[UserDetails sharedInstance].dob];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"blackboxdate=%@",[newFormatter stringFromDate:birthDate]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        if(error) {
            NSLog(@"error : %@", [error description]);
            
        } else
        {
            // This is the expected result
            NSLog(@"result : %@", result);
            boxStatus = result[@"status"];
            if ([result[@"status"]  isEqualToNumber:[NSNumber numberWithInt:0]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dob = [formatter dateFromString:[UserDetails sharedInstance].dob];
                
                NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                NSString *strDOB = [dateFormatter stringFromDate:dob];
                
                NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                [timeFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *time = [timeFormatter dateFromString:[UserDetails sharedInstance].birthtime];
                
                NSDateFormatter *newtimeFormatter = [[NSDateFormatter alloc] init];
                [newtimeFormatter setDateFormat:@"hh:mm a"];
                
                NSString *birthTime = [newtimeFormatter stringFromDate:time];
                NSArray *dateSplitter = [birthTime componentsSeparatedByString:@":"];
                NSString *strtime = dateSplitter[0];
                NSString *toTime = [NSString stringWithFormat:@"%i:%@",[strtime intValue] +1,dateSplitter[1]];
                
               
                
                strDate = [NSString stringWithFormat:@"%@",strDOB];
                [_tblView reloadData];
                //lblBirthDate.text = [NSString stringWithFormat:@"%@",strDOB];
            }
            else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dob = [formatter dateFromString:[UserDetails sharedInstance].dob];
                
                NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                NSString *strDOB = [dateFormatter stringFromDate:dob];
                
                NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                [timeFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *time = [timeFormatter dateFromString:[UserDetails sharedInstance].birthtime];
                
                NSDateFormatter *newtimeFormatter = [[NSDateFormatter alloc] init];
                [newtimeFormatter setDateFormat:@"hh:mm a"];
                
                NSString *birthTime = [newtimeFormatter stringFromDate:time];
                NSArray *dateSplitter = [birthTime componentsSeparatedByString:@":"];
                NSString *strtime = dateSplitter[0];
                NSString *toTime = [NSString stringWithFormat:@"%i:%@",[strtime intValue] +1,dateSplitter[1]];
                
                
                strDate = [NSString stringWithFormat:@"%@ %@ - %@",strDOB,birthTime,toTime];
                [_tblView reloadData];
            }
            
        }
        [self hudWasHidden:hudProgress];
    }];
    }
}

- (void)getNobleStar
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_webservices/nobelmanstar.php",BASEURL];
       
        NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            if(error) {
                NSLog(@"error : %@", [error description]);
                UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                UILabel *lblNobleDates = (UILabel *)[cell viewWithTag:10];
                NSArray *constraints = [lblNobleDates constraints];
                int index = 0;
                BOOL found = NO;
                
                while (!found && index < [constraints count]) {
                    NSLayoutConstraint *constraint = constraints[index];
                    if ( [constraint.identifier isEqualToString:@"lblHeight1"] ) {
                        //save the reference to constraint
                        found = YES;
                        constraint.constant = 0;
                        [self.view needsUpdateConstraints];
                        [_tblView reloadData];
                    }
                    index ++;
                }
            } else {
                // This is the expected result
                NSLog(@"result : %@", result);
                
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([result[@"datingdates"] count] > 0) {
                        NSArray *arrDates = result[@"datingdates"];
                        
                        for (NSDictionary *dict in arrDates) {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            NSDate *dob = [formatter dateFromString:dict[@"dateresultset"]];
                            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"dd MMM"];
                            NSString *strDOB = [dateFormatter stringFromDate:dob];
                            [nobleDates addObject:strDOB];
                        }
                        
                        UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        UILabel *lblNobleDates = (UILabel *)[cell viewWithTag:10];
                        if (nobleDates.count > 0) {
                            lblNobleDates.text = [NSString stringWithFormat:@"Upcoming Nobleman Days :\n %@",[nobleDates componentsJoinedByString:@", "]];
                        }
                        else
                        {
                            NSArray *constraints = [lblNobleDates constraints];
                            int index = 0;
                            BOOL found = NO;
                            
                            while (!found && index < [constraints count]) {
                                NSLayoutConstraint *constraint = constraints[index];
                                if ( [constraint.identifier isEqualToString:@"lblHeight1"] ) {
                                    //save the reference to constraint
                                    found = YES;
                                    constraint.constant = 0;
                                    [self.view updateConstraints];
                                    [_tblView reloadData];
                                }
                                index ++;
                        }
                        }
                    }
                }
                else
                {
                    UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    UILabel *lblNobleDates = (UILabel *)[cell viewWithTag:10];
                    NSArray *constraints = [lblNobleDates constraints];
                    int index = 0;
                    BOOL found = NO;
                    
                    while (!found && index < [constraints count]) {
                        NSLayoutConstraint *constraint = constraints[index];
                        if ( [constraint.identifier isEqualToString:@"lblHeight1"] ) {
                            //save the reference to constraint
                            found = YES;
                            constraint.constant = 0;
                            [self.view updateConstraints];
                            [_tblView reloadData];
                        }
                        index ++;
                    }
                }
                
            }
           // [self hudWasHidden:hudProgress];
        }];
    }
}

- (void)getPeachStar
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_webservices/peachblossomstars.php",BASEURL];
        
        NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            if(error) {
                NSLog(@"error : %@", [error description]);
                UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                UILabel *lblPeachDates = (UILabel *)[cell viewWithTag:20];
                NSArray *constraints = [lblPeachDates constraints];
                int index = 0;
                BOOL found = NO;
                
                while (!found && index < [constraints count]) {
                    NSLayoutConstraint *constraint = constraints[index];
                    if ( [constraint.identifier isEqualToString:@"lblHeight2"] ) {
                        //save the reference to constraint
                        found = YES;
                        constraint.constant = 0;
                        [self.view needsUpdateConstraints];
                        [_tblView reloadData];
                    }
                    index ++;
                }
            } else {
                // This is the expected result
                NSLog(@"result : %@", result);
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([result[@"datingdates"] count] > 0) {
                        NSArray *arrDates = result[@"datingdates"];
                        
                        for (NSDictionary *dict in arrDates) {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            NSDate *dob = [formatter dateFromString:dict[@"dateresultset"]];
                            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"dd MMM"];
                            NSString *strDOB = [dateFormatter stringFromDate:dob];
                            [peachesDates addObject:strDOB];
                        }
                        UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        UILabel *lblPeachDates = (UILabel *)[cell viewWithTag:20];
                        if (peachesDates.count > 0) {
                            lblPeachDates.text = [NSString stringWithFormat:@"Upcoming Peach Blossom Days :\n %@",[peachesDates componentsJoinedByString:@", "]];
                    }
                    else
                    {
                        NSArray *constraints = [lblPeachDates constraints];
                        int index = 0;
                        BOOL found = NO;
                        
                        while (!found && index < [constraints count]) {
                            NSLayoutConstraint *constraint = constraints[index];
                            if ( [constraint.identifier isEqualToString:@"lblHeight2"] ) {
                                //save the reference to constraint
                                found = YES;
                                constraint.constant = 0;
                                [self.view updateConstraints];
                                [_tblView reloadData];
                            }
                            index ++;
                        }
                    }
                    }
                }
                else
                {
                    UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    UILabel *lblPeachDates = (UILabel *)[cell viewWithTag:20];
                    NSArray *constraints = [lblPeachDates constraints];
                    int index = 0;
                    BOOL found = NO;
                    
                    while (!found && index < [constraints count]) {
                        NSLayoutConstraint *constraint = constraints[index];
                        if ( [constraint.identifier isEqualToString:@"lblHeight2"] ) {
                            //save the reference to constraint
                            found = YES;
                            constraint.constant = 0;
                            [self.view updateConstraints];
                            [_tblView reloadData];
                        }
                        index ++;
                    }

                }
            
            }
            [self hudWasHidden:hudProgress];
        }];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return 75;
        }
            break;
            case 1:
        {
            return 266;
        }
            break;
            case 2:
        {
            return UITableViewAutomaticDimension;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
        
        UILabel *lblName = (UILabel *)[cell viewWithTag:10];
        
    

        
        //lblName.text = [UserDetails sharedInstance].full_name;
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:30];
        imgView.layer.cornerRadius = 34.0;
        [imgView.layer setMasksToBounds:YES];
        UIImage *img1 = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1];
        if (img1 == nil) {
           [self requestProfileDetails];
        }
        imgView.image = img1;
        
        NSDictionary *attrsName = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:128.0/255.0 green:64.0/255.0 blue:0 alpha:1.0] , NSFontAttributeName : [UIFont fontWithName:@"Segoe Print" size:16.0] };
        NSAttributedString *attrName = [[NSAttributedString alloc] initWithString:[[UserDetails sharedInstance].full_name capitalizedString] attributes:attrsName];
        
        
        if (strDate.length > 0) {
            NSDictionary *attrsDate = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:128.0/255.0 green:64.0/255.0 blue:0 alpha:1.0] , NSFontAttributeName : [UIFont fontWithName:@"Segoe Print" size:11.0] };
            NSAttributedString *attrDate = [[NSAttributedString alloc] initWithString:strDate attributes:attrsDate];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
            [str appendAttributedString:attrName];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@", " attributes:attrsName]];
            [str appendAttributedString:attrDate];
            lblName.attributedText = str;
        }
        else
        {
            lblName.attributedText = attrName;
        }
        

        
        UILabel *lblGender = (UILabel *)[cell viewWithTag:20];
        if ([[UserDetails sharedInstance].gender isEqualToString:@"2"])
            lblGender.text = @"Female";
        else
            lblGender.text = @"Male";
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"box" forIndexPath:indexPath];
        
        UIView *view1 = [cell viewWithTag:10];
        UIView *view2 = [cell viewWithTag:20];
        UIView *view3 = [cell viewWithTag:30];
        UIView *view4 = [cell viewWithTag:40];
        UIView *view5 = [cell viewWithTag:50];
        UIView *view6 = [cell viewWithTag:60];
        UIView *view7 = [cell viewWithTag:70];
        UIView *view8 = [cell viewWithTag:80];
        
        view1.layer.cornerRadius = 7.0;
        [view1. layer setMasksToBounds:YES];
        view2.layer.cornerRadius = 7.0;
        [view2. layer setMasksToBounds:YES];
        view3.layer.cornerRadius = 7.0;
        [view3. layer setMasksToBounds:YES];
        view4.layer.cornerRadius = 7.0;
        [view4. layer setMasksToBounds:YES];
        view5.layer.cornerRadius = 7.0;
        [view5. layer setMasksToBounds:YES];
        view6.layer.cornerRadius = 7.0;
        [view6. layer setMasksToBounds:YES];
        view7.layer.cornerRadius = 7.0;
        [view7. layer setMasksToBounds:YES];
        view8.layer.cornerRadius = 7.0;
        [view8. layer setMasksToBounds:YES];
        
        UILabel *lblChineseName1 = (UILabel *)[view1 viewWithTag:2];
        UILabel *lblChineseName2 = (UILabel *)[view2 viewWithTag:2];
        UILabel *lblChineseName3 = (UILabel *)[view3 viewWithTag:2];
        UILabel *lblChineseName4 = (UILabel *)[view4 viewWithTag:2];
        UILabel *lblChineseName5 = (UILabel *)[view5 viewWithTag:2];
        UILabel *lblChineseName6 = (UILabel *)[view6 viewWithTag:2];
        UILabel *lblChineseName7 = (UILabel *)[view7 viewWithTag:2];
        UILabel *lblChineseName8 = (UILabel *)[view8 viewWithTag:2];
        
        UILabel *lblChineseSymbol1 = (UILabel *)[view1 viewWithTag:1];
        UILabel *lblChineseSymbol2 = (UILabel *)[view2 viewWithTag:1];
        UILabel *lblChineseSymbol3 = (UILabel *)[view3 viewWithTag:1];
        UILabel *lblChineseSymbol4 = (UILabel *)[view4 viewWithTag:1];
        UILabel *lblChineseSymbol5 = (UILabel *)[view5 viewWithTag:1];
        UILabel *lblChineseSymbol6 = (UILabel *)[view6 viewWithTag:1];
        UILabel *lblChineseSymbol7 = (UILabel *)[view7 viewWithTag:1];
        UILabel *lblChineseSymbol8 = (UILabel *)[view8 viewWithTag:1];
        
        UILabel *lblAnimal1 = (UILabel *)[cell viewWithTag:100];
        UILabel *lblAnimal2 = (UILabel *)[cell viewWithTag:200];
        UILabel *lblAnimal3 = (UILabel *)[cell viewWithTag:300];
        UILabel *lblAnimal4 = (UILabel *)[cell viewWithTag:400];
        
        lblAnimal1.layer.cornerRadius = 10.0;
        [lblAnimal1. layer setMasksToBounds:YES];
        lblAnimal2.layer.cornerRadius = 10.0;
        [lblAnimal2. layer setMasksToBounds:YES];
        lblAnimal3.layer.cornerRadius = 10.0;
        [lblAnimal3. layer setMasksToBounds:YES];
        lblAnimal4.layer.cornerRadius = 10.0;
        [lblAnimal4. layer setMasksToBounds:YES];
        
        if ([[UserDetails sharedInstance].bazivalue1 isEqual:[NSNumber numberWithInt:0]]) {
            
        }
        else
        {
            NSDictionary *bazi1 = baziCalander[[UserDetails sharedInstance].bazivalue1];
            NSDictionary *bazi2 = baziCalander[[UserDetails sharedInstance].bazivalue2];
            NSDictionary *bazi3 = baziCalander[[UserDetails sharedInstance].bazivalue3];
            NSDictionary *bazi4 = baziCalander[[UserDetails sharedInstance].bazivalue4];
            NSDictionary *bazi5 = baziCalander[[UserDetails sharedInstance].bazivalue5];
            NSDictionary *bazi6 = baziCalander[[UserDetails sharedInstance].bazivalue6];
            NSDictionary *bazi7 = baziCalander[[UserDetails sharedInstance].bazivalue7];
            NSDictionary *bazi8 = baziCalander[[UserDetails sharedInstance].bazivalue8];
            
            lblChineseName1.text = bazi1[@"Element"];
            lblChineseSymbol1.text = bazi1[@"Chinese symbol"];
            
            lblChineseName2.text = bazi2[@"Element"];
            lblChineseSymbol2.text = bazi2[@"Chinese symbol"];
            lblAnimal4.text = bazi2[@"Zodiac Animal"];
            
            lblChineseName3.text = bazi3[@"Element"];
            lblChineseSymbol3.text = bazi3[@"Chinese symbol"];
            
            lblChineseName4.text = bazi4[@"Element"];
            lblChineseSymbol4.text = bazi4[@"Chinese symbol"];
            lblAnimal3.text = bazi4[@"Zodiac Animal"];
            
            
            lblChineseName5.text = bazi5[@"Element"];
            lblChineseSymbol5.text = bazi5[@"Chinese symbol"];
            
            lblChineseName6.text = bazi6[@"Element"];
            lblChineseSymbol6.text =  bazi6[@"Chinese symbol"];
            lblAnimal2.text = bazi6[@"Zodiac Animal"];
            NSLog(@"[OnDeck sharedInstance].strBirthtime = %@",[UserDetails sharedInstance].birthtime);
            if ([[UserDetails sharedInstance].birthtime isEqualToString:@"-- --"]) {
                lblChineseName7.text = @"";
                lblChineseSymbol7.text = @"";
                
                lblChineseName8.text = @"";
                lblChineseSymbol8.text = @"";
                
                lblAnimal1.text = @"";
            }
            else
            {
                lblChineseName7.text = bazi7[@"Element"];
                lblChineseSymbol7.text = bazi7[@"Chinese symbol"];
                
                lblChineseName8.text = bazi8[@"Element"];
                lblChineseSymbol8.text = bazi8[@"Chinese symbol"];
                
                lblAnimal1.text = bazi8[@"Zodiac Animal"];
            }
            
            
        }

        
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
       
        UIView *view = [cell viewWithTag:30];
        UILabel *lblDayMaster = (UILabel *)[view viewWithTag:1];
        UILabel *lblDayMasterSymbol = (UILabel *)[view viewWithTag:3];
        NSDictionary *bazi1 = baziCalander[[UserDetails sharedInstance].bazivalue5];
        lblDayMaster.text = dayMaster[[UserDetails sharedInstance].bazivalue5];
        lblDayMasterSymbol.text = bazi1[@"Chinese symbol"];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

-(IBAction)showPopupBlossomCentered:(id)sender {
    NSString *blossom = @"You will appear more socially attractive and charming. This day is very beneficial in bringing romance and glamour into your life. Increase your social activities and boost your chances of meeting a romantic someone on this day.";
    [self showPopupWithStyle:CNPPopupStyleCentered withContent:blossom withTitle:@"Peach Blossom Days"];
}

-(IBAction)showPopupPeachesCentered:(id)sender {
    NSString *Nobleman  = @"You will be under the positive influence of the nobleman stars. It rrefers to helpful people who appear at certain points in your life or even change your life for the better. Your chances of success will be greatly increased. When it comes to dating, maybe your date could be the nobleman that will enter your life and make you a better person!";
    [self showPopupWithStyle:CNPPopupStyleCentered withContent:Nobleman  withTitle:@"Nobleman Days"];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle withContent:(NSString *)content withTitle:(NSString *)strtitle{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:strtitle attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Segoe Print" size:17.0], NSParagraphStyleAttributeName : paragraphStyle , NSForegroundColorAttributeName : [UIColor colorWithRed:157.0/255.0 green:0 blue:33.0/255.0 alpha:1.0]}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Segoe Print" size:15.0], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithRed:157.0/255.0 green:0 blue:33.0/255.0 alpha:1.0]}];
//    UIImage *icon = [UIImage imageNamed:@"icon"];
//    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Close me" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Segoe Print" size:15.0], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupController *popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne] buttonTitles:@[buttonTitle] destructiveButtonTitle:nil];
    popupController.theme = [CNPPopupTheme defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
    popupController.theme.dismissesOppositeDirection = YES;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

- (IBAction)findingmatching:(id)sender {
    ContentViewController *content = (ContentViewController *)[self parentViewController];
    
    
    
    for (UIView *view  in content.view.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MainViewController *main = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    
    
    [content addChildViewController:main];
    
    [content.view addSubview:main.view];
    

    
    
}

- (void)requestProfileDetails{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        //        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hudProgress.delegate = self;
        //
        //        hudProgress.mode = MBProgressHUDModeIndeterminate;
        //        hudProgress.labelText = @"Loading";
        //        hudProgress.dimBackground = YES;
        NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_webservices/viewprofile.php",BASEURL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            if(error) {
                NSLog(@"error : %@", [error description]);
            } else {
                // This is the expected result
                NSLog(@"Intrest result : %@", result);
                if (result.count >0) {
                    if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        
                        UserDetails *userDetails = [UserDetails sharedInstance];
                        userDetails.fb_id = result[@"facebookid"];
                        userDetails.email = result[@"email"];
                        userDetails.full_name = result[@"fullname"];
                        userDetails.latitude = result[@"latitude"];
                        userDetails.logitude = result[@"longitude"];
                        userDetails.dob = result[@"dob"];
                        userDetails.birthtime = result[@"birthtime"];
                        if ([result[@"birthtime"] isEqualToString:@"00:01:00"]) {
                            userDetails.birthtime = @"-- --";
                        }
                        
                        userDetails.descriptions = result[@"description"];
                        userDetails.gender = result[@"gender"];
                        userDetails.height = result[@"height"];
                        userDetails.bazivalue1 = result[@"bazivalue1"];
                        userDetails.bazivalue2 = result[@"bazivalue2"];
                        userDetails.bazivalue3 = result[@"bazivalue3"];
                        userDetails.bazivalue4 = result[@"bazivalue4"];
                        userDetails.bazivalue5 = result[@"bazivalue5"];
                        userDetails.bazivalue6 = result[@"bazivalue6"];
                        userDetails.bazivalue7 = result[@"bazivalue7"];
                        userDetails.bazivalue8 = result[@"bazivalue8"];
                        userDetails.lookingfor = result[@"lookingfor"];
                        userDetails.weight = result[@"weight"];
                        userDetails.datingid = result[@"datingid"];
                        userDetails.keyword1 = result[@"keyword1"];
                        userDetails.keyword2 = result[@"keyword2"];
                        userDetails.keyword3 = result[@"keyword3"];
                        userDetails.keyword4 = result[@"keyword4"];
                        userDetails.keyword5 = result[@"keyword5"];
                        NSMutableArray *keys = [[NSMutableArray alloc] init];
                        if (userDetails.keyword1.length > 0) {
                            [keys insertObject:userDetails.keyword1 atIndex:0];
                            //[keys addObject:userDetails.keyword1];
                        }
                        if (userDetails.keyword2.length > 0) {
                            [keys insertObject:userDetails.keyword2 atIndex:0];
                            //[keys addObject:userDetails.keyword2];
                        }
                        if (userDetails.keyword3.length > 0) {
                            //[keys addObject:userDetails.keyword3];
                            [keys insertObject:userDetails.keyword3 atIndex:0];
                        }
                        if (userDetails.keyword4.length > 0) {
                            //[keys addObject:userDetails.keyword4];
                            [keys insertObject:userDetails.keyword4 atIndex:0];
                        }
                        if (userDetails.keyword5.length > 0) {
                            [keys insertObject:userDetails.keyword5 atIndex:0];
                            //[keys addObject:userDetails.keyword5];
                        }
                        
                        userDetails.keywords = keys;
                        
                        userDetails.image1 = result[@"img1"];
                        userDetails.image2 = result[@"img2"];
                        userDetails.image3 = result[@"img3"];
                        
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate* birthday = [formatter dateFromString:[UserDetails sharedInstance].dob];
                        
                        //                                                                 NSDate* now = [NSDate date];
                        //                                                                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                        //                                                                                                    components:NSCalendarUnitYear
                        //                                                                                                    fromDate:birthday
                        //                                                                                                    toDate:now
                        //                                                                                                    options:0];
                        
                        //_lblName.text = [NSString stringWithFormat:@"%@, %ld",[UserDetails sharedInstance].full_name,age];
                        //  _txtView.text = [UserDetails sharedInstance].descriptions;
                        if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1] == nil){
                            [self startDownloadImage:userDetails.image1 withID:@"1"];
                        }
                        if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image2] == nil){
                            [self startDownloadImage:userDetails.image2 withID:@"2"];
                        }
                        if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image3] == nil){
                            [self startDownloadImage:userDetails.image3 withID:@"3"];
                        }
                        
                        if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1] != nil)  {
                            //                                                                     UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1];
                            //                                                                     _imagViewMyProfilePic.image = image;
                            [_tblView reloadData];
                            
                            
                        }
                        //[_CollectionViewIntrest reloadData];
                        [self hudWasHidden:hudProgress];
                    }
                    
                    
                }else{
                    
                }
            }
            
            
            
        }];
    }
    
}

- (void)startDownloadImage:(NSString*)imageUrl withID:(NSString *)url
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:url];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = imageUrl;
        iconDownloader.url = url;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:url];
        [iconDownloader startDownload];
    }
}

- (void)appDidDownloadImagewithURl:(NSString *)url
{
    [self.tblView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [imageDownloadsInProgress removeObjectForKey:url];
    if (imageDownloadsInProgress.count == 0) {
        [self hudWasHidden:hudProgress];
    }
    
}


@end
