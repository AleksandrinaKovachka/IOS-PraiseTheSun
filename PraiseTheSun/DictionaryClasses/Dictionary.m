//
//  Dictionary.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import "Dictionary.h"
#import "NotificationNames.h"

@interface Dictionary ()

@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* englishWordsDictionary;
@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* bulgarianWordsDictionary;

@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* latinAsCyrillicDictionary;
@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* cyrillicAsLatinDictionary;
@property (assign) BOOL latinAsCyrillicOn;
@property (assign) BOOL cyrillicAsLatinOn;

@end

@implementation Dictionary

-(instancetype)init
{
    if ([super init])
    {
        DictionaryFileContent* dictionaryContent = [[DictionaryFileContent alloc] init];
        self.englishWordsDictionary = dictionaryContent.englishWordsDictionary;
        self.bulgarianWordsDictionary = dictionaryContent.bulgarianWordsDictionary;
        
        self.latinAsCyrillicDictionary = @{@"A": @"А", @"B": @"Б", @"C": @"Ц", @"D": @"Д", @"E": @"Е", @"F": @"Ф", @"G": @"Г", @"H": @"Х",
                                           @"I": @"И", @"J": @"Й", @"K": @"К", @"L": @"Л", @"M": @"М", @"N": @"Н", @"O": @"О", @"P": @"П",
                                           @"Q": @"Я", @"R": @"Р", @"S": @"С", @"T": @"Т", @"U": @"У", @"V": @"В", @"W": @"В", @"X": @"Х",
                                           @"Y": @"Ъ", @"Z": @"З", @"SH": @"Ш", @"#": @"Щ", @"CH": @"Ч", @"YU": @"Ю", @"TS": @"Ц",
                                           @"YO": @"ьо", @"YA": @"Я"
        };
        
        self.cyrillicAsLatinDictionary = @{@"А": @"A", @"Б": @"B", @"Ц": @"C", @"Д": @"D", @"Е": @"E", @"Ф": @"F", @"Г": @"G", @"Х": @"H",
                                           @"И": @"I", @"Й": @"J", @"К": @"K", @"Л": @"L", @"М": @"M", @"Н": @"N", @"О": @"O", @"П": @"P",
                                           @"Я": @"Q", @"Р": @"R", @"С": @"S", @"Т": @"T", @"У": @"U", @"Ж": @"V", @"В": @"W", @"З": @"Z"
        };
        
        self.latinAsCyrillicOn = NO;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeLatinAsCyrillicState:) name:NOTIFICATION_CHANGE_LATIN_AS_CYRILLIC object:nil];
        
        self.cyrillicAsLatinOn = NO;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeCyrillicAsLatinState:) name:NOTIFICATION_CHANGE_CYRILLIC_AS_LATIN object:nil];
        
        self.numberOfSuggestedWord = 10;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeNumberOfSuggestedWords:) name:NOTIFICATION_CHANGE_NUMBER_OF_SUGGESTED_WORDS object:nil];
    }
    
    return self;
}

-(void)didChangeNumberOfSuggestedWords:(NSNotification*)notification
{
    self.numberOfSuggestedWord = [notification.object intValue] - 1;
}

-(void)didChangeLatinAsCyrillicState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        self.latinAsCyrillicOn = YES;
    }
    else
    {
        self.latinAsCyrillicOn = NO;
    }
}

-(void)didChangeCyrillicAsLatinState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        self.cyrillicAsLatinOn = YES;
    }
    else
    {
        self.cyrillicAsLatinOn = NO;
    }
}

-(NSDictionary<NSString *, NSString *> *)activeDictionary
{
    if (self.language == EnumLanguageEN)
    {
        return self.englishWordsDictionary;
    }
    return self.bulgarianWordsDictionary;
}

-(NSDictionary<NSString *, NSString *> *)activeAlphabetDictionary
{
    if (self.language == EnumLanguageEN)
    {
        return self.latinAsCyrillicDictionary;
    }
    return self.cyrillicAsLatinDictionary;
}

-(BOOL)hasCapitalLetter:(NSString*)word
{
    NSRange range = [word rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    if (range.location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
}

-(NSString*)changeLetters:(NSString*)word
{
    NSString* curWord = [word uppercaseString];
    
    if ([curWord containsString:@"SHT"] && self.language == EnumLanguageEN)
    {
        curWord = [curWord stringByReplacingOccurrencesOfString:@"SHT" withString:@"#"];
    }
    
    NSMutableString* changedWord = [[NSMutableString alloc] init];
    
    NSUInteger len = curWord.length;
    unichar buffer[len];
    
    [curWord getCharacters:buffer range:NSMakeRange(0, len)];
    
    for (int i = 0; i < len; ++i)
    {
        if (i < curWord.length - 1)
        {
            NSString* combination = [NSString stringWithFormat:@"%C%C", buffer[i], buffer[i + 1]];
            if ([self.activeAlphabetDictionary objectForKey:combination])
            {
                [changedWord appendString: [self.activeAlphabetDictionary objectForKey:combination]];
                ++i;
                continue;
            }
        }
        
        [changedWord appendString: [self.activeAlphabetDictionary objectForKey:[NSString stringWithFormat:@"%C", buffer[i]]]];
    }
    
    return changedWord;
}

-(NSArray<NSString*>*)wordsStartedWith:(NSString*)word
{
    if ([word isEqual:@""])
    {
        return @[];
    }
    
    //TODO: maybe something more efficient
    if ([self.englishWordsDictionary objectForKey:[word substringWithRange:NSMakeRange(0, 1)]])
    {
        self.language = EnumLanguageEN;
    }
    else
    {
        self.language = EnumLanguageBG;
    }
    
    NSString* curWord = [word uppercaseString];
    
    //if word have capital letter and switch is on - change language
    if ([self hasCapitalLetter:word])
    {
        if ((self.language == EnumLanguageEN && self.latinAsCyrillicOn) || (self.language == EnumLanguageBG && self.cyrillicAsLatinOn))
        {
            curWord = [self changeLetters:word];
            
            self.language = self.language == EnumLanguageEN ? EnumLanguageBG : EnumLanguageEN;
        }
    }
    
    NSMutableArray<NSString*>* wordsWithCommonPrefix = [[NSMutableArray alloc] init];
    
    [self searchWord:curWord];
    
    [self commonPrefixedWordsTo:curWord andWordsCommenPrefixArr:wordsWithCommonPrefix];
    
    return wordsWithCommonPrefix;
}

-(void)searchWord:(NSString*)word
{
    if ([[self activeDictionary] objectForKey:word])
    {
        NSString* wordWithDescription = [self.activeDictionary objectForKey:word];
        
        //notification to change word description
        [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_HAVE_WORD object:wordWithDescription userInfo:nil];
    }
}

-(void)commonPrefixedWordsTo:(NSString*)word andWordsCommenPrefixArr:(NSMutableArray<NSString*>*)wordsWithCommonPrefix
{
    NSArray<NSString*>* sortedKeys = [[self.activeDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString* key in sortedKeys)
    {
        if (key.length >= word.length && [key hasPrefix:word])
        {
            [wordsWithCommonPrefix addObject:key];
        }
        if (wordsWithCommonPrefix.count > self.numberOfSuggestedWord)
        {
            break;
        }
    }
    
    if (wordsWithCommonPrefix.count < self.numberOfSuggestedWord && word.length - 1 > 0)
    {
        NSString* part = [word substringWithRange:NSMakeRange(0, word.length - 1)];
        
        return [self commonPrefixedWordsTo:part andWordsCommenPrefixArr:wordsWithCommonPrefix];
    }
}

-(NSString*)descriptionOfWord:(NSString*)word
{
    return self.activeDictionary[word];
}

@end
