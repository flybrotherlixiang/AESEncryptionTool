//
//  main.m
//  AESEncryptionTool
//
//  Created by 李翔 on 3/17/16.
//  Copyright © 2016 Xiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AESCrypt.h"

//NSString *const password = @"baixingios";

static NSString *const usageText = @"SYNOPSIS:\n ./AESEncrptionTool INPUT_FILE_PATH [-e-d]\n\nsample input:\n ./AESEncrptionTool /Users/Flybrother/aestest/index.js\n\nnote:\n -e for encrption, -d for decrption and the default mode is encryption.";
static NSString *const invalidPwdText = @"Invalid Password.";
static NSString *const noPwdText = @"Please provide a password following -p in your command";



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            NSLog(usageText);
            return -1;
        }
        
        // encryption mode
        BOOL isDecryptionMode = NO;
        for (int i = 0; i < argc; i++) {
            if (!strcmp(argv[i], "-e")) {
                isDecryptionMode = NO;
                break;
            }
            
            if (!strcmp(argv[i], "-d")) {
                isDecryptionMode = YES;
                break;
            }
        }
        
        // password
        NSString *pwd;
        for (int i = 0; i < argc; i++) {
            if (!strcmp(argv[i], "-p")) {
                if (i == argc - 1) {
                    NSLog(invalidPwdText);
                    return -1;
                }
                pwd = [NSString stringWithCString:argv[i+1] encoding:NSUTF8StringEncoding];
                break;
            }
        }
        if (!pwd) {
            NSLog(noPwdText);
            return -1;
        }
        
        // read input file
        NSString *fileContent = @"";
        char ch;
        FILE *fp;
        fp = fopen(argv[1],"r");
        if (fp) {
            while ((ch = fgetc(fp)) != EOF) {
                NSString *charInNSString = [NSString stringWithFormat:@"%c", ch];
                fileContent = [fileContent stringByAppendingString:charInNSString];
            }
        } else {
            NSLog(@"can't open file at %s", argv[1]);
            return -1;
        }
        
        fclose(fp);
        
        if (isDecryptionMode) {
            NSLog(@"Decrypting file at %s\n", argv[1]);
        } else {
            NSLog(@"Encrypting file at %s\n", argv[1]);
        }
        
        
        NSString *output = isDecryptionMode ? [AESCrypt decrypt:fileContent password:pwd] :
        [AESCrypt encrypt:fileContent password:pwd];
        
        // write to output file
        char outputPath[150];
        strcpy(outputPath, argv[1]);
        if (isDecryptionMode) {
            strcat(outputPath, ".dec");
        } else {
            strcat(outputPath, ".enc");
        }
        
        FILE *f = fopen(outputPath, "w");
        if (f)
        {
            fprintf(f, "%s", [output UTF8String]);
        }
        
        fclose(f);
        
        if (isDecryptionMode) {
            NSLog(@"Decryption succeeded.\n");
        } else {
            NSLog(@"Encryption succeeded.\n");
        }
    }
    return 0;
}