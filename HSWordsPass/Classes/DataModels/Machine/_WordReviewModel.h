// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordReviewModel.h instead.

#import <CoreData/CoreData.h>


extern const struct WordReviewModelAttributes {
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *created;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *uID;
	__unsafe_unretained NSString *wID;
} WordReviewModelAttributes;

extern const struct WordReviewModelRelationships {
} WordReviewModelRelationships;

extern const struct WordReviewModelFetchedProperties {
} WordReviewModelFetchedProperties;








@interface WordReviewModelID : NSManagedObjectID {}
@end

@interface _WordReviewModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordReviewModelID*)objectID;





@property (nonatomic, strong) NSString* cpID;



//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* created;



@property int32_t createdValue;
- (int32_t)createdValue;
- (void)setCreatedValue:(int32_t)value_;

//- (BOOL)validateCreated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uID;



//- (BOOL)validateUID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wID;



//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;






@end

@interface _WordReviewModel (CoreDataGeneratedAccessors)

@end

@interface _WordReviewModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;




- (NSNumber*)primitiveCreated;
- (void)setPrimitiveCreated:(NSNumber*)value;

- (int32_t)primitiveCreatedValue;
- (void)setPrimitiveCreatedValue:(int32_t)value_;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSString*)primitiveUID;
- (void)setPrimitiveUID:(NSString*)value;




- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;




@end
