/* A game by Evan

 ISSUES:

			1.) sklley's position is only noted on touch down, need to loop through some how... cant use while loop... try per frame update?
		        perhaps change the code in the move methods scheduled to constantly update its position value so that other methods can see it...

		    2.) skelly moves twice as fast when the bg moves: find way to keep speed the same for both kinds of movement

			3.) if all else fails perhaps hold skelly in the center, play its walking animation, and move only the bg

			4.) size of the map: sprites are only able to be 4098 x 4098
			
			5.) SNOW: when moving the snow with bg on move in a scheduled method the system moves independently to the particles
 
			6.) SNOW: size of emitter itself, skelly can walk right out of emitter range



 SOLUTIONS:

			1.) use built in update method to do all updates: ran pre frame render

			2.)

			3.) yes, i think we shall stick with that for now

			4.) 

			5.) need to move as a group: set _snow.positionType to kCCPositionTypeGrouped

 TODO:

		1.) further improve movement, use solution 1 to implement the first proposed movement

		2.) recognize double taps for run - runing animation

		3.) set map bounds

		4.) bigger maps!!!!	--	larger than 4098 x 4098

		5.) efficiently render a repeating map bg FOREVER

		6.) christmas map!!!!
			a.) snow!!! - done. see the coco box method "letItSnowLetItSnow"
			b.) paralax
			c.) new pixles 
			d.) completely set up a bunch or difrent trees, rocks, shruberies &c &c within a pallate PSD

		7.) continuious updating, recognizable to runtime code (were talking like positions, speeds, hormone levels)

		8.) make particle system move with bg on move, maybe even the landing point to slide to the other side
*/
#import "HelloWorldLayer.h"
#import "definitions.h"

@interface HelloWorldLayer ()

//private properties:
@property (nonatomic, strong) CCSprite *bg;
@property (nonatomic, strong) CCSprite *skelly;
@property (nonatomic, strong) CCAction *idleAction;
@property (nonatomic, strong) CCAction *walkingAction;
@property (nonatomic, strong) CCParticleSnow *snow;

@end

@implementation HelloWorldLayer

//implements some methods:

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    if((self = [super init])){
		
		//some setup:
		zoomMultiplier = .8;
		
		//fall:
//		bgZoomAdjust = ((zoomMultiplier - 1) * 300) + 140;
//		skellyZoomAdjust = ((zoomMultiplier - 1) * 109) - 51;

		//winter:
		bgZoomAdjust = ((zoomMultiplier - 1) * 300) + 100;
		skellyZoomAdjust = ((zoomMultiplier - 1) * 109) - 70;
		
		bgOriginalPosition = self.bg.position.x/2;
		skellyPosition = bgOriginalPosition - self.bg.position.x;
		
		//est a global winSize var 
		_winSize = [[CCDirector sharedDirector] winSize];
		
		
		//
		// sets up all the animation crap:
		//
		
		// addSpriteFramesWithFile is a class method of CCSpriteFramehche (specicaly the "sharedSpriteFrameChache") that looks at the plist and looks
		// for a png of the same name and also will manage CCSpriteFrame objects for displaying
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"skellyAnim.plist"];
		
		
		// this introduces the actual png into the rendering pipeline and all individual sprites will be children of the
		// "spriteSheet" batch node
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"skellyAnim.png"];
		[self addChild:spriteSheet];
		
		
		// itterate through the frames declared in the plist and asign them to a mutable array
		
		// the array:
		NSMutableArray *idleFrames = [NSMutableArray array];
		
		// the itterarion:
		for (int i = 1; i < 5; i++) {
			[idleFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"skelly0%d.png", i]]];
		}
		
		
		// creates the CCAnimation for the idling skelly with the frames in the array "idleFrames",
		// 1 second between frames, loops forever
		CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames:idleFrames delay:0.15f];
		
		//walking frames
		NSMutableArray *walkingFrames = [NSMutableArray array];
		
		for (int i = 1; i < 5; i++) {
			[walkingFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"skellyWalk0%d.png", i]]];
		}
		
		//
		//adition of frames TBA:
		//
		
		//[walkingFrames addObject:
		 //[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"skellyWalk03.png"]];
		//[walkingFrames addObject:
		 //[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"skellyWalk02.png"]];
		
		
		//initial delay: 0.15f
		CCAnimation *walkingAnimation = [CCAnimation animationWithSpriteFrames:walkingFrames delay:0.15f];
		
		//
		// the rest of the runtime code
		//
		
		// makes a CGSize(width and height) called winSize from the shared CCDirectors winsize method(returns window Size)
		
		//CCSprite *bg = [CCSprite spriteWithFile:@"skellyWorldLarge.png"];
		
		
		//Fall:
		/*
		
		//the bg
		self.bg = [CCSprite spriteWithFile:@"skellyWorldExtraLarge.png"];
		[self addChild:self.bg z:0];
		self.bg.position = ccp(_winSize.width/2, (_winSize.height/2) + bgZoomAdjust);
		self.bg.scale = 1 * zoomMultiplier;
		
		*/
		
		
		self.bg = [CCSprite spriteWithFile:@"wonderChopOne.png"];
		[self addChild:self.bg z:0];
		self.bg.position = ccp(_winSize.width/2, (_winSize.height/2) + bgZoomAdjust);
		self.bg.scale = 1 * zoomMultiplier;		
		
		// sets the  CCSprite "skelly" established in the @property to a sprite with the frame name skelly01.png
		self.skelly = [CCSprite spriteWithSpriteFrameName:@"skelly01.png"];
		//positions the skelly to the middle of the screen
		self.skelly.position = ccp(_winSize.width/2, (_winSize.height/2) + skellyZoomAdjust);
		
		// sets the CCAction stated in the @property to an infinite, action with the animation defined in the CCAnimation section
		self.idleAction = [CCRepeatForever actionWithAction:
						   [CCAnimate actionWithAnimation:idleAnimation]];
		
		//initalizes walkingAction
		self.walkingAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkingAnimation]];
		
		// runs the method of the CCSprite "skelly" that runs an action: "self.idleAction" stated above --^
		[self.skelly runAction:self.idleAction];
		
		//properties of the skelly sprite
		self.skelly.scale = .9 * zoomMultiplier;
		self.skelly.opacity = 255;
		//etcetera
		
		//add the sprite skelly as child to its sprite sheet as requested by the batch node... dont work with zindex though...
		//[spriteSheet addChild:self.skelly];
		
		//ill just add it as a child to the layer 'self'
		[self addChild:self.skelly z:1];
		
		//touch enabled in the layer
		self.touchEnabled = YES;
		
		//let it snow:
		[self letItSnowLetItSnowLetItSnow];

	}
    return self;
}

//enables touches
- (void)registerWithTouchDispatcher{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:
	 self priority:0 swallowsTouches:YES];
}

//
// touchy methods:
//

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	//schedules the built in "update" method
	[self scheduleUpdate];
	
	// determine the touch location:
	// makes a CGPoint (x,y) called touchLocation and sets it to a coverted touch to node
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	//sets winSize jus like above:
	
	// stops current idle action:
	[self.skelly stopAction:self.idleAction];
	
	//starts walking Action
	[self.skelly runAction:self.walkingAction];
	
	//test for right or left
	if (touchLocation.x > _winSize.width/2) {
		CCLOG(@"RIGHT");
		
		//flip
		self.skelly.flipX = YES;
		
		//move the bg to simulate movement
		[self schedule:@selector(moveBgLeft:)];
		
	}else{
		CCLOG(@"LEFT");
		
		//flip
		self.skelly.flipX = NO;
		
		//move the bg to simulate movement
		[self schedule:@selector(moveBgRight:)];
	}
	
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	//end built in update method
	[self unscheduleUpdate];
	
	CCLOG(@"ENDED");
	
	//stops the scheduling and thus stops the motion
	[self unschedule:@selector(moveBgRight:)];
	[self unschedule:@selector(moveBgLeft:)];
	
	[self skellyMoveEnded];
}

/*
//ISSUES: zoom is uggy as fuck: its a glitchy and the values arent right... it kind of does its thing with ou the adjustments in position
//but still in needs work
 
 - (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
 //schedules the built in "update" method
 //	[self scheduleUpdate];
 
 // determine the touch location:
 // makes a CGPoint (x,y) called touchLocation and sets it to a coverted touch to node
 CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
 
 //test for up or down
 if (touchLocation.x > _winSize.height/2) {
 CCLOG(@"TOP");
 
 //move the bg to simulate movement
 [self schedule:@selector(zoomIn:)];
 
 }else{
 CCLOG(@"BOTTOM");
 
 //move the bg to simulate movement
 //		[self schedule:@selector(moveBgRight:)];
 }
 
 return YES;
 }
 
 - (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CCLOG(@"ENDED");

	[self unschedule:@selector(zoomIn:)];
	
}
 
 - (void)zoomIn:(ccTime)delta{
 
 //everything is multiplied by delta... dont know why
 
 //attempts to zoom in:
 zoomMultiplier += 1 * delta;
 
 //forces math to be redone:
 bgZoomAdjust = (((zoomMultiplier - 1) * 300) + 140) * delta;
 skellyZoomAdjust = (((zoomMultiplier - 1) * 109) - 51) * delta;
 
 //updates the scale:
 self.bg.scale = 1 * zoomMultiplier * delta;
 self.skelly.scale = .9 * zoomMultiplier * delta;
 
 //updates the adjustment:
 self.bg.position = ccp(self.bg.position.x, self.bg.position.y + (bgZoomAdjust * delta));
 self.skelly.position = ccp(self.skelly.position.x, self.skelly.position.y + (skellyZoomAdjust * delta));
 }
*///EXPERMENTAL ZOOMING METHODS
//

//
// non touchy methods
//

- (void)update:(ccTime)delta{
	
	//updates known skelly position
	skellyPosition = bgOriginalPosition - self.bg.position.x;
	CCLOG(@"Skelly X	:	%i", skellyPosition);
	
}

-(void)moveBgLeft:(ccTime)dt{
	// position * dt * zoomMultiplier is to keep speed constant with zoom
	self.bg.position = ccp(self.bg.position.x - (120*dt) * zoomMultiplier, self.bg.position.y);
	
	// for the particles:
	_snow.position = ccp(_snow.position.x - (120*dt) * zoomMultiplier, _snow.position.y);
}
 
-(void)moveBgRight:(ccTime)dt{
	// position * dt * zoomMultiplier is to keep speed constant with zoom
	self.bg.position = ccp(self.bg.position.x + (120*dt) * zoomMultiplier, self.bg.position.y);
	
	// for the particles:
	_snow.position = ccp(_snow.position.x + 120 * dt * zoomMultiplier, _snow.position.y);
}

//particles: snow:
-(void) letItSnowLetItSnowLetItSnow{
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	//
	// snow particles: uses predefined properties of (and is a) CCParticleSystemQuad
	//
	
	_snow = [[CCParticleSnow alloc] init];
	
	//
	// properties common to SYSTEM:
	//
	
	// emissionRate (a float). How many particle are emitted per second
	_snow.emissionRate = 10;
	
	// duration (a float). How many seconds does the particle system (different than the life property) lives.
	// Use kCCParticleDurationInfinity for infity.
	
	// blendFunc (a ccBlendFunc). The OpenGL blending function used for the system
	
	// positionType (a tCCPositionType).
	// Use kCCPositionTypeFree (default one) for moving particles freely.
	// use kCCPositionTypeGrouped to move them in a group.
	_snow.positionType = kCCPositionTypeGrouped;
	
	// texture (a CCTexture2D). The texture used for the particles
	_snow.texture = [[CCTextureCache sharedTextureCache] addImage:@"snowflake.png"];
	
	//
	// properties common to PARTICLES:
	//
	
	//position (CGPoint)
	_snow.position = ccp(winSize.width/2, winSize.height);
	
	//position variance (CGPoint)
	//_snow.posVar
	
	// speed (float)
	// arc4random() will return a maximum value of 0x100000000 (4294967296)...
	// modulo 20 ensures a range of 0 to 20...
	// adding 20 to the whole deal makes the range 20 - 40
	_snow.speed = 20 + (arc4random() % 20);
	
	//speed variance (float)
	_snow.speedVar = 5;
	
	// point to which shit falls
	_snow.gravity = CGPointMake(0, 0);
	
	// duration of entier SYSTEM not particles
	// kCCParticleDurationInfinity for infinite
	_snow.duration = kCCParticleDurationInfinity;
	
	//start size: 5 pixels
	_snow.startSize = 7;
	
	//start size variance: 2 pixles(?)
	_snow.startSizeVar = 2;
	
	//sets start and end size equal
	_snow.endSize = kCCParticleStartSizeEqualToEndSize;
	
	//end size: 100 pixles
	//_snow.endSize = 100;
	
	//end size variation: 4 pixles(?)
	//_snow.endSizeVar = 4;
	
	/* COLORS:
	 start color (a ccColor4F)
	 _snow.startColor
	 start color variation (a ccColor4F)
	 _snow.startColorVar
	 end color (a ccColor4F)
	 can set the opacity in the end to fade the particle
	 _snow.endColor
	 end color variation (a ccColor4F)
	 _snow.endColorVar
	 */
	
	/* Spins *only in CCParticleSystemQuad
	 _snow.startSpin
	 _snow.startSpinVar
	 _snow.endSpin
	 _snow.endSpinVar
	 */
	
	//life: 12 seconds
	_snow.life = 12;
	
	//life variation in seconds(?)
	_snow.lifeVar = 0.5;
	
	/* anlges:
	 _snow.angle: (a float). Starting degrees of the particle
	 _snow.angleVar
	 */
	
	//finish up and snow as a child to the layer(?)
	[self addChild:_snow];
}

- (void)skellyMoveEnded{
	//stops walking animation
	[self.skelly stopAction:self.walkingAction];
	
	// when skellyMoveEnded is called it sets the animation back to idling
	[self.skelly runAction:self.idleAction];
}
@end