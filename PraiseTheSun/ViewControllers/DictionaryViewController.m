//
//  DictionaryViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import "DictionaryViewController.h"
#import "NotificationNames.h"

@interface DictionaryViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *wordSearchBar;
@property (weak, nonatomic) IBOutlet UITextView *currentWordDescription;


@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordSearchBar.delegate = self;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didHaveWordInDictionary:) name:NOTIFICATION_HAVE_WORD object:nil];
    // Do any additional setup after loading the view.
}

//TODO: different notification for user choice
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* partOfWord = searchBar.text;
    
    self.currentWordDescription.text = partOfWord;
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_WORD object:partOfWord userInfo:nil];
    
    //NSLog(@"%@", partOfWord);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* partOfWord = searchBar.text;
    
    //NSLog(@"%@", partOfWord);
}

-(void)didHaveWordInDictionary:(NSNotification*)notification
{
    self.currentWordDescription.text = notification.object;
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
