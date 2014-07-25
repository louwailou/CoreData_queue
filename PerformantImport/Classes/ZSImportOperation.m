//
//  ZSImportOperation.m
//  PerformantImport
//
//  Created by Marcus S. Zarra on 5/2/10.
//  Copyright 2010 Zarra Studios LLC. All rights reserved.
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "ZSImportOperation.h"
static NSString const * kMagicalRecordManagedObjectContextKey = @"MagicalRecord_NSManagedObjectContextForThreadKey";
static NSString const * kMagicalRecordManagedObjectContextCacheVersionKey = @"MagicalRecord_CacheVersionOfNSManagedObjectContextForThreadKey";
static volatile int32_t contextsCacheVersion = 0;

@implementation ZSImportOperation
@synthesize persistentStoreCoordinator;
@synthesize entriesToCreate;
@synthesize saveFrequency;
@synthesize runSpeed;

- (void)main
{
  ZAssert([self persistentStoreCoordinator], @"PSC is nil");
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
    //  输入源
  [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
  
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
  [moc setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
  
  NSError *error = nil;
  
  for (NSInteger index = 0; index < [self entriesToCreate]; ++index) {
    id object = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
    [object setValue:[NSString stringWithFormat:@"User %i", index] forKey:@"name"];
    [object setValue:[NSNumber numberWithInteger:(arc4random() % 99)] forKey:@"age"];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[self runSpeed]]];//0.25
      //NSLog(@"currentRunloop =%@",[[NSRunLoop currentRunLoop]description]);
    if (index % [self saveFrequency] != 0) continue;
    
    ZAssert([moc save:&error], @"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
    
    DLog(@"saving background context");
    //[moc reset];
    [pool drain], pool = nil;
      
      
      
//      if ([NSThread isMainThread])
//      {
//          NSLog(@"mainThread/....");
//      }
//      else
//      {
//          // contextsCacheVersion can change (atomically) at any time, so grab a copy to ensure that we always
//          // use the same value throughout the remainder of this method. We are OK with this method returning
//          // an outdated context if MR_clearNonMainThreadContextsCache is called from another thread while this
//          // method is being executed. This behavior is unrelated to our choice to use a counter for synchronization.
//          // We would have the same behavior if we used @synchronized() (or any other lock-based synchronization
//          // method) since MR_clearNonMainThreadContextsCache would have to wait until this method finished before
//          // it could acquire the mutex, resulting in us still returning an outdated context in that case as well.
//          int32_t targetCacheVersionForContext = contextsCacheVersion;
//          
//          NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//          NSManagedObjectContext *threadContext = [threadDict objectForKey:kMagicalRecordManagedObjectContextKey];
//          NSNumber *currentCacheVersionForContext = [threadDict objectForKey:kMagicalRecordManagedObjectContextCacheVersionKey];
//          NSAssert((threadContext && currentCacheVersionForContext) || (!threadContext && !currentCacheVersionForContext),
//                   @"The Magical Record keys should either both be present or neither be present, otherwise we're in an inconsistent state!");
//          if ((threadContext == nil) || (currentCacheVersionForContext == nil) || ((int32_t)[currentCacheVersionForContext integerValue] != targetCacheVersionForContext))
//          {
//              threadContext = moc;//[self MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
//              
//              [threadDict setObject:threadContext forKey:kMagicalRecordManagedObjectContextKey];
//              [threadDict setObject:[NSNumber numberWithInteger:targetCacheVersionForContext]
//                             forKey:kMagicalRecordManagedObjectContextCacheVersionKey];
//          }
//          
//          
//          NSLog(@"threadDic=%@",threadDict);
//
//      }
//      
 }
  
  ZAssert([moc save:&error], @"Error saving context on operation: %@\n%@", [error localizedDescription], [error userInfo]);
  
  [moc release], moc = nil;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kImportRoutineComplete object:self];
  
  [pool drain], pool = nil;
}


@end
