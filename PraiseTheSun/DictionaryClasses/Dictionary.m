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
@property (strong, nonatomic) NSMutableArray<NSNumber*>* positionsArray;

//maybe array with part of words
@property (strong, nonatomic) NSMutableString* wordsBuffer;

@end

@implementation Dictionary

-(instancetype)initWithLetter:(char)letter
{
    if ([super init])
    {
        self.letter = letter;
        
        //get info for positions from file
        
        //get first words from dictionary - if is buffer - count for words
    }
    
    return self;
}

-(void)createPositionFile
{
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:@"en_bg" ofType:@"txt"];
    
    FILE* file = fopen([fileRoot UTF8String], "r");
    char buffer[1024];
    int cnt = 0;
    
    //fseek(file, length, 2);
    
    while (fgets(buffer, 1024, file)) //line by line
    {
        NSString* line = [NSString stringWithUTF8String:buffer];
        
        cnt += line.length;
        
        //NSLog(@"%@", line);
        
        [self searchLetter:line andCnt:cnt];
    }
}

-(void)searchLetter:(NSString*)line andCnt:(int)cnt
{
    if ([line containsString:@"@"])
    {
        NSString* part = [line componentsSeparatedByString:@"@"].lastObject;
        
        if (part.length == 2)
        {
            //get position in line
            int location = (int)[line rangeOfString:@"@"].location + 1;
            int cntOfLetter = cnt - location;
            
            [self.positionsArray addObject:[NSNumber numberWithInt:cntOfLetter]];
            
            NSLog(@"%@", part);
        }
        
    }
}


@end
