//
//  Dictionary.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import "Dictionary.h"

@interface Dictionary ()

@property (assign) char letter;

//array with positions
//@property (strong, nonatomic) NSMutableArray<NSNumber*>* positionsArray;
@property (strong, nonatomic) NSString* curLetter;
@property (strong, nonatomic) NSMutableDictionary<NSString*, NSNumber*>* letterPositions;

//maybe array with part of words
@property (strong, nonatomic) NSMutableString* wordsBuffer;

//current position in dictionary file


@end

@implementation Dictionary

-(instancetype)initWithLanguage:(NSString*)language andLetter:(char)letter
{
    if ([super init])
    {
        self.language = language;
        self.letter = letter;
        [self loadPositions];
        [self printPositions];
        
        
        //get info for positions from file
        
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
    
    self.letterPositions = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
}

-(void)printPositions
{
    NSLog(@"%@", self.letterPositions.allKeys);
    NSLog(@"%@", self.letterPositions.allValues);
}

//get size of dictionary file



-(void)createPositionFile
{
    self.letterPositions = [[NSMutableDictionary alloc] init];
    self.curLetter = @"B";
    
    NSString* otherLanguage = [self.language isEqual:@"en"] ? @"bg" : @"en";
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", self.language, otherLanguage] ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    int cnt = 0;
    
    //fseek(file, length, 2);
    
    while (fgets(buffer, 1024, file)) //line by line
    {
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        cnt += line.length;
        
        [self searchLetter:line andCnt:cnt];
    }
    
    fclose(file);
    
    //save in file - dictionary letter-key, position-value
    [self savePositionInFile];
}

-(void)savePositionInFile
{
    /*NSMutableString* positions = [[NSMutableString alloc] init];
    int cnt = 0;
    
    for (int i = 0; i < self.positionsArray.count; ++i)
    {
        [positions appendString:[NSString stringWithFormat:@"%c %@\n", 'A' + cnt, self.positionsArray[i]]];
        ++cnt;
    }
    
    NSString* pos = [NSString stringWithString:positions];
    
    NSLog(@"%@", pos);
    
    [[NSFileManager defaultManager] createFileAtPath:@"/Users/a-teamintern/Projects/GitHub/IOS-PraiseTheSun/PraiseTheSun/Resources/position_en.txt" contents:nil attributes:nil];
    
    [pos writeToFile:@"/Users/a-teamintern/Projects/GitHub/IOS-PraiseTheSun/PraiseTheSun/Resources/position_en.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];*/
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"positions_%@.txt", self.language]];
    
    [self.letterPositions writeToFile:fileName atomically:YES];
}

-(void)searchLetter:(NSString*)line andCnt:(int)cnt
{
    if ([line containsString:@"@"])
    {
        NSString* part = [line componentsSeparatedByString:@"@"].lastObject;
        
        if (part.length == 0)
        {
            return;
        }
        NSString* firstLetter = [part substringToIndex:1];
        
        if (![self.curLetter isEqual:firstLetter]) //new letter
        {
            self.curLetter = firstLetter;
            //get position in line
            int letterLocation = (int)[line rangeOfString:@"@"].location + 1;
            int letterFileLocation = cnt - letterLocation - 1;
            
            [self.letterPositions setValue:[NSNumber numberWithInt:letterFileLocation] forKey:self.curLetter];
            
            NSLog(@"%@", self.curLetter);
        }
        
    }
}


@end
