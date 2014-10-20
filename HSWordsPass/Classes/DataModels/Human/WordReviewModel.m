#import "WordReviewModel.h"
#import "WordDAL.h"
#import "WordNet.h"

@interface WordReviewModel ()

// Private interface goes here.

@end


@implementation WordReviewModel
@dynamic word;

- (WordModel *)word
{
     WordModel *model = [WordDAL queryWordWithWordID:self.wID];
    return model;
}

@end
