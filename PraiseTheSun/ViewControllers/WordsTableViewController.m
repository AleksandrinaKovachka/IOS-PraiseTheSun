//
//  WordsTableViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import "WordsTableViewController.h"
#import "Dictionary.h"
#import "Dictionaries.h"
#import "WordsTableViewCell.h"
#import "NotificationNames.h"
#import "DescriptionViewController.h"

@interface WordsTableViewController ()

@property (strong, nonatomic) Dictionary* dictionary;
@property (strong, nonatomic) NSArray<NSString*>* wordsArray;
@property (assign) BOOL predictiveTextState;

@end

@implementation WordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionary = [[Dictionary alloc] init];
    
    self.wordsArray = [[NSMutableArray alloc] init];
    
    self.predictiveTextState = NO;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeWord:) name:NOTIFICATION_CHANGE_WORD object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangePredictiveTextState:) name:NOTIFICATION_CHANGE_PREDICTIVE_TEXT object:nil];
}

-(void)didChangeWord:(NSNotification*)notification
{
    self.wordsArray = [self.dictionary wordsStartedWith:notification.object];
    
    [self.tableView reloadData];
}

-(void)didSuggestedWordsChangeTo:(NSArray<NSString*>*)words
{
    self.wordsArray = words;
    
    [self.tableView reloadData];
}

-(void)didNumbersChangeTo:(NSString*)word
{
    self.wordsArray = [self.dictionary wordsStartedWith:word];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordsTableViewID" forIndexPath:indexPath];
    
    if (self.wordsArray[indexPath.row] == nil)
    {
        cell.wordLabel.text = @"";
    }
    else
    {
        cell.wordLabel.text = self.wordsArray[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* word = self.wordsArray[indexPath.row];
    NSString* description = [self.dictionary descriptionOfWord:word];
    
    if (self.predictiveTextState)
    {
        [self.userWordsChoiceDelegate didChooseWord:word];
    }
    
    DescriptionViewController* descriptionController = [DescriptionViewController descriptionViewControllerWith:word andDescription:description];
    
    [self presentViewController:descriptionController animated:YES completion:nil];
}

-(void)didChangePredictiveTextState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        self.predictiveTextState = YES;
    }
    else
    {
        self.predictiveTextState = NO;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
