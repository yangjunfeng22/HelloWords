// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointProgressModel.h instead.

#import <CoreData/CoreData.h>


extern const struct CheckPointProgressModelAttributes {
	__unsafe_unretained NSString *bID;
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *progress;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *uID;
	__unsafe_unretained NSString *version;
} CheckPointProgressModelAttributes;

extern const struct CheckPointProgressModelRelationships {
} CheckPointProgressModelRelationships;

extern const struct CheckPointProgressModelFetchedProperties {
} CheckPointProgressModelFetchedProperties;









@interface CheckPointProgressModelID : NSManagedObjectID {}
@end

@interface _CheckPointProgressModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CheckPointProgressModelID*)objectID;





@property (nonatomic, strong) NSString* bID;



//- (BOOL)validateBID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cpID;



//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* progress;



@property float progressValue;
- (float)progressValue;
- (void)setProgressValue:(float)value_;

//- (BOOL)validateProgress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uID;



//- (BOOL)validateUID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* version;



//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;






@end

@interface _CheckPointProgressModel (CoreDataGeneratedAccessors)

@end

@interface _CheckPointProgressModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBID;
- (void)setPrimitiveBID:(NSString*)value;




- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (float)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(float)value_;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSString*)primitiveUID;
- (void)setPrimitiveUID:(NSString*)value;




- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;




@end
