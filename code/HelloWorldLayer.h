//
//  HelloWorldLayer.h
//  skellyAnimation
//
//  Created by Evan Forletta on 11/11/13.
//  Copyright Evan Forletta 2013. All rights reserved.
//

#import "cocos2d.h"
#import "definitions.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{	
	float zoomMultiplier;
	int bgZoomAdjust;
	int skellyZoomAdjust;
	int skellyPosition;
	int bgOriginalPosition;
}

@property (nonatomic, strong) CCSprite *bg;
@property () CGSize winSize;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) skellyMoveEnded;

+(void) moveBgLeftPre;
+(void) moveBgRightPre;

// EXPERMENTAL ZOOM METHODS: 
// -(void) zoomIn:(ccTime)delta;

@end
