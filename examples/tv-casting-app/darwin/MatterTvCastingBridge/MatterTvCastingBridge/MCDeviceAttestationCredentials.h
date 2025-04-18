/**
 *
 *    Copyright (c) 2023 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDeviceAttestationCredentials : NSObject

@property (nonatomic, strong, readonly) NSData *certificationDeclaration;
@property (nonatomic, strong, readonly) NSData *firmwareInformation;
@property (nonatomic, strong, readonly) NSData *deviceAttestationCert;
@property (nonatomic, strong, readonly) NSData *productAttestationIntermediateCert;

- (MCDeviceAttestationCredentials *)initWithCertificationDeclaration:(NSData *)certificationDeclaration
                                                 firmwareInformation:(NSData *)firmwareInformation
                                               deviceAttestationCert:(NSData *)deviceAttestationCert
                                  productAttestationIntermediateCert:(NSData *)productAttestationIntermediateCert;

@end

NS_ASSUME_NONNULL_END
