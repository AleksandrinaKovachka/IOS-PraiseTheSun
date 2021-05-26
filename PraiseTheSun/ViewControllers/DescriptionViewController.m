//
//  DescriptionViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wordNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *wordDescriptionTextView;

@property (strong, nonatomic) NSString* word;
@property (strong, nonatomic) NSString* wordDescription;

@end

@implementation DescriptionViewController

+(instancetype)descriptionViewControllerWith:(NSString*)word andDescription:(NSString*)description
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DescriptionViewController* descriptionController = [storyboard instantiateViewControllerWithIdentifier:@"DescriptionViewControllerID"];
    
    descriptionController.word = word;
    descriptionController.wordDescription = description;
    
    return descriptionController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wordNameLabel.text = self.word;
    self.wordDescriptionTextView.text = self.wordDescription;
}

- (IBAction)backToDictionaryOnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
