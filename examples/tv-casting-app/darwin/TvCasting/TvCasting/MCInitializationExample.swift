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

import Foundation
import Security
import os.log
import MatterTvCastingBridge

// This class needs to be imlemented by the client.
class MCAppParametersDataSource : NSObject, MCDataSource
{    
    let Log = Logger(subsystem: "com.matter.casting",
                     category: "MCAppParametersDataSource")
    
    // Dummy values for demonstration only.
    private var commissionableData: MCCommissionableData = MCCommissionableData(
        passcode: 20202021,
        discriminator: 3874,
        // Default to the minimum PBKDF iterations (1,000) for this example implementation. For TV devices and TV casting app production
        // implementations, you should use a higher number of PBKDF iterations to enhance security. The default minimum iterations are
        // not sufficient against brute-force and rainbow table attacks. Increasing the number of iterations will increase the
        // computational time required to derive the key. This can slow down the authentication process, especially on devices with
        // limited processing power like a Raspberry Pi 4. For a production implementation, you should measure the actual performance on
        // the target device.
        //
        // 1,000 - Hypothetical key derivation time: ~20 milliseconds (ms).
        // 100,000 - Hypothetical key derivation time: ~2 seconds.
        spake2pIterationCount: 1000,
        spake2pVerifier: nil,
        spake2pSalt: nil
    )

    /**
    * This function needs to be implemented by the client in use cases where the MCCommissionableData needs to be updated
    * post-initialization. For example, when the Commissioner-Generated Passcode feature is used.
    */
    func update(_ newCommissionableData: MCCommissionableData) {
        Log.info("MCAppParametersDataSource.update() - Before update, passcode: \(self.commissionableData.passcode)")
        self.commissionableData = newCommissionableData
        Log.info("MCAppParametersDataSource.update() - After update, passcode: \(self.commissionableData.passcode)")
    }
    
    func clientQueue() -> DispatchQueue {
        return DispatchQueue.main;
    }
    
    func castingAppDidReceiveRequestForRotatingDeviceIdUniqueId(_ sender: Any) -> Data {
        // dummy value, with at least 16 bytes (ConfigurationManager::kMinRotatingDeviceIDUniqueIDLength), for demonstration only
        return "0123456789ABCDEF".data(using: .utf8)!
    }
    
    func castingAppDidReceiveRequestForCommissionableData(_ sender: Any) -> MCCommissionableData {
        Log.info("MCAppParametersDataSource castingAppDidReceiveRequestForCommissionableData()")
        return commissionableData
    }
    
    // dummy DAC values for demonstration only
    let kDevelopmentDAC_Cert_FFF1_8001: Data = Data(base64Encoded: "MIIB5zCCAY6gAwIBAgIIac3xDenlTtEwCgYIKoZIzj0EAwIwPTElMCMGA1UEAwwcTWF0dGVyIERldiBQQUkgMHhGRkYxIG5vIFBJRDEUMBIGCisGAQQBgqJ8AgEMBEZGRjEwIBcNMjIwMjA1MDAwMDAwWhgPOTk5OTEyMzEyMzU5NTlaMFMxJTAjBgNVBAMMHE1hdHRlciBEZXYgREFDIDB4RkZGMS8weDgwMDExFDASBgorBgEEAYKifAIBDARGRkYxMRQwEgYKKwYBBAGConwCAgwEODAwMTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABEY6xpNCkQoOVYj8b/Vrtj5i7M7LFI99TrA+5VJgFBV2fRalxmP3k+SRIyYLgpenzX58/HsxaznZjpDSk3dzjoKjYDBeMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBSI3eezADgpMs/3NMBGJIEPRBaKbzAfBgNVHSMEGDAWgBRjVA5H9kscONE4hKRi0WwZXY/7PDAKBggqhkjOPQQDAgNHADBEAiABJ6J7S0RhDuL83E0reIVWNmC8D3bxchntagjfsrPBzQIga1ngr0Xz6yqFuRnTVzFSjGAoxBUjlUXhCOTlTnCXE1M=")!;
    
    let kDevelopmentDAC_PrivateKey_FFF1_8001: Data = Data(base64Encoded: "qrYAroroqrfXNifCF7fCBHCcppRq9fL3UwgzpStE+/8=")!;

    let kDevelopmentDAC_PublicKey_FFF1_8001: Data = Data(base64Encoded: "BEY6xpNCkQoOVYj8b/Vrtj5i7M7LFI99TrA+5VJgFBV2fRalxmP3k+SRIyYLgpenzX58/HsxaznZjpDSk3dzjoI=")!;
    
    let KPAI_FFF1_8000_Cert_Array: Data = Data(base64Encoded: "MIIByzCCAXGgAwIBAgIIVq2CIq2UW2QwCgYIKoZIzj0EAwIwMDEYMBYGA1UEAwwPTWF0dGVyIFRlc3QgUEFBMRQwEgYKKwYBBAGConwCAQwERkZGMTAgFw0yMjAyMDUwMDAwMDBaGA85OTk5MTIzMTIzNTk1OVowPTElMCMGA1UEAwwcTWF0dGVyIERldiBQQUkgMHhGRkYxIG5vIFBJRDEUMBIGCisGAQQBgqJ8AgEMBEZGRjEwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARBmpMVwhc+DIyHbQPM/JRIUmR/f+xeUIL0BZko7KiUxZQVEwmsYx5MsDOSr2hLC6+35ls7gWLC9Sv5MbjneqqCo2YwZDASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUY1QOR/ZLHDjROISkYtFsGV2P+zwwHwYDVR0jBBgwFoAUav0idx9RH+y/FkGXZxDc3DGhcX4wCgYIKoZIzj0EAwIDSAAwRQIhALLvJ/Sa6bUPuR7qyUxNC9u415KcbLiPrOUpNo0SBUwMAiBlXckrhr2QmIKmxiF3uCXX0F7b58Ivn+pxIg5+pwP4kQ==")!;
    
    let kCertificationDeclaration: Data = Data(base64Encoded: "MIICGQYJKoZIhvcNAQcCoIICCjCCAgYCAQMxDTALBglghkgBZQMEAgEwggFxBgkqhkiG9w0BBwGgggFiBIIBXhUkAAElAfH/NgIFAIAFAYAFAoAFA4AFBIAFBYAFBoAFB4AFCIAFCYAFCoAFC4AFDIAFDYAFDoAFD4AFEIAFEYAFEoAFE4AFFIAFFYAFFoAFF4AFGIAFGYAFGoAFG4AFHIAFHYAFHoAFH4AFIIAFIYAFIoAFI4AFJIAFJYAFJoAFJ4AFKIAFKYAFKoAFK4AFLIAFLYAFLoAFL4AFMIAFMYAFMoAFM4AFNIAFNYAFNoAFN4AFOIAFOYAFOoAFO4AFPIAFPYAFPoAFP4AFQIAFQYAFQoAFQ4AFRIAFRYAFRoAFR4AFSIAFSYAFSoAFS4AFTIAFTYAFToAFT4AFUIAFUYAFUoAFU4AFVIAFVYAFVoAFV4AFWIAFWYAFWoAFW4AFXIAFXYAFXoAFX4AFYIAFYYAFYoAFY4AYJAMWLAQTWklHMjAxNDJaQjMzMDAwMy0yNCQFACQGACUHlCYkCAAYMX0wewIBA4AUYvqCM1ms+qmWPhz6FArd9QTzcWAwCwYJYIZIAWUDBAIBMAoGCCqGSM49BAMCBEcwRQIgJOXR9Hp9ew0gaibvaZt8l1e3LUaQid4xkuZ4x0Xn9gwCIQD4qi+nEfy3m5fjl87aZnuuRk4r0//fw8zteqjKX0wafA==")!;
    func castingAppDidReceiveRequestForDeviceAttestationCredentials(_ sender: Any) -> MCDeviceAttestationCredentials {
        return MCDeviceAttestationCredentials(
            certificationDeclaration: kCertificationDeclaration,
            firmwareInformation: Data(),
            deviceAttestationCert: kDevelopmentDAC_Cert_FFF1_8001,
            productAttestationIntermediateCert: KPAI_FFF1_8000_Cert_Array)
    }
    
    func castingApp(_ sender: Any, didReceiveRequestToSignCertificateRequest csrData: Data, outRawSignature: AutoreleasingUnsafeMutablePointer<NSData>) -> MatterError {
        Log.info("castingApp didReceiveRequestToSignCertificateRequest")

        // get the private SecKey
        var privateKeyData = Data()
        privateKeyData.append(kDevelopmentDAC_PublicKey_FFF1_8001);
        privateKeyData.append(kDevelopmentDAC_PrivateKey_FFF1_8001);
        let privateSecKey: SecKey = SecKeyCreateWithData(privateKeyData as NSData,
                                    [
                                        kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                        kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                                        kSecAttrKeySizeInBits: 256
                                    ] as NSDictionary, nil)!
        
        // sign csrData to get asn1SignatureData
        var error: Unmanaged<CFError>?
        let asn1SignatureData: CFData? = SecKeyCreateSignature(privateSecKey, .ecdsaSignatureMessageX962SHA256, csrData as CFData, &error)
        if(error != nil)
        {
            Log.error("Failed to sign message. Error: \(String(describing: error))")
            return MATTER_ERROR_INVALID_ARGUMENT
        }
        else if (asn1SignatureData == nil)
        {
            Log.error("Failed to sign message. asn1SignatureData is nil")
            return MATTER_ERROR_INVALID_ARGUMENT
        }
        
        // convert ASN.1 DER signature to SEC1 raw format
        return MCCryptoUtils.ecdsaAsn1SignatureToRaw(withFeLengthBytes: 32,
                                                    asn1Signature: asn1SignatureData!,
                                                         outRawSignature: &outRawSignature.pointee)
    }
}

// This class is a singleton
class MCInitializationExample {
    static let shared = MCInitializationExample()

    let Log = Logger(subsystem: "com.matter.casting",
                     category: "MCInitializationExample")

    // We store the client defined instance of the MCAppParametersDataSource passed to CastingApp.initialize().
    // MCAppParametersDataSource may need to be updated by the client in case of the Casting 
    // Player/Commissioner-Generated passcode commissioning flow.
    private var appParametersDataSource: MCAppParametersDataSource?

    private init() {
        // Private initialization to ensure just one instance is created.
    }

    func initialize() {
        Log.info("MCInitializationExample.initialize() calling MCCastingApp.initializeWithDataSource()")

        let dataSource = MCAppParametersDataSource()
        appParametersDataSource = dataSource

        MCCastingApp.shared.initialize(with: dataSource)
    }

    // Getter method for the stored instance of MCAppParametersDataSource
    func getAppParametersDataSource() -> MCAppParametersDataSource? {
        Log.info("MCInitializationExample.getAppParametersDataSource()")
        return appParametersDataSource
    }
}
