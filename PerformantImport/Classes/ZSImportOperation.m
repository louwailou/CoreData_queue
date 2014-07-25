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

@implementation ZSImportOperation
@synthesize persistentStoreCoordinator;
@synthesize entriesToCreate;
@synthesize saveFrequency;
@synthesize runSpeed;

- (void)main
{
  ZAssert([self persistentStoreCoordinator], @"PSC is nil");
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
    //  输入源  如果不添加的话就不会得到runloop的监听，所以就不会处理该输入源   runloop 是针对该线程的哦哦哦哦哦
    
    /*传递异步事件，事件来源取决于输入源的种类：基于端口的输入源和自定义输入源。基于端口的输入源监听程序相应的端口。自定义输入源则监听自定义的事件源。
    
    run loop并不关心输入源的是哪种种类。系统会实现两种输入源供你使用。两类输入源的区别在于如何显示：基于端口的输入源由内核自动发送，而自定义的则需要人工从其他线程发送。当你创建输入源，你需要将其分配给run loop中的一个或多个模式。
    
    1、基于端口的输入源
    
    系统支持使用端口相关的对象和函数来创建的基于端口的源。
    
    在Cocoa里，你不需要直接创建输入源。你只要简单的创建端口对象，并使用NSPort的方法把该端口添加到run
    loop。端口对象会自己处理创建和配置输入源。
    
    在Core Foundation，你必须人工创建端口和它的run loop源。
    
    在两种情况下，你都可以使用端口相关的函数（CFMachPortRef，CFMessagePortRef，CFSocketRef）来创建合适的对象。
    */
//port 对象 自动配置输入源 因此有了输入源并添加到相应的Mode中，就开始监听，如果在指定的时间内没有输入源就休眠(也就是阻塞当前的线程一直监听看看有没有事件的发生，如果没有就休眠，取消阻塞当前的线程)
  [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
 
    
    /*  
      注销上述语句后的结果  defaultMode
     
     currentRunloop =<CFRunLoop 0x8f38580 [0x2116ec8]>{wakeup port = 0x4203, stopped = false, ignoreWakeUps = true,
     current mode = (none),
     common modes = <CFBasicHash 0x8f37c10 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFString 0x21130a4 [0x2116ec8]>{contents = "kCFRunLoopDefaultMode"}
     }
     ,
     common mode items = (null),
     modes = <CFBasicHash 0x8f01b40 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFRunLoopMode 0x8f38650 [0x2116ec8]>{name = kCFRunLoopDefaultMode, port set = 0x4403, timer port = 0x4503,
     sources0 = (null),
     sources1 = (null),
     observers = (null),
     timers = (null),
     currently 427966240 (44691443444570) / soft deadline in: 1.84466994e+10 sec (@ 0) / hard deadline in: 1.84466994e+10 sec (@ 0)
     },
     
     }
     }

     
     
     // 不住消的结果
     
     currentRunloop =<CFRunLoop 0x8e5a640 [0x2116ec8]>{wakeup port = 0x3b07, stopped = false, ignoreWakeUps = true,
     current mode = (none),
     common modes = <CFBasicHash 0x8e46670 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFString 0x21130a4 [0x2116ec8]>{contents = "kCFRunLoopDefaultMode"}
     }
     ,
     common mode items = <CFBasicHash 0x8d44c10 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFRunLoopSource 0x8d3c110 [0x2116ec8]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0xaa33590 [0x2116ec8]>{valid = Yes, port = 3d03, source = 0x8d3c110, callout = __NSFireMachPort (0xaa008), context = <CFMachPort context 0xaa339d0>}}
     }
     ,
     modes = <CFBasicHash 0x8e25cf0 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFRunLoopMode 0x8e08740 [0x2116ec8]>{name = kCFRunLoopDefaultMode, port set = 0x3a07, timer port = 0x3c03,
     sources0 = <CFBasicHash 0x8d3bf80 [0x2116ec8]>{type = mutable set, count = 0,
     entries =>
     }
     ,
     sources1 = <CFBasicHash 0x8d0a7d0 [0x2116ec8]>{type = mutable set, count = 1,
     entries =>
     1 : <CFRunLoopSource 0x8d3c110 [0x2116ec8]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0xaa33590 [0x2116ec8]>{valid = Yes, port = 3d03, source = 0x8d3c110, callout = __NSFireMachPort (0xaa008), context = <CFMachPort context 0xaa339d0>}}
     }
     ,
     observers = (null),
     timers = (null),
     currently 427966427 (44878277930165) / soft deadline in: 1.84466992e+10 sec (@ 0) / hard deadline in: 1.84466992e+10 sec (@ 0)
     },
     
     }
     }

     */
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
  [moc setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
  
  NSError *error = nil;
  
  for (NSInteger index = 0; index < [self entriesToCreate]; ++index) {
    id object = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
    [object setValue:[NSString stringWithFormat:@"User %i", index] forKey:@"name"];
    [object setValue:[NSNumber numberWithInteger:(arc4random() % 99)] forKey:@"age"];
    
    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[self runSpeed]]];//0.25
      [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode  beforeDate:[NSDate dateWithTimeIntervalSinceNow:[self runSpeed]]];
      // 比较结论都一样， 上述没有添加source 的话，是不会
      NSLog(@" runloop....... index=%d",index);
      NSLog(@"currentRunloop =%@",[[NSRunLoop currentRunLoop]description]);
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
