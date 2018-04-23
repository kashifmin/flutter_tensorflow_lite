#import "TensorflowLitePlugin.h"
#import <tensorflow_lite/tensorflow_lite-Swift.h>

@implementation TensorflowLitePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTensorflowLitePlugin registerWithRegistrar:registrar];
}
@end
