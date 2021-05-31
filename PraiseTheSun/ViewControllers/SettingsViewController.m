//
//  SettingsViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 26.05.21.
//

#import "SettingsViewController.h"
#import "NotificationNames.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *suggestedWordsTextField;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)valueChangeForSuggestedWords:(id)sender
{
    NSUInteger val = [self.stepper value];
    
    self.suggestedWordsTextField.text = [NSString stringWithFormat:@"%d", (int)val];
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_NUMBER_OF_SUGGESTED_WORDS object:[NSString stringWithFormat:@"%d", (int)val] userInfo:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
