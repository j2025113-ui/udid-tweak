#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static void checkUDIDAndLaunch() {
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSURL *url = [NSURL URLWithString:@"https://checkudid.xo.je/auth.php"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    req.HTTPBody = [[NSString stringWithFormat:@"udid=%@", udid]
                    dataUsingEncoding:NSUTF8StringEncoding];

    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    [[[NSURLSession sharedSession]
      dataTaskWithRequest:req
      completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {

        BOOL authorized = NO;
        if (data) {
            NSDictionary *json = [NSJSONSerialization
                JSONObjectWithData:data options:0 error:nil];
            authorized = [json[@"status"] isEqualToString:@"ok"];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorized) {
                NSURL *gameURL = [NSURL URLWithString:@"https://checkudid.xo.je/%E3%82%B2%E3%83%BC%E3%83%A0.html"];
                [[UIApplication sharedApplication] openURL:gameURL
                                                   options:@{}
                                         completionHandler:nil];
            } else {
                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:@"認証エラー"
                    message:@"このデバイスは認証されていません。"
                    preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction
                    actionWithTitle:@"OK"
                    style:UIAlertActionStyleDefault
                    handler:nil]];

                // keyWindowの代わりに新しい方法を使う
                UIWindowScene *scene = (UIWindowScene *)[[[UIApplication sharedApplication]
                    connectedScenes] anyObject];
                UIWindow *win = scene.windows.firstObject;
                [win.rootViewController presentViewController:alert
                                                     animated:YES
                                                   completion:nil];
            }
        });
        dispatch_semaphore_signal(sem);
    }] resume];

    dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        checkUDIDAndLaunch();
    });
}
%end
