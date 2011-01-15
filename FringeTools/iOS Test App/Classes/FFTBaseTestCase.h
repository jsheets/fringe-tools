//
//  FFTBaseTestCase.h
//  FringeTools-iOS
//
//  Created by John Sheets on 1/14/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

@interface FFTBaseTestCase : GHTestCase
{

}

- (void)assertString:(NSString *)string containsText:(NSString *)fragment description:(NSString *)description;
- (void)assertString:(NSString *)string doesNotContainText:(NSString *)fragment description:(NSString *)description;

- (void)assertArray:(NSArray *)array hasCount:(NSInteger)count description:(NSString *)description;
- (void)assertArray:(NSArray *)array containsObject:(id)object atIndex:(NSInteger)index description:(NSString *)description;
- (void)assertArray:(NSArray *)array hasOnlyClass:(Class)elementClass description:(NSString *)description;

- (NSString *)tempFile;
- (void)assertFile:(NSString *)filePath exists:(BOOL)fileExists description:(NSString *)description;
- (void)assertFile:(NSString *)filePath contains:(BOOL)shouldContain searchText:(NSString *)text description:(NSString *)description;

- (NSURL *)urlForResource:(NSString *)resourceName extension:(NSString *)extension;
- (NSData *)loadResource:(NSString *)resourceName extension:(NSString *)extension;
- (NSString *)loadStringResource:(NSString *)resourceName extension:(NSString *)extension;

@end
