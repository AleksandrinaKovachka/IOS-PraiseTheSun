//
//  ConsoleViewController.m
//  Tic-Tac-Toe
//
//  Created by A-Team Intern on 19.04.21.
//

#import "ConsoleViewController.h"
#import "Dictionary.h"

@interface ConsoleViewController ()

@property (strong, nonatomic) Dictionary* dictionary;

@end

@implementation ConsoleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dictionary = [[Dictionary alloc] init];
    //[self.dictionary searchInDictionary];
    
    //TODO: generate file with index - ones - how to get part of file
    //create file and search in dictionary

}

- (IBAction)onClickSubmit:(id)sender
{
    self.consoleBoardLabel.text = [self.dictionary wordsStartedWith:self.inputChoice.text][0];
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
