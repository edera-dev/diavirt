//
//  ConfigurationModel.swift
//  diavirt
//
//  Created by Alex Zenla on 12/13/21.
//

import Foundation
import Virtualization

struct DAVirtualMachineConfiguration: Codable {
    let cpuCoreCount: Int
    let memorySizeInBytes: UInt64
    let bootLoader: DABootLoader
    let platform: DAPlatform
    let storageDevices: [DAStorageDevice]?
    let serialPorts: [DASerialPort]?
    let entropyDevices: [DAEntropyDevice]?
    let memoryBalloonDevices: [DAMemoryBalloonDevice]?
    let networkDevices: [DANetworkDevice]?
    let graphicsDevices: [DAGraphicsDevice]?
    let directorySharingDevices: [DADirectorySharingDevice]?
    let socketDevices: [DASocketDevice]?
    let keyboardDevices: [DAKeyboardDevice]?
    let pointingDevices: [DAPointingDevice]?
    let macRestoreImage: DAMacOSRestoreImage?
    let startOptions: DAStartOptions?
}

struct DABootLoader: Codable {
    let linuxBootLoader: DALinuxBootLoader?
    let macOSBootLoader: DAMacOSBootLoader?
    let efiBootLoader: DAEFIBootLoader?
}

struct DALinuxBootLoader: Codable {
    let kernelFilePath: String
    let initialRamdiskPath: String?
    let commandLine: String?
}

struct DAMacOSBootLoader: Codable {}

struct DAEFIBootLoader: Codable {
    let efiVariableStore: DAEFIVariableStore
}

struct DAEFIVariableStore: Codable {
    let variableStorePath: String
}

struct DAPlatform: Codable {
    let genericPlatform: DAGenericPlatform?
    let macPlatform: DAMacPlatform?
}

struct DAGenericPlatform: Codable {
    var enableNestedVirtualization: Bool? = false
    var machineIdentifierPath: String?
    var machineIdentifierData: Data?
}

struct DAMacPlatform: Codable {
    let auxiliaryStoragePath: String
    var machineIdentifierPath: String?
    var machineIdentifierData: Data?
    var hardwareModelData: Data?
}

struct DAStorageDevice: Codable {
    let virtioBlockDevice: DAVirtioBlockDevice?
    let nvmeBlockDevice: DANvmeBlockDevice?
    let usbMassStorageDevice: DAUSBMassStorageDevice?
    let diskImageAttachment: DADiskImageAttachment?
    let networkBlockDeviceAttachment: DANetworkBlockDeviceAttachment?
}

struct DADiskImageAttachment: Codable {
    let imageFilePath: String
    let isReadOnly: Bool?
    let autoCreateSizeInBytes: UInt64?
}

struct DANetworkBlockDeviceAttachment: Codable {
    let networkBlockDeviceUrl: String
    let isForcedReadOnly: Bool?
}

struct DAVirtioBlockDevice: Codable {
    let blockDeviceIdentifier: String?
}

struct DANvmeBlockDevice: Codable {}

struct DAUSBMassStorageDevice: Codable {}

struct DASerialPort: Codable {
    let stdioSerialAttachment: DAStdioSerialAttachment?
    let wireSerialAttachment: DAWireSerialAttachment?
    let virtioConsoleDevice: DAVirtioConsoleDevice?
    #if DIAVIRT_USE_PRIVATE_APIS
    let pl011SerialDevice: DAPL011SerialDevice?
    let p16550SerialDevice: DA16550SerialDevice?
    #endif
}

struct DAStdioSerialAttachment: Codable {}

struct DAWireSerialAttachment: Codable {
    let tag: String
}

struct DAVirtioConsoleDevice: Codable {}

#if DIAVIRT_USE_PRIVATE_APIS
struct DAPL011SerialDevice: Codable {}

struct DA16550SerialDevice: Codable {}
#endif

struct DAEntropyDevice: Codable {
    let virtioEntropyDevice: DAVirtioEntropyDevice?
}

struct DAVirtioEntropyDevice: Codable {}

struct DAMemoryBalloonDevice: Codable {
    let virtioTraditionalMemoryBalloonDevice: DAVirtioTraditionalMemoryBalloonDevice?
}

struct DAVirtioTraditionalMemoryBalloonDevice: Codable {}

struct DANetworkDevice: Codable {
    let virtioNetworkDevice: DAVirtioNetworkDevice?
    let natNetworkAttachment: DANATNetworkAttachment?
    let bridgedNetworkAttachment: DABridgedNetworkAttachment?
}

struct DAVirtioNetworkDevice: Codable {
    let macAddress: String?
}

struct DANATNetworkAttachment: Codable {}

struct DABridgedNetworkAttachment: Codable {
    let interface: String
}

struct DAGraphicsDevice: Codable {
    let macGraphicsDevice: DAMacGraphicsDevice?
    let virtioGraphicsDevice: DAVirtioGraphicsDevice?
}

struct DAMacGraphicsDevice: Codable {
    let displays: [DAMacGraphicsDisplay]
}

struct DAMacGraphicsDisplay: Codable {
    let widthInPixels: Int
    let heightInPixels: Int
    let pixelsPerInch: Int
}

struct DAVirtioGraphicsScanout: Codable {
    let widthInPixels: Int
    let heightInPixels: Int
}

struct DAVirtioGraphicsDevice: Codable {
    let scanouts: [DAVirtioGraphicsScanout]
}

struct DADirectorySharingDevice: Codable {
    let virtioFileSystemDevice: DAVirtioFileSystemDevice?
    let directoryShare: DADirectoryShare
}

struct DAVirtioFileSystemDevice: Codable {
    let tag: String
}

struct DADirectoryShare: Codable {
    let singleDirectoryShare: DASingleDirectoryShare?
    let multipleDirectoryShare: DAMultipleDirectoryShare?
    let rosettaDirectoryShare: DARosettaDirectoryShare?
}

struct DASingleDirectoryShare: Codable {
    let directory: DASharedDirectory
}

struct DAMultipleDirectoryShare: Codable {
    let directories: [String: DASharedDirectory]
}

struct DARosettaDirectoryShare: Codable {}

struct DASharedDirectory: Codable {
    let path: String
    let isReadOnly: Bool?
}

struct DASocketDevice: Codable {
    let virtioSocketDevice: DAVirtioSocketDevice?
}

struct DAVirtioSocketDevice: Codable {}

struct DAKeyboardDevice: Codable {
    let usbKeyboardDevice: DAUSBKeyboardDevice?
    let macKeyboardDevice: DAMacKeyboardDevice?
}

struct DAUSBKeyboardDevice: Codable {}

struct DAMacKeyboardDevice: Codable {}

struct DAPointingDevice: Codable {
    let usbScreenCoordinatePointingDevice: DAUSBScreenCoordinatePointingDevice?
    let macTrackpadDevice: DAMacTrackpadDevice?
}

struct DAUSBScreenCoordinatePointingDevice: Codable {}

struct DAMacTrackpadDevice: Codable {}

struct DAMacOSRestoreImage: Codable {
    let latestSupportedRestoreImage: DALatestSupportedMacOSRestoreImage?
    let fileRestoreImage: DAFileMacOSRestoreImage?
}

struct DALatestSupportedMacOSRestoreImage: Codable {}

struct DAFileMacOSRestoreImage: Codable {
    let restoreImagePath: String
}

struct DAStartOptions: Codable {
    var macOSStartOptions: DAMacOSStartOptions?
}

struct DAMacOSStartOptions: Codable {
    var startUpFromMacOSRecovery: Bool?
}
