//
//  definitions.h
//  skellyAnimation
//
//  Created by Evan Forletta on 11/15/13.
//  Copyright (c) 2013 Evan Forletta. All rights reserved.
//

#ifndef skellyAnimation_definitions_h
#define skellyAnimation_definitions_h


#define RAND_NUM(x) arc4random() % x
#define RAND_RANGE(low,high) (arc4random()%(high-low+1))+low

#define selfie self
#define WIN_SIZE [[CCDirector sharedDirector] winSize]

enum BFDirection {
	RIGHT = NO,
	LEFT = YES
	};

#endif
