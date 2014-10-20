// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceModel.m instead.

#import "_SentenceModel.h"

const struct SentenceModelAttributes SentenceModelAttributes = {
	.audio = @"audio",
	.chinese = @"chinese",
	.pinyin = @"pinyin",
	.sID = @"sID",
	.tAudio = @"tAudio",
};

const struct SentenceModelRelationships SentenceModelRelationships = {
};

const struct SentenceModelFetchedProperties SentenceModelFetchedProperties = {
};

@implementation SentenceModelID
@end

@implementation _SentenceModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SentenceModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

- (SentenceModelID*)objectID {
	return (SentenceModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic audio;






@dynamic chinese;






@dynamic pinyin;






@dynamic sID;






@dynamic tAudio;











@end
