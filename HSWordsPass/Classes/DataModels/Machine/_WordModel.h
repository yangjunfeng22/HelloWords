// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordModel.h instead.

#import <CoreData/CoreData.h>


extern const struct WordModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *pinyin;
	__unsafe_unretained NSString *property;
	__unsafe_unretained NSString *tAudio;
	__unsafe_unretained NSString *wID;
} WordModelAttributes;

extern const struct WordModelRelationships {
	__unsafe_unretained NSString *wordCpShip;
} WordModelRelationships;

extern const struct WordModelFetchedProperties {
	__unsafe_unretained NSString *wordCheckpoint;
} WordModelFetchedProperties;

@class CheckPoint_WordModel;









@interface WordModelID : NSManagedObjectID {}
@end

@interface _WordModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordModelID*)objectID;





@property (nonatomic, strong) NSString* audio;



//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* chinese;



//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picture;



//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pinyin;



//- (BOOL)validatePinyin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* property;



//- (BOOL)validateProperty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tAudio;



//- (BOOL)validateTAudio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CheckPoint_WordModel *wordCpShip;

//- (BOOL)validateWordCpShip:(id*)value_ error:(NSError**)error_;




@property (nonatomic, readonly) NSArray *wordCheckpoint;


@end

@interface _WordModel (CoreDataGeneratedAccessors)

@end

@interface _WordModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;




- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;




- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;




- (NSString*)primitivePinyin;
- (void)setPrimitivePinyin:(NSString*)value;




- (NSString*)primitiveProperty;
- (void)setPrimitiveProperty:(NSString*)value;




- (NSString*)primitiveTAudio;
- (void)setPrimitiveTAudio:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;





- (CheckPoint_WordModel*)primitiveWordCpShip;
- (void)setPrimitiveWordCpShip:(CheckPoint_WordModel*)value;


@end
