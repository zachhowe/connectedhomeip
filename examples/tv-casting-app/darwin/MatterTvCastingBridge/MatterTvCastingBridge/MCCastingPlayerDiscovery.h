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

@class MCCastingPlayer;

NS_ASSUME_NONNULL_BEGIN

/**
 * MCCastingPlayerDiscovery sends notification with ADD_CASTING_PLAYER_NOTIFICATION_NAME
 * through the NSNotificationCenter if a new MCCastingPlayer is added to the network
 */
extern NSString * const ADD_CASTING_PLAYER_NOTIFICATION_NAME;

/**
 * MCCastingPlayerDiscovery sends notification with REMOVE_CASTING_PLAYER_NOTIFICATION_NAME
 * through the NSNotificationCenter if a MCCastingPlayer is removed from the network
 */
extern NSString * const REMOVE_CASTING_PLAYER_NOTIFICATION_NAME;

/**
 * MCCastingPlayerDiscovery sends notification with UPDATE_CASTING_PLAYER_NOTIFICATION_NAME
 * through the NSNotificationCenter if a previously added MCCastingPlayer is updated
 */
extern NSString * const UPDATE_CASTING_PLAYER_NOTIFICATION_NAME;

/**
 * MCCastingPlayerDiscovery sends ADD / REMOVE / UPDATE notifications through the
 * NSNotificationCenter with userInfo set to an NSDictionary that has CASTING_PLAYER_KEY as the
 * key to a MCCastingPlayer object as value.
 */
extern NSString * const CASTING_PLAYER_KEY;

/**
 * @brief MCCastingPlayerDiscovery is a singleton utility class for discovering MCCastingPlayers.
 */
@interface MCCastingPlayerDiscovery : NSObject

+ (MCCastingPlayerDiscovery *)sharedInstance;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, strong) NSArray<MCCastingPlayer *> * castingPlayers;

/**
 * @brief Starts the discovery for MCCastingPlayers
 *
 * @return Returns nil if discovery for CastingPlayers started successfully, NSError * describing the error otherwise.
 */
- (NSError * _Nullable)start;

/**
 * @brief Starts the discovery for MCCastingPlayers
 *
 * @param filterBydeviceType if passed as a non-zero value, MCCastingPlayerDiscovery will only discover
 * MCCastingPlayers whose deviceType matches filterBydeviceType
 * @return Returns nil if discovery for MCCastingPlayers started successfully, NSError * describing the error otherwise.
 */
- (NSError * _Nullable)start:(const uint32_t)filterBydeviceType;

/**
 * @brief Stop the discovery for MCCastingPlayers
 *
 * @return Returns nil if discovery for MCCastingPlayers stopped successfully, NSError * describing the error otherwise.
 */
- (NSError * _Nullable)stop;

@end

NS_ASSUME_NONNULL_END
