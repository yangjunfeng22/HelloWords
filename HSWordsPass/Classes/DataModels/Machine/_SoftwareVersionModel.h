// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SoftwareVersionModel.h instead.

#import <CoreData/CoreData.h>


extern const struct SoftwareVersionModelAttributes {
	__unsafe_unretained NSString *dbVersion;
	__unsafe_unretained NSString *launched;
	__unsafe_unretained NSString *version;
} SoftwareVersionModelAttributes;

extern const struct SoftwareVersionModelRelationships {
} SoftwareVersionModelRelationships;

extern const struct SoftwareVersionModelFetchedProperties {
} SoftwareVersionModelFetchedProperties;






@interface SoftwareVersionModelID : NSManagedObjectID {}
@end

@interface _SoftwareVersionModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SoftwareVersionModelID*)objectID;





@property (nonatomic, strong) NSString* dbVersion;



//- (BOOL)validateDbVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* launched;



@property BOOL launchedValue;
- (BOOL)launchedValue;
- (void)setLaunchedValue:(BOOL)value_;

//- (BOOL)validateLaunched:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* version;



//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;






@end

@interface _SoftwareVersionModel (CoreDataGeneratedAccessors)

@end

@interface _SoftwareVersionModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDbVersion;
- (void)setPrimitiveDbVersion:(NSString*)value;




- (NSNumber*)primitiveLaunched;
- (void)setPrimitiveLaunched:(NSNumber*)value;

- (BOOL)primitiveLaunchedValue;
- (void)setPrimitiveLaunchedValue:(BOOL)value_;




- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;




@end
