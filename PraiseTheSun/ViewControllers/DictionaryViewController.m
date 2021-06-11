//
//  DictionaryViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import "DictionaryViewController.h"
#import "NotificationNames.h"
#import "Dictionary.h"
#import "Dictionaries.h"
#import <PredictiveTextSearch/KeypadSearchBar.h>
#import "WordsTableViewController.h"

@interface DictionaryViewController ()

@property (strong, nonatomic) Dictionaries* dictionaries;

@property (weak, nonatomic) IBOutlet KeypadSearchBar *wordSearchBar;
@property (weak, nonatomic) IBOutlet UITextView *currentWordDescription;
@property (assign) BOOL keystrokeTranslateState;

@property (weak, nonatomic) WordsTableViewController* wordsTableViewController;


@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionaries = [[Dictionaries alloc] init];
    
    self.wordSearchBar.defaultInputDelegate = self;
    self.wordSearchBar.suggestedWordsDelegate = self.wordsTableViewController;
    
    [self.wordSearchBar initializePredictiveTextWithDictionary:self.dictionaries.englishWordsDictionary andLanguage:@"en"];
    
    self.keystrokeTranslateState = YES;

    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didHaveWordInDictionary:) name:NOTIFICATION_HAVE_WORD object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeKeystrokeTranslateState:) name:NOTIFICATION_CHANGE_KEYSTROKE_TRANSLATE object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangePredictiveTextState:) name:NOTIFICATION_CHANGE_PREDICTIVE_TEXT object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeMultiTapState:) name:NOTIFICATION_CHANGE_MULTI_TAP object:nil];
    
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* partOfWord = searchBar.text;
    
    self.currentWordDescription.text = partOfWord;
    
    if (self.keystrokeTranslateState == YES)
    {
        [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_WORD object:partOfWord userInfo:nil];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* partOfWord = searchBar.text;
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_WORD object:partOfWord userInfo:nil];
}

-(void)didHaveWordInDictionary:(NSNotification*)notification
{
    self.currentWordDescription.text = notification.object;
}

-(void)didChangeKeystrokeTranslateState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        self.keystrokeTranslateState = YES;
    }
    else
    {
        self.keystrokeTranslateState = NO;
    }
}

-(void)didChangePredictiveTextState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        [self.wordSearchBar isPredictiveText:YES];
    }
    else
    {
        [self.wordSearchBar isPredictiveText:NO];
    }
}

-(void)didChangeMultiTapState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        [self.wordSearchBar isMultiTap:YES];
    }
    else
    {
        [self.wordSearchBar isMultiTap:NO];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"EmbedWordsTableViewController"])
    {
        self.wordsTableViewController = (WordsTableViewController*)segue.destinationViewController;
        self.wordsTableViewController.userWordsChoiceDelegate = self.wordSearchBar;
    }
}


@end
