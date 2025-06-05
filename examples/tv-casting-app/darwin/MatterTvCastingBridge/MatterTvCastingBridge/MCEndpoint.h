/**
 *
 *    Copyright (c) 2020-2023 Project CHIP Authors
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
#import <MatterTvCastingBridge/MCEndpointClusterType.h>

NS_ASSUME_NONNULL_BEGIN

@class MCCastingPlayer;
@class MCCluster;

@interface MCEndpoint : NSObject


@property (nonatomic, readonly, copy) NSNumber * identifier;
@property (nonatomic, readonly, copy) NSNumber * vendorId;
@property (nonatomic, readonly, copy) NSNumber * productId;

- (NSArray *)deviceTypeList;
@property (nonatomic, readonly) MCCastingPlayer * castingPlayer;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (BOOL)hasCluster:(MCEndpointClusterType)type;
- (MCCluster * _Nullable)clusterForType:(MCEndpointClusterType)type;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
