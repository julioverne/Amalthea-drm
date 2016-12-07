#import <CommonCrypto/CommonCrypto.h>
OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

@implementation NSData (AES)
- (NSData *)AES128:(CCOperation)operation key:(const void *)key iv:(NSString *)iv
{		  //CCOperation: kCCDecrypt/kCCEncrypt
    /*char keyPtr[kCCKeySizeAES128];
    bzero(keyPtr, sizeof(keyPtr));
	if (key) {
		[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	}*/
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    if (iv) {
		[iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    }
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
					  kCCAlgorithmAES128,
					  kCCOptionPKCS7Padding,
					  key,
					  32,
					  ivPtr,
					  [self bytes],
					  dataLength,
					  buffer,
					  bufferSize,
					  &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
@end

int main()
{
	NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
	
	NSString *pref_lice = @"//var/mobile/Library/Preferences/io.ijapija00.amalthea.key";
	
	system("rm -rf //var/mobile/Library/Preferences/io.ijapija00.amalthea.key");
	
	NSString *mountString1 = [NSString stringWithFormat:@"{\"paid\":true,\"udid\":\"%@\",\"timestamp\":\"2099-01-02 03:04:05\"}", (NSString*)MGCopyAnswer(CFSTR("UniqueDeviceID"))];
	
	const void * key1 = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
	
	NSData* dataEnKey = [[mountString1 dataUsingEncoding:NSUTF8StringEncoding] AES128:kCCEncrypt key:key1 iv:nil];
	
	NSError* error = nil;
	[dataEnKey writeToFile:pref_lice options:NSDataWritingAtomic error:&error];
	
	if (error) {
		printf("\n*** Error writing license to file! ***\n");
	} else {
		[manager setAttributes:@{@"mobile": NSFileOwnerAccountName,	@"mobile": NSFileGroupOwnerAccountName,	@0644: NSFilePosixPermissions,} ofItemAtPath:pref_lice error:nil];
		printf("\n*** License has been generated! ***\n");
	}
	
	printf("\n");
	printf("Respring!!!\n");
	printf("Respring!!!\n");
	printf("Respring!!!\n");
	printf("\n");
	printf("*** Keygen Amalthea (iOS 9) by julioverne ***\n");
	printf("\n");
	
	return 0;
}