//
//  RootViewController.m
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

#import "RootViewController.h"
#import "ZSImportOperation.h"

@interface RootViewController ()

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation RootViewController

- (void)dealloc 
{
  [operationQueue release], operationQueue = nil;
  [fetchedResultsController release], fetchedResultsController = nil;
  [managedObjectContext release], managedObjectContext = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  [self setTitle:@"Import Example"];
  //NSLog(@"currentRunloop =%@",[[NSRunLoop currentRunLoop]description]);
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(startImport:)];
  [[self navigationItem] setRightBarButtonItem:addButton];
  [addButton release], addButton = nil;
  
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:self action:@selector(aaaTapped2:)];
  [[self navigationItem] setLeftBarButtonItem:removeButton];
  [removeButton release], removeButton = nil;
  
  NSError *error = nil;
  ZAssert([[self fetchedResultsController] performFetch:&error], @"Error fetching: %@/%@", [error localizedDescription], [error userInfo]);
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableImportButton:) name:kImportRoutineComplete object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextChanged:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

///// test 1  begin
//  Runloop可以阻塞线程，等待其他线程执行后再执行
/*
 2014-07-25 12:02:07.694 PerformantImport[6918:607] Start a new thread.
 2014-07-25 12:02:07.697 PerformantImport[6918:607] Beginrunloop
 2014-07-25 12:02:07.697 PerformantImport[6918:312b] Enter newThreadProc.
 2014-07-25 12:02:07.698 PerformantImport[6918:312b] InnewThreadProc count = 0.
 2014-07-25 12:02:08.701 PerformantImport[6918:312b] InnewThreadProc count = 1.
 2014-07-25 12:02:09.707 PerformantImport[6918:312b] InnewThreadProc count = 2.
 2014-07-25 12:02:10.712 PerformantImport[6918:312b] InnewThreadProc count = 3.
 2014-07-25 12:02:11.718 PerformantImport[6918:312b] InnewThreadProc count = 4.
 2014-07-25 12:02:12.721 PerformantImport[6918:312b] InnewThreadProc count = 5.
 2014-07-25 12:02:13.727 PerformantImport[6918:312b] InnewThreadProc count = 6.
 2014-07-25 12:02:14.729 PerformantImport[6918:312b] InnewThreadProc count = 7.
 2014-07-25 12:02:15.733 PerformantImport[6918:312b] InnewThreadProc count = 8.
 2014-07-25 12:02:16.739 PerformantImport[6918:312b] InnewThreadProc count = 9.
 2014-07-25 12:02:17.745 PerformantImport[6918:312b] Exit newThreadProc.
  发生了触摸时间 点击了屏幕 才会输出一下的两句
 2014-07-25 12:02:28.178 PerformantImport[6918:607] Endrunloop.
 2014-07-25 12:02:28.178 PerformantImport[6918:607] OK

 他人评论：
 从调试打印信息可以看到，while循环后执行的语句会在很长时间后才被执行。因为，改变变量StopFlag的值，runloop对象根本不知道，runloop在这个时候未被唤醒。有其他事件在某个时点唤醒了主线程，这才结束了while循环，但延缓的时长总是不定的。。
 
 将代码稍微修改一下：
 
 [[NSRunLoopcurrentRunLoop] runMode:NSDefaultRunLoopMode
 
 beforeDate: [NSDatedateWithTimeIntervalSinceNow: 1]];
 
 缩短runloop的休眠时间，看起来解决了上面出现的问题。
 
 但这样会导致runloop被经常性的唤醒，违背了runloop的设计初衷。runloop的目的就死让你的线程在有工作的时候忙于工作，而没工作的时候处于休眠状态。
 
 http://blog.csdn.net/jjunjoe/article/details/8313016
 */
BOOL StopFlag =NO;


- (void)startOtherTest

{
    StopFlag =NO;
    
    NSLog(@"Start a new thread.");
    
    [NSThread detachNewThreadSelector: @selector(newThreadProc)
     
                            toTarget:self
     
                          withObject: nil];
    
    while (!StopFlag) {
        
        NSLog(@"Beginrunloop");
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
         
                                beforeDate: [NSDate distantFuture]];
        
        NSLog(@"Endrunloop.");// 在没有其他的输入源 (如，用户触摸事件，或者其他的输入源)的情况下 该句是不执行的
        
    }
    NSLog(@"OK");//同上
    
}

-(void)newThreadProc{
    
    NSLog(@"Enter newThreadProc.");

    for (int i=0; i<10; i++) {
        
        NSLog(@"InnewThreadProc count = %d.", i);
        
        sleep(1);
    }
    
    StopFlag =YES;
    
    NSLog(@"Exit newThreadProc.");
    
}
//// test 1  end

    //阻塞了主线程但是并没有阻塞UI，是因为 Mode的原因？？
      //   http://www.cnblogs.com/xwang/p/3547685.html
    /*
     在Windows时代，大家肯定对SendMessage，PostMessage，GetMessage有所了解，这些都是windows中的消息处理函数，那对应在ios中是什么呢，其实就是NSRunloop这个东西。在ios中，所有消息都会被添加到NSRunloop中，分为‘input source’跟'timer source'种，并在循环中检查是不是有事件需要发生，如果需要那么就调用相应的函数处理。
     
     我们在使用NSTimer的时候，可能会接触到runloop的概念，下面是一个简单的例子：
     
     复制代码
     1 - (void)viewDidLoad
     2 {
     3     [super viewDidLoad];
     4     // Do any additional setup after loading the view, typically from a nib.
     5     NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1
     6                                               target:self
     7                                             selector:@selector(printMessage:)
     8                                             userInfo:nil
     9                                              repeats:YES];
     10 }
     复制代码
     这个时候如果我们在界面上滚动一个scrollview，那么我们会发现在停止滚动前，控制台不会有任何输出，就好像scrollView在滚动的时候将timer暂停了一样，在查看相应文档后发现，这其实就是runloop的mode在做怪。
     runloop可以理解为cocoa下的一种消息循环机制，用来处理各种消息事件，我们在开发的时候并不需要手动去创建一个runloop，因为框架为我们创建了一个默认的runloop,通过[NSRunloop currentRunloop]我们可以得到一个当前线程下面对应的runloop对象，不过我们需要注意的是不同的runloop之间消息的通知方式。
     
     接着上面的话题，在开启一个NSTimer实质上是在当前的runloop中注册了一个新的事件源，而当scrollView滚动的时候，当前的MainRunLoop是处于UITrackingRunLoopMode的模式下，在这个模式下，是不会处理NSDefaultRunLoopMode的消息(因为RunLoop Mode不一样)，要想在scrollView滚动的同时也接受其它runloop的消息，我们需要改变两者之间的runloopmode.
     
     1 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
     简单的说就是NSTimer不会开启新的进程，只是在Runloop里注册了一下，Runloop每次loop时都会检测这个timer，看是否可以触发。当Runloop在A mode，而timer注册在B mode时就无法去检测这个timer，所以需要把NSTimer也注册到A mode，这样就可以被检测到。
     
     说到这里，在http异步通信的模块中也有可能碰到这样的问题，就是在向服务器异步获取图片数据通知主线程刷新tableView中的图片时，在tableView滚动没有停止或用户手指停留在屏幕上的时候，图片一直不会出来，可能背后也是这个runloop的mode在做怪，嘿嘿。
     */

- (void)contextChanged:(NSNotification*)notification
{
    
    NSLog(@" notification Object＝%@",[notification object]);
    NSManagedObjectContext* context=(NSManagedObjectContext*)[notification object];
    NSLog(@" insertObject＝%@",[context insertedObjects]);
    NSLog(@" updateObject＝%@",[context updatedObjects]);
    NSLog(@" deleteObject＝%@",[context deletedObjects]);
    
    
     NSLog(@" 22deleteObject＝%@",[self.managedObjectContext deletedObjects]);
    NSLog(@"222updateObject＝%@",[self.managedObjectContext updatedObjects]);
    NSLog(@"222 insertObject＝%@",[self.managedObjectContext insertedObjects]);
  if ([notification object] == [self managedObjectContext]) return;

  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(contextChanged:) withObject:notification waitUntilDone:YES];
    return;
  }
  
  [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
}

- (void)startImport:(id)sender
{
  [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
  [[[self navigationItem] leftBarButtonItem] setEnabled:NO];
  
  if (![self operationQueue]) {
    operationQueue = [[NSOperationQueue alloc] init];
  }
  
  ZSImportOperation *op = [[ZSImportOperation alloc] init];
  [op setPersistentStoreCoordinator:[[self managedObjectContext] persistentStoreCoordinator]];
  [op setRunSpeed:0.25];
  [op setEntriesToCreate:1000];
  [op setSaveFrequency:10];
  
  [operationQueue addOperation:op];
  [op release], op = nil;
    
    
    //使用queue来保证
    ZSImportOperation *op2 = [[ZSImportOperation alloc] init];
    [op2 setPersistentStoreCoordinator:[[self managedObjectContext] persistentStoreCoordinator]];
    [op2 setRunSpeed:0.25];
    [op2 setEntriesToCreate:1000];
    [op2 setSaveFrequency:10];
    
    [operationQueue addOperation:op2];
    [op2 release], op2 = nil;

}

- (void)enableImportButton:(id)sender
{
  [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
  [[[self navigationItem] leftBarButtonItem] setEnabled:YES];
}

- (void)resetMOC:(id)sender
{
  for (id object in [[self fetchedResultsController] fetchedObjects]) {
    [[self managedObjectContext] deleteObject:object];
  }
  NSError *error = nil;
  ZAssert([[self managedObjectContext] save:&error], @"Error saving context after delete: %@\n%@", [error localizedDescription], [error userInfo]);
}

#pragma mark -
#pragma mark Table view data source

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
{
  id object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  [[cell textLabel] setText:[object valueForKey:@"name"]];
  [[cell detailTextLabel] setText:[[object valueForKey:@"age"] stringValue]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{
  return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{
  id sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController 
{
  if (fetchedResultsController) return fetchedResultsController;

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  
  [fetchRequest setFetchBatchSize:20];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
  fetchedResultsController.delegate = self;
  
  [fetchRequest release];
  [sortDescriptor release];
  [sortDescriptors release];
  
  return fetchedResultsController;
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller 
{
  [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath 
{
  
  UITableView *tableView = [self tableView];
  
  switch (type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller 
{
  [[self tableView] endUpdates];
}

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize operationQueue;

@end