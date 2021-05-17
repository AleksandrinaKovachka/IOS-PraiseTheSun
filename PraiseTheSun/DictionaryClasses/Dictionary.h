//
//  Dictionary.h
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dictionary : NSObject

//one letter
@property (readonly) char letter;

//init with this one letter - initialize array with index from file
-(instancetype)initWithLetter:(char)letter;

//function to search by part of word - return words starting with this part - if user push on word ?
-(NSString*)dictionaryContentStartedWith:(NSString*)partOfWord;

//to create position file
-(void)createPositionFile;

@end

NS_ASSUME_NONNULL_END
