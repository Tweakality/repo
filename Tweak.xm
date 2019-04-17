@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface FBSystemService : NSObject
 +(id)sharedInstance;
 -(void)exitAndRelaunch:(BOOL)arg1;
@end

static NSString *nsDomainString = @"com.tweakality.homebarbegone";
static NSString *nsNotificationString = @"com.tweakality.homebarbegone/preferences.changed";
static BOOL enabled;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (n)? [n boolValue]:YES;
}

static void respringAction() {
     [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
 }

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

%hook SBDashBoardTeachableMomentsContainerView //LockScreen
-(void)layoutSubviews {
if (enabled){
[self setHidden:YES];
} else {
%orig();
}
}
%end
%hook SBHomeGrabberRotationView //Inside Apps
-(void)layoutSubviews {
if (enabled){
[self setHidden:YES];
} else {
%orig();
}
}
%end
%hook SBHomeGrabberView //Inside Apps and Control Center
-(void)setHidden:(BOOL)arg1 forReason:(id)arg2 withAnimationSettings:(id)arg3{
if (enabled){
 %orig(true, arg2, arg3);
} else {
 %orig(arg1, arg2, arg3);
}
}
%end
/*%hook MTLumaDodgePillView //Control Center
-(void)setHidden:(BOOL)arg1 forReason:(id)arg2 withAnimationSettings:(id)arg3{
if (enabled){
 %orig(true, arg2, arg3);
} else {
 %orig(arg1, arg2, arg3);
}
}
%end
%hook ColorPillView //Control Center
-(void)setHidden:(BOOL)arg1 forReason:(id)arg2 withAnimationSettings:(id)arg3{
if (enabled){
 %orig(true, arg2, arg3);
} else {
 %orig(arg1, arg2, arg3);
}
}
%end*/