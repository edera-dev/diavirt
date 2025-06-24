//
//  CannedMac.swift
//  diavirt
//
//  Created by Alex Zenla on 3/22/22.
//

import Foundation

func createCannedMac() -> DAVirtualMachineConfiguration {
    DAVirtualMachineConfiguration(
        cpuCoreCount: 4,
        memorySizeInBytes: 6 * 1024 * 1024 * 1024,
        bootLoader: .init(
            linuxBootLoader: nil,
            macOSBootLoader: .init(),
            efiBootLoader: nil
        ),
        platform: .init(
            genericPlatform: nil,
            macPlatform: .init(
                auxiliaryStoragePath: "macaux.bin",
                machineIdentifierPath: "macid.bin"
            )
        ),
        storageDevices: [
            .init(
                virtioBlockDevice: .init(blockDeviceIdentifier: ""),
                nvmeBlockDevice: nil,
                usbMassStorageDevice: .init(),
                diskImageAttachment: .init(
                    imageFilePath: "root.img",
                    isReadOnly: false,
                    autoCreateSizeInBytes: UInt64(128 * 1024 * 1024 * 1024)
                ),
                networkBlockDeviceAttachment: nil
            )
        ],
        serialPorts: [],
        entropyDevices: [],
        memoryBalloonDevices: [
            .init(
                virtioTraditionalMemoryBalloonDevice: .init()
            )
        ],
        networkDevices: [
            .init(
                virtioNetworkDevice: .init(macAddress: nil),
                natNetworkAttachment: .init(),
                bridgedNetworkAttachment: nil,
            )
        ],
        graphicsDevices: [
            .init(
                macGraphicsDevice: .init(
                    displays: [
                        .init(
                            widthInPixels: 1920,
                            heightInPixels: 1080,
                            pixelsPerInch: 80
                        )
                    ]
                ),
                virtioGraphicsDevice: .init(scanouts: [])
            )
        ],
        directorySharingDevices: [
            .init(
                virtioFileSystemDevice: .init(tag: "MacHome"),
                directoryShare: .init(
                    singleDirectoryShare: .init(
                        directory: .init(
                            path: FileManager.default.homeDirectoryForCurrentUser.path,
                            isReadOnly: true
                        )
                    ),
                    multipleDirectoryShare: nil,
                    rosettaDirectoryShare: nil,
                )
            )
        ],
        socketDevices: [],
        keyboardDevices: [
            .init(
                usbKeyboardDevice: .init(),
                macKeyboardDevice: nil,
            )
        ],
        pointingDevices: [
            .init(
                usbScreenCoordinatePointingDevice: .init(),
                macTrackpadDevice: nil,
            )
        ],
        macRestoreImage: .init(
            latestSupportedRestoreImage: .init(),
            fileRestoreImage: nil
        ),
        startOptions: .init()
    )
}
