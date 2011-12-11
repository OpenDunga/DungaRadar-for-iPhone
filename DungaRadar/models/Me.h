//
//  Me.h
//  DungaRadar
//
//  Created by  on 11/12/12.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "DungaMember.h"

@interface Me : DungaMember

+ (id)sharedMe;
- (BOOL)commit;

@end
