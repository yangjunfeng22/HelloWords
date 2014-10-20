//
//  HSFileManager.m
//  HSChildrenLearnCard
//
//  Created by yang on 13-9-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSFileManager.h"
#import "Constants.h"

@implementation HSFileManager

+ (NSString *)documetPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDir = [paths objectAtIndex:0];
    return libraryDir;
}

+ (NSString *)BundleResourcePath
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return resourcePath;
}

+ (NSArray *)allXMLFilesInBundleDirectory:(NSString *)directory
{
    NSArray *arrPaths = [[NSBundle mainBundle] pathsForResourcesOfType:XML_EXTENSION inDirectory:directory];
    return arrPaths;
}

+ (NSString *)xmlFilePathInBundleDirectory:(NSString *)directory fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", directory, fileName, XML_EXTENSION];
    NSString *path = [[self BundleResourcePath] stringByAppendingPathComponent:filePath];
    return path;
}

+ (NSString *)xmlFilePathInBundleDirectoryWithFileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@.%@", fileName, XML_EXTENSION];
    NSString *path = [[self BundleResourcePath] stringByAppendingPathComponent:filePath];
    return path;
}

+ (void)deleXmlFileWithFileName:(NSString *)fileName
{
    NSString *path = [self xmlFilePathInBundleDirectoryWithFileName:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end
