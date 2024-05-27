#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeAppNativePlugin.framework/WeAppNativePlugin.h"
#import "MyPlugin.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

__attribute__((constructor))
static void initPlugin() {
    [MyPlugin registerPluginAndInit:[[MyPlugin alloc] init]];
};

@implementation MyPlugin

// 声明插件ID
WEAPP_DEFINE_PLUGIN_ID(wx033a6b34f2c7ea15)

WEAPP_EXPORT_PLUGIN_METHOD_SYNC(getIdentifierForVendor, @selector(getIdentifierForVendor:))

WEAPP_EXPORT_PLUGIN_METHOD_SYNC(getAdvertisingIdentifier, @selector(getAdvertisingIdentifier:))

// 声明插件异步方法
WEAPP_EXPORT_PLUGIN_METHOD_ASYNC(requestTrackingPermission, @selector(requestTrackingPermission:withCallback:))

- (NSString *)getIdentifierForVendor:(NSDictionary *)param {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)getAdvertisingIdentifier:(NSDictionary *)param {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (void)requestTrackingPermission:(NSDictionary *)param withCallback:(WeAppNativePluginCallback)callback {
    // 在合适的地方，比如应用启动或者在显示广告前
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    // 用户尚未做出选择
                    callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusNotDetermined" });
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    // 系统限制
                    callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusRestricted" });
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    // 用户拒绝
                    callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusDenied" });
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusAuthorized" });
                    break;
                default:
                    callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusNotDetermined" });
                    break;
            }
        }];
    } else {
        // 对于iOS 14以下版本，可以直接获取IDFA
        callback(@{ @"status": @"ATTrackingManagerAuthorizationStatusAuthorized" });
    }
}

// 插件初始化方法，在注册插件后会被自动调用
- (void)initPlugin {
    NSLog(@"initPlugin");
    [self registerAppDelegateMethod:@selector(application:openURL:options:)];
    [self registerAppDelegateMethod:@selector(application:continueUserActivity:restorationHandler:)];
}

- (void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSLog(@"url scheme");
}

- (void)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *__nullable restorableObjects))restorationHandler {
    NSLog(@"universal link");
}

@end
