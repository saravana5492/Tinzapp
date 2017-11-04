//
//  ProfileOneViewController.h
//  Twozapp
//
//  Created by Priya on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTimePicker.h"

@interface ProfileOneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CustomTimePickerDelegate>



@property (nonatomic,strong) CustomTimePicker *clockView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgGMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgGfemale;
@property (weak, nonatomic) IBOutlet UIImageView *imgLMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgLFemale;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (strong, nonatomic) IBOutlet UIView *txtWeightView;

@property (weak, nonatomic) IBOutlet UIView *viewPickerBackground;
@property (strong, nonatomic) IBOutlet UIView *textHeightView;
@property (strong, nonatomic) IBOutlet UIView *nextBtnView;

@property (strong, nonatomic) IBOutlet UIView *dayView;
@property (strong, nonatomic) IBOutlet UIView *yearView;
@property (strong, nonatomic) IBOutlet UIView *monthView;


@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITableView *tblday;
@property (weak, nonatomic) IBOutlet UIDatePicker *tblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tblMonth;
@property (weak, nonatomic) IBOutlet UITableView *tblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UITextField *txtDay;
@property (weak, nonatomic) IBOutlet UITextField *txtMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;

@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (strong, nonatomic) NSString *actionType;
@property (weak, nonatomic) IBOutlet UIImageView *imgDropdown;
- (IBAction)actionDay:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionTime:(id)sender;
- (IBAction)actionMonth:(id)sender;
- (IBAction)actionyear:(id)sender;
- (IBAction)actionDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBirthTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthTIME;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarBtn;
- (IBAction)actionGMale:(id)sender;
- (IBAction)actionGFemale:(id)sender;
- (IBAction)actionLMale:(id)sender;
- (IBAction)actionLFemale:(id)sender;
- (IBAction)actionNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnnext;


@end
