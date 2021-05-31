//
//  DictionaryFileCreator.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 27.05.21.
//

#import "DictionaryFileContent.h"

@interface DictionaryFileContent ()

@property (strong, nonatomic) NSString* inputWord;
@property (strong, nonatomic) NSMutableString* wordDescription;


@end

@implementation DictionaryFileContent

-(instancetype)init
{
    if ([super init])
    {
        [self loadWordsAndDescription];
    }
    
    return self;
}

-(NSMutableDictionary<NSString *, NSString *> *)activeDictionaryWithLanguage:(EnumLanguage)language
{
    if (language == EnumLanguageEN)
    {
        return self.englishWordsDictionary;
    }
    return self.bulgarianWordsDictionary;
}

-(void)loadWordsAndDescription
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileENDictionary = [documentsDirectory stringByAppendingPathComponent:@"words_en.txt"];
    
    NSString* fileBGDictionary = [documentsDirectory stringByAppendingPathComponent:@"words_bg.txt"];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //check if have that file
    if (![fileManager fileExistsAtPath:fileENDictionary] && ![fileManager fileExistsAtPath:fileBGDictionary])
    {
        NSLog(@"no file");
        
        self.englishWordsDictionary = [[NSMutableDictionary alloc] init];
        
        self.bulgarianWordsDictionary = [[NSMutableDictionary alloc] init];
        
        self.wordDescription = [[NSMutableString alloc] init];
        
        [self createDictionaryFileWithLanguage:EnumLanguageEN];
        
        [self createDictionaryFileWithLanguage:EnumLanguageBG];
        
        return;
    }
    
    self.englishWordsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileENDictionary];
    self.bulgarianWordsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileBGDictionary];
}

-(void)createDictionaryFileWithLanguage:(EnumLanguage)language
{
    NSString* curLanguage;
    NSString* otherLanguage;
    
    if (language == EnumLanguageEN)
    {
        curLanguage = @"en";
        otherLanguage = @"bg";
    }
    else
    {
        curLanguage = @"bg";
        otherLanguage = @"en";
    }
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", curLanguage, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    
    while (fgets(buffer, 1024, file))
    {
        
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        [self parse:line withLanguage:language];
        
    }
    
    fclose(file);
    
    [self saveWordsAndDescriptionInFileWithLanguage:language];
}

-(void)parse:(NSString*)line withLanguage:(EnumLanguage)language
{
    if ([line containsString:@"@"])
    {
        NSString* lastWord = self.inputWord;
        self.inputWord = [line componentsSeparatedByString:@"@"].lastObject;
        
        if (lastWord != nil)
        {
            [self.wordDescription appendString:[line componentsSeparatedByString:@"@"].firstObject];
            [[self activeDictionaryWithLanguage:language] setValue:self.wordDescription forKey:lastWord];

            self.wordDescription = [[NSMutableString alloc] init];
        }
        
        if (self.inputWord.length != 0)
        {
            self.inputWord = [self.inputWord substringWithRange:NSMakeRange(0, self.inputWord.length - 1)];
        }
    }
    else
    {
        [self.wordDescription appendString:line];
    }
    
}

-(void)saveWordsAndDescriptionInFileWithLanguage:(EnumLanguage)language
{
    NSString* curLanguage = language == EnumLanguageEN ? @"en" : @"bg";
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileWordsName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"words_%@.txt", curLanguage]];
    
    [[self activeDictionaryWithLanguage:language] writeToFile:fileWordsName atomically:YES];

}

@end
