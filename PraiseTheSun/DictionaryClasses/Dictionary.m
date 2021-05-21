//
//  Dictionary.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import "Dictionary.h"

@interface Dictionary ()

@property (strong, nonatomic) NSString* inputWord;
@property (strong, nonatomic) NSMutableDictionary<NSString*, NSString*>* wordsDescription;
@property (strong, nonatomic) NSMutableArray<NSString*>* wordsInDictionary;

@property (strong, nonatomic) NSMutableString* wordDescription;


@end

@implementation Dictionary

-(instancetype)initWithLanguage:(NSString*)language
{
    if ([super init])
    {
        self.language = language;
        
        [self loadWordsAndDescription];
    }
    
    return self;
}

-(void)loadWordsAndDescription
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileWordsName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"words_%@.txt", self.language]];
    NSString* fileWordsDescriptionName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"words_description_%@.txt", self.language]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //check if have that file
    if (![fileManager fileExistsAtPath:fileWordsName] && ![fileManager fileExistsAtPath:fileWordsDescriptionName])
    {
        NSLog(@"no file");
        
        self.wordsInDictionary = [[NSMutableArray alloc] init];
        self.wordsDescription = [[NSMutableDictionary alloc] init];
        self.wordDescription = [[NSMutableString alloc] init];
        
        [self createWordsAndDescriptionFiles];
        return;
    }
    
    self.wordsInDictionary = [[NSMutableArray alloc] initWithContentsOfFile:fileWordsName];
    self.wordsDescription = [[NSMutableDictionary alloc] initWithContentsOfFile:fileWordsDescriptionName];
}

-(void)createWordsAndDescriptionFiles
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    
    while (fgets(buffer, 1024, file))
    {
        
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        [self searchWordInLine:line];
        
    }
    
    fclose(file);
    
    //save data
    //[self saveWordsAndDescriptionInFile];
    //[self printData];
}

-(void)searchWordInLine:(NSString*)line
{
    if ([line containsString:@"@"])
    {
        NSString* lastWord = self.inputWord;
        self.inputWord = [line componentsSeparatedByString:@"@"].lastObject;
        
        if (lastWord != nil)
        {
            [self.wordDescription appendString:[line componentsSeparatedByString:@"@"].firstObject];
            [self.wordsDescription setValue:self.wordDescription forKey:lastWord];

            self.wordDescription = [[NSMutableString alloc] init];
        }
        
        if (self.inputWord.length != 0)
        {
            self.inputWord = [self.inputWord substringWithRange:NSMakeRange(0, self.inputWord.length - 1)];
            [self.wordsInDictionary addObject:self.inputWord];
        }
    }
    else
    {
        [self.wordDescription appendString:line];
    }
    
}

-(void)saveWordsAndDescriptionInFile
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileWordsName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"words_%@.txt", self.language]];
    NSString* fileWordsDescriptionName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"words_description_%@.txt", self.language]];
    
    [self.wordsInDictionary writeToFile:fileWordsName atomically:YES];
    [self.wordsDescription writeToFile:fileWordsDescriptionName atomically:YES];
}

-(void)printData
{
    
    if ([self.wordsDescription objectForKey:@"AARDVARK"])
    {
        NSString* value = [self.wordsDescription objectForKey:@"A"];
        NSLog(@"%@", value);
        NSLog(@"Description: %@", [self.wordsDescription objectForKey:@"AARDVARK"]);
        NSLog(@"%@", [self.wordsDescription valueForKey:@"AARDVARK"]);
    }
    
}

-(NSString*)printWordsStartedWith:(NSString*)word
{
    word = [word uppercaseString];
    self.inputWord = word;
    
    

    return [self equalWords];
}

-(NSString*)equalWords
{
    if (self.inputWord.length != 1 && [self.wordsDescription objectForKey:self.inputWord])
    {
        return self.inputWord;
    }
    
    NSMutableString* wordsToDisplay = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.wordsInDictionary.count; ++i)
    {
        if (self.wordsInDictionary[i].length >= self.inputWord.length && [[self.wordsInDictionary[i] substringWithRange:NSMakeRange(0, self.inputWord.length)] isEqual:self.inputWord])
        {
            [wordsToDisplay appendString:[NSString stringWithFormat:@"%@\n", self.wordsInDictionary[i]]];
        }
    }
    
    if (wordsToDisplay.length == 0)
    {
        self.inputWord = [self.inputWord substringWithRange:NSMakeRange(0, self.inputWord.length - 1)];
        
        return [self equalWords];
    }
    
    return [NSString stringWithString:wordsToDisplay];
}

@end

/*@interface Dictionary ()

@property (strong, nonatomic) NSString* word;

@property (strong, nonatomic) NSString* curLetter; //if user clear search bar - the letter have to be change

@property (strong, nonatomic) NSDictionary<NSString*, NSNumber*>* letterPositions;
@property (strong, nonatomic) NSMutableDictionary<NSString*, NSNumber*>* testLetterPositions;

@property (strong, nonatomic) NSMutableDictionary<NSString*, NSNumber*>* wordsWithCurLetter;

//@property (strong, nonatomic) NSMutableArray<NSString*>* wordsToDisplay;


@end

@implementation Dictionary

-(instancetype)initWithLanguage:(NSString*)language
{
    if ([super init])
    {
        self.language = language;
        self.wordsWithCurLetter = [[NSMutableDictionary alloc] init];
        
        self.testLetterPositions = [[NSMutableDictionary alloc] init];
        [self createPositionFile];
        //self.wordsToDisplay = [[NSMutableArray alloc] init];
        
        //[self loadPositions];
        //[self printPositions];
        
        //get index for letter positions from position file
        //get first words from dictionary - if is buffer - count for words
    }
    
    return self;
}

-(void)loadPositions
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"positions_%@.txt", self.language]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //check if have that file
    if (![fileManager fileExistsAtPath:fileName])
    {
        NSLog(@"no file");
        [self createPositionFile];
        [self printPositions];
        return;
    }
    
    self.letterPositions = [[NSDictionary alloc] initWithContentsOfFile:fileName];
}

//search words
-(void)dictionaryContent
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    
    //get current letter
    self.curLetter = [self.word substringWithRange:NSMakeRange(0, 1)];
    
    int position = [[self.letterPositions objectForKey:self.curLetter] intValue];
    
    fseek(file, position, SEEK_CUR);
    
    BOOL haveWordsWithCurLetter = YES;
    
    while (haveWordsWithCurLetter) //or no words
    {
        fgets(buffer, 1024, file);
        
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        position += line.length;
        
        haveWordsWithCurLetter = [self didHaveWord:line withPosition:position];
    }
    
    fclose(file);
}

-(BOOL)didHaveWord:(NSString*)line withPosition:(int)position //position in file
{
    if ([line containsString:@"@"])
    {
        NSString* wordInDictionary = [line componentsSeparatedByString:@"@"].lastObject;
        wordInDictionary = [wordInDictionary substringWithRange:NSMakeRange(0, wordInDictionary.length - 1)];
        
        if ([self.curLetter isEqual:[wordInDictionary substringWithRange:NSMakeRange(0, 1)]])
        {
            int positionInFile = position - (int)[line rangeOfString:@"@"].location;
            [self.wordsWithCurLetter setValue:[NSNumber numberWithInt:positionInFile] forKey:wordInDictionary];
            
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

-(NSString*)equalWordsStartedWith:(NSString*)word
{
    if (word.length != 1 && [self.wordsWithCurLetter objectForKey:word])
    {
        return word;
    }
    
    NSMutableString* wordsToDisplay = [[NSMutableString alloc] init];
    
    for (NSString* key in self.wordsWithCurLetter)
    {
        if (key.length >= word.length && [[key substringWithRange:NSMakeRange(0, word.length)] isEqual:word])
        {
            [wordsToDisplay appendString:[NSString stringWithFormat:@"%@\n", key]];
        }
    }
    
    if (wordsToDisplay.length == 0)
    {
        return [self equalWordsStartedWith:[word substringWithRange:NSMakeRange(0, word.length - 1)]];
    }
    
    return [NSString stringWithString:wordsToDisplay];
}

-(NSString*)printWordsStartedWith:(NSString*)word
{
    word = [word uppercaseString];
    self.word = word;
    
    //[self printPositions];
    
    if (self.curLetter == nil || ![self.curLetter isEqual:[self.word substringWithRange:NSMakeRange(0, 1)]])
    {
        [self dictionaryContent];
    }

    return [self equalWordsStartedWith:word];
}

-(void)printPositions
{
    NSLog(@"%@", self.letterPositions.allKeys);
    NSLog(@"%@", self.letterPositions.allValues);
    
    self.curLetter = [self.word substringWithRange:NSMakeRange(0, 1)];
    
    if ([self.letterPositions objectForKey:self.curLetter])
    {
        NSLog(@"have element %@", [self.letterPositions objectForKey:self.curLetter]);
    }
}

//get size of dictionary file
-(long)fileSize
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    fclose(file);
    
    return size;
}

//function for position file ------------------------------------------------------------------------------------
-(void)createPositionFile
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    long cnt = 0;
    
    while (fgets(buffer, 1024, file)) //line by line
    {
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        //cnt += line.length; //TODO: get position in file
        
        cnt = ftell(file) - 2;
        
        [self searchLetter:line andCnt:cnt];
    }
    
    fclose(file);
    
    [self testPosition];
    
    //save in file - dictionary letter-key, position-value
    //[self savePositionInFile];
}

-(void)testPosition
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    
    //for (int i = 65; i < 91; ++i)
    //{
        int position = [[self.testLetterPositions objectForKey:@"B"] intValue];
        
        fseek(file, position, SEEK_CUR);
        
        fgets(buffer, 1024, file); //or no words
        NSString* line = [NSString stringWithUTF8String:buffer];
            
        NSLog(@"%@\n", line);
    //}
    
    fclose(file);
}

-(void)savePositionInFile
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"positions_%@.txt", self.language]];
    
    [self.letterPositions writeToFile:fileName atomically:YES];
}

-(void)searchLetter:(NSString*)line andCnt:(long)cnt
{
    if ([line containsString:@"@"])
    {
        NSString* part = [line componentsSeparatedByString:@"@"].lastObject;
        
        if (part.length == 0)
        {
            return;
        }
        NSString* firstLetter = [part substringToIndex:1];
        
        if (self.curLetter == nil || ![self.curLetter isEqual:firstLetter]) //new letter
        {
            self.curLetter = firstLetter;
            //get position in line
            //int letterLocation = (int)[line rangeOfString:@"@"].location + 1;
            //int letterFileLocation = cnt - letterLocation - 1;
            
            [self.testLetterPositions setValue:[NSNumber numberWithLong:cnt] forKey:self.curLetter];
            
            NSLog(@"%@ %d\n", self.curLetter, cnt);
            
            NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
            
            NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
            
            FILE* file = fopen([fileRoot UTF8String], "r");
            char buffer[1024];
            
            int position = [[self.testLetterPositions objectForKey:self.curLetter] intValue];
            
            fseek(file, position, SEEK_CUR);
            
            fgets(buffer, 1024, file); //or no words
            NSString* line = [NSString stringWithUTF8String:buffer];
                
            NSLog(@"%@\n", line);
            
            fclose(file);
        }
        
    }
}*/

/*
 //@property (assign) int lastPrintedPosition;

 //words buffer
 //@property (strong, nonatomic) NSMutableDictionary<NSString*, NSNumber*>* wordsPartBuffer;
 //@property (strong, nonatomic) NSMutableArray<NSMutableDictionary<NSString*, NSNumber*>*>* previousWordsPartBufferStack;
 //last position of printed word
-(NSString*)printWordsStartedWith:(NSString*)word
{
    //TODO: if self.word.length > word.length return previous version
    word = [word uppercaseString];
    self.word = word;
    
    if (self.curLetter == nil)
    {
        self.curLetter = [self.word substringWithRange:NSMakeRange(0, 1)];
    }
    
    int position;
    
    if (self.wordsPartBuffer == nil)
    {
        position = (int)[self.letterPositions objectForKey:self.curLetter];
    }
    else
    {
        position = [self searchWordInBuffer]; //function to return position to start search
        
        if (position == -1)
        {
            return [self displayWords];
        }
        
        [self.previousWordsPartBufferStack addObject:self.wordsPartBuffer];
        [self.wordsPartBuffer removeAllObjects];
    }
    
    [self dictionaryContentWithPosition:position];
    
    return [self displayWords];
}

-(NSString*)displayWords
{
    NSMutableString* displayWords = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.wordsToDisplay.count; ++i)
    {
        [displayWords appendString:[NSString stringWithFormat:@"%@\n", self.wordsToDisplay[i]]];
    }
    
    return [NSString stringWithString:displayWords];
}

-(int)searchWordInBuffer
{
    if ([self.wordsPartBuffer objectForKey:self.word])
    {
        return (int)[self.wordsPartBuffer objectForKey:self.word];
    }
    
    return -1;
    //return -1 if buffer do not have that part of word
}

-(void)dictionaryContentWithPosition:(int)position
{
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    int cnt = position;
    
    //if wordsPartPosition is nil self.curLetter - check if wordsPartPosition have this word
    
    fseek(file, [self fileSize], position);
    
    while (self.wordsToDisplay.count != 100) //flag - finished with this part of word
    {
        fgets(buffer, 1024, file);
        
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        cnt += line.length;
        
        [self didFindWordInDictionary:line andCnt:cnt];
    }
    
    fclose(file);
}

-(BOOL)didFindWordInDictionary:(NSString*)line andCnt:(int)cnt
{
    if ([line containsString:@"@"])
    {
        NSString* wordInDictionary = [line componentsSeparatedByString:@"@"].lastObject;
        wordInDictionary = [wordInDictionary substringWithRange:NSMakeRange(0, wordInDictionary.length - 1)];
        
        //if part of word in dictionary is different from word - stop
        if (![[wordInDictionary substringWithRange:NSMakeRange(0, self.word.length)] isEqual:self.word])
        {
            return NO;
        }
        
        if (self.wordsToDisplay.count < 100)
        {
            [self.wordsToDisplay addObject:wordInDictionary];
        }
        else
        {
            self.lastPrintedPosition = cnt;
        }
        
        //if is new part - save cnt - if is finish return Yes
        NSString* partOfWordInDictionary = [wordInDictionary substringWithRange:NSMakeRange(0, self.word.length + 1)];
        
        
        if ([self.wordsPartBuffer objectForKey:partOfWordInDictionary] == nil)
        {
            //add new position
            //int letterLocation = (int)[line rangeOfString:@"@"].location + 1;
            int letterFileLocation = cnt - (int)[line rangeOfString:@"@"].location;//- 1;
            
            [self.wordsPartBuffer setValue:[NSNumber numberWithInt:letterFileLocation] forKey:partOfWordInDictionary];
            
        }
    }
    
    return YES;
}*/
