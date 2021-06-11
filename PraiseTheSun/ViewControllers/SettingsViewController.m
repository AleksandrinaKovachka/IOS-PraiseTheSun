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

@property (weak, nonatomic) IBOutlet UISwitch *keystrokeTranslateSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *latinAsCyrillicSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *cyrillicAsLatinSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *predictiveTextSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *multiTapSwitch;

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

-(IBAction)onSwitchKeystrokeTranslate:(id)sender
{
    NSString* keystrokeTranslateState;
    if (self.keystrokeTranslateSwitch.on == YES)
    {
        keystrokeTranslateState = @"On";
    }
    else
    {
        keystrokeTranslateState = @"Off";
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_KEYSTROKE_TRANSLATE object:keystrokeTranslateState userInfo:nil];
}

-(IBAction)onSwitchLatinAsCyrillic:(id)sender
{
    NSString* latinAsCyrillic;
    if (self.latinAsCyrillicSwitch.on == YES)
    {
        latinAsCyrillic = @"On";
    }
    else
    {
        latinAsCyrillic = @"Off";
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_LATIN_AS_CYRILLIC object:latinAsCyrillic userInfo:nil];
}

-(IBAction)onSwitchCyrilicAsLatin:(id)sender
{
    NSString* cyrillicAsLatin;
    if (self.cyrillicAsLatinSwitch.on == YES)
    {
        cyrillicAsLatin = @"On";
    }
    else
    {
        cyrillicAsLatin = @"Off";
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_CYRILLIC_AS_LATIN object:cyrillicAsLatin userInfo:nil];
}

-(IBAction)onSwitchPredictiveText:(id)sender
{
    NSString* predictiveText;
    if (self.predictiveTextSwitch.on == YES)
    {
        predictiveText = @"On";
        self.multiTapSwitch.enabled = NO;
    }
    else
    {
        predictiveText = @"Off";
        self.multiTapSwitch.enabled = YES;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_PREDICTIVE_TEXT object:predictiveText userInfo:nil];
}

-(IBAction)onSwitchMultiTap:(id)sender
{
    NSString* multiTap;
    if (self.multiTapSwitch.on == YES)
    {
        multiTap = @"On";
        self.predictiveTextSwitch.enabled = NO;
    }
    else
    {
        multiTap = @"Off";
        self.predictiveTextSwitch.enabled = YES;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_MULTI_TAP object:multiTap userInfo:nil];
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
