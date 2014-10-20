// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceModel.h instead.

#import <CoreData/CoreData.h>


extern const struct SentenceModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *pinyin;
	__unsafe_unretained NSString *sID;
	__unsafe_unretained NSString *tAudio;
} SentenceModelAttributes;

extern const struct SentenceModelRelationships {
} SentenceModelRelationships;

extern const struct SentenceModelFetchedProperties {
} SentenceModelFetchedProperties;








@interface SentenceModelID : NSManagedObjectID {}
@end

@interface _SentenceModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SentenceModelID*)objectID;





@property (nonatomic, strong) NSString* audio;



//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* chinese;



//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pinyin;



//- (BOOL)validatePinyin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sID;



//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tAudio;



//- (BOOL)validateTAudio:(id*)value_ error:(NSError**)error_;






@end

@interface _SentenceModel (CoreDataGeneratedAccessors)

@end

@interface _SentenceModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;




- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;




- (NSString*)primitivePinyin;
- (void)setPrimitivePinyin:(NSString*)value;




- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;




- (NSString*)primitiveTAudio;
- (void)setPrimitiveTAudio:(NSString*)value;




@end
