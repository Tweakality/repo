@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Respring interface
@interface FBSystemService : NSObject
 +(id)sharedInstance;
 -(void)exitAndRelaunch:(BOOL)arg1;
@end
//end of respring interface

//preference stuff
static NSString *nsDomainString = @"com.tweakality.homebarbegone";
static NSString *nsNotificationString = @"com.tweakality.homebarbegone/preferences.changed";
static BOOL enabled;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (n)? [n boolValue]:YES;
}
//end of preference stuff

//respring action
static void respringAction() {
     [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
 }
//end of respring action

//logo's constructor
%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respringAction, CFSTR("com.tweakality.homebarbegone-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
//end of logo's constructor

//hide "swipe to unlock" text AND hide homebar
%hook SBDashBoardTeachableMomentsContainerView //LockScreen text and homebar view
-(void)layoutSubviews {
if (enabled){
[self setHidden:YES];//the good stuff
} else {
%orig();
}
}
%end
//hide homebar inside apps
%hook SBHomeGrabberRotationView //Inside Apps homebar view
-(void)layoutSubviews {
if (enabled){
[self setHidden:YES];//the good stuff
} else {
%orig();
}
}
%end
//hide homebar inside apps and in control center.
%hook SBHomeGrabberView //Inside Apps and Control Center homebar view
-(void)setHidden:(BOOL)arg1 forReason:(id)arg2 withAnimationSettings:(id)arg3{
if (enabled){
 %orig(true, arg2, arg3);//the good stuff
} else {
 %orig(arg1, arg2, arg3);
}
}
%end
