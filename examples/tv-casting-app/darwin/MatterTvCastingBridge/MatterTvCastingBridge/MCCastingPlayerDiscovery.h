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
 * MCCastingPlayerDiscovery sends notification with MCCastingPlayerDiscoveryAddCastingPlayerNotification
 * through the NSNotificationCenter if a new MCCastingPlayer is added to the network
 */
extern NSNotificationName const MCCastingPlayerDiscoveryAddCastingPlayerNotification NS_SWIFT_NAME(MCCastingPlayerDiscovery.addCastingPlayerNotification);

/**
 * MCCastingPlayerDiscovery sends notification with MCCastingPlayerDiscoveryRemoveCastingPlayerNotification
 * through the NSNotificationCenter if a MCCastingPlayer is removed from the network
 */
extern NSNotificationName const MCCastingPlayerDiscoveryRemoveCastingPlayerNotification NS_SWIFT_NAME(MCCastingPlayerDiscovery.removeCastingPlayerNotification);

/**
 * MCCastingPlayerDiscovery sends notification with MCCastingPlayerDiscoveryUpdateCastingPlayer
 * through the NSNotificationCenter if a previously added MCCastingPlayer is updated
 */
extern NSNotificationName const MCCastingPlayerDiscoveryUpdateCastingPlayer NS_SWIFT_NAME(MCCastingPlayerDiscovery.updateCastingPlayerNotification);

/**
 * MCCastingPlayerDiscovery sends ADD / REMOVE / UPDATE notifications through the
 * NSNotificationCenter with userInfo set to an NSDictionary that has CASTING_PLAYER_KEY as the
 * key to a MCCastingPlayer object as value.
 */
extern NSString * const MCCastingPlayerDiscoveryCastingPlayerKey NS_SWIFT_NAME(MCCastingPlayerDiscovery.castingPlayerKey);

/**
 * @brief MCCastingPlayerDiscovery is a singleton utility class for discovering MCCastingPlayers.
 */
@interface MCCastingPlayerDiscovery : NSObject

/**
 * Returns a shared instance of the MCCastingPlayerDiscovery
 */
@property (class, nonnull, readonly) MCCastingPlayerDiscovery *sharedInstance NS_SWIFT_NAME(MCCastingPlayerDiscovery.shared);

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, strong) NSArray<MCCastingPlayer *> * castingPlayers;

/**
 * @brief Starts the discovery for MCCastingPlayers
 *
 * @param error Returns nil if discovery for CastingPlayers started successfully, NSError * describing the error otherwise.
 *
 * @returns YES on success, NO on failure
 */
- (BOOL)start:(NSError **)error;

/**
 * @brief Starts the discovery for MCCastingPlayers
 *
 * @param filterByDeviceType if passed as a non-zero value, MCCastingPlayerDiscovery will only discover
 * MCCastingPlayers whose deviceType matches filterBydeviceType
 * @param error Returns nil if discovery for MCCastingPlayers started successfully, NSError * describing the error otherwise.
 *
 * @returns YES on success, NO on failure
 */
- (BOOL)start:(const uint32_t)filterByDeviceType error:(NSError **)error NS_SWIFT_NAME(start(filterByDeviceType:));

/**
 * @brief Stop the discovery for MCCastingPlayers
 *
 * @param error Returns nil if discovery for MCCastingPlayers stopped successfully, NSError * describing the error otherwise.
 *
 * @returns YES on success, NO on failure
 */
- (BOOL)stop:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
