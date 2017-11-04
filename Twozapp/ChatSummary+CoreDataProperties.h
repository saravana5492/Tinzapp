//
//  ChatSummary+CoreDataProperties.h
//  Twozapp
//
//  Created by Dipin on 27/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatSummary.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatSummary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *datetime;
@property (nullable, nonatomic, retain) NSString *friend_id;
@property (nullable, nonatomic, retain) NSData *imagedata;
@property (nullable, nonatomic, retain) NSString *imageurl;
@property (nullable, nonatomic, retain) NSString *lastmessage;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Chat *> *chats;

@end

@interface ChatSummary (CoreDataGeneratedAccessors)

- (void)addChatsObject:(Chat *)value;
- (void)removeChatsObject:(Chat *)value;
- (void)addChats:(NSSet<Chat *> *)values;
- (void)removeChats:(NSSet<Chat *> *)values;

@end

NS_ASSUME_NONNULL_END
