//
//  PerformantImportAppDelegate.m
//  PerformantImport
//
//  Created by Marcus S. Zarra on 5/2/10.
//  Copyright Zarra Studios LLC 2010. All rights reserved.
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

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate (PrivateCoreDataStack)

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation AppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions 
{
  id rootViewController = [navigationController topViewController];
  [rootViewController setManagedObjectContext:[self managedObjectContext]];
  
  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application 
{
  NSError *error = nil;
  if (!managedObjectContext) return;
  if (![managedObjectContext hasChanges]) return;
  if ([managedObjectContext save:&error]) return;
  
  ALog(@"Save failed on exit: %@\n%@", [error localizedDescription], [error userInfo]);
}


#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext*) managedObjectContext 
{
    
    
  if (managedObjectContext) return managedObjectContext;
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  ZAssert(coordinator, @"Coordinator is nil");
   
    
  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator: coordinator];
    NSManagedObjectContextConcurrencyType type=[managedObjectContext  concurrencyType];
    if ( type==NSConfinementConcurrencyType) {
        
        NSLog(@" confinment  concurrencyType=%d",[managedObjectContext concurrencyType]);
    }else if(type==NSPrivateQueueConcurrencyType){
        NSLog(@" private concurrencyType=%d",[managedObjectContext concurrencyType]);
    }else if (type==NSMainQueueConcurrencyType){
        NSLog(@" mian concurrencyType=%d",[managedObjectContext concurrencyType]);
    }
    
  return managedObjectContext;
}

- (NSManagedObjectModel*)managedObjectModel 
{
  if (managedObjectModel) return managedObjectModel;

  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  ZAssert(managedObjectModel, @"MOM is nil");
  return managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator 
{
  if (persistentStoreCoordinator) return persistentStoreCoordinator;
  
  NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"PerformantImport.sqlite"]];
  
  NSError *error = nil;
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  ZAssert([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error], @"Error adding persistent store: %@/n%@", [error localizedDescription], [error userInfo]);
  
  return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

- (NSString*)applicationDocumentsDirectory 
{
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@synthesize window;
@synthesize navigationController;

@end
