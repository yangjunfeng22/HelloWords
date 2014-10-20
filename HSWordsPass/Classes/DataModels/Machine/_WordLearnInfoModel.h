// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordLearnInfoModel.h instead.

#import <CoreData/CoreData.h>


extern const struct WordLearnInfoModelAttributes {
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *rights;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *sync;
	__unsafe_unretained NSString *uID;
	__unsafe_unretained NSString *wID;
	__unsafe_unretained NSString *wrongs;
} WordLearnInfoModelAttributes;

extern const struct WordLearnInfoModelRelationships {
} WordLearnInfoModelRelationships;

extern const struct WordLearnInfoModelFetchedProperties {
} WordLearnInfoModelFetchedProperties;










@interface WordLearnInfoModelID : NSManagedObjectID {}
@end

@interface _WordLearnInfoModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordLearnInfoModelID*)objectID;





@property (nonatomic, strong) NSString* cpID;



//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rights;



@property int32_t rightsValue;
- (int32_t)rightsValue;
- (void)setRightsValue:(int32_t)value_;

//- (BOOL)validateRights:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sync;



@property int32_t syncValue;
- (int32_t)syncValue;
- (void)setSyncValue:(int32_t)value_;

//- (BOOL)validateSync:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uID;



//- (BOOL)validateUID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* wrongs;



@property int32_t wrongsValue;
- (int32_t)wrongsValue;
- (void)setWrongsValue:(int32_t)value_;

//- (BOOL)validateWrongs:(id*)value_ error:(NSError**)error_;






@end

@interface _WordLearnInfoModel (CoreDataGeneratedAccessors)

@end

@interface _WordLearnInfoModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;




- (NSNumber*)primitiveRights;
- (void)setPrimitiveRights:(NSNumber*)value;

- (int32_t)primitiveRightsValue;
- (void)setPrimitiveRightsValue:(int32_t)value_;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSNumber*)primitiveSync;
- (void)setPrimitiveSync:(NSNumber*)value;

- (int32_t)primitiveSyncValue;
- (void)setPrimitiveSyncValue:(int32_t)value_;




- (NSString*)primitiveUID;
- (void)setPrimitiveUID:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;




- (NSNumber*)primitiveWrongs;
- (void)setPrimitiveWrongs:(NSNumber*)value;

- (int32_t)primitiveWrongsValue;
- (void)setPrimitiveWrongsValue:(int32_t)value_;




@end
