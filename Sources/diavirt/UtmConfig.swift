//
//  UtmConfig.swift
//  diavirt
//
//  Created by Alex Zenla on 6/23/25.
//

import Foundation

struct UtmConfig: Codable {
    var backend: String
    var configurationVersion: Int
    var displays: [UtmDisplayConfig]
    var drives: [UtmDriveConfig]
    var information: UtmInformationConfig
    var networks: [UtmNetworkConfig]
    var serialPorts: [UtmSerialPortConfig]
    var system: UtmSystemConfig
    var virtualization: UtmVirtualizationConfig

    enum CodingKeys: String, CodingKey {
        case backend = "Backend"
        case configurationVersion = "ConfigurationVersion"
        case displays = "Display"
        case drives = "Drive"
        case information = "Information"
        case networks = "Network"
        case serialPorts = "Serial"
        case system = "System"
        case virtualization = "Virtualization"
    }
}

struct UtmDisplayConfig: Codable {
    var dynamicResolution: Bool
    var heightPixels: Int
    var pixelsPerInch: Int
    var widthPixels: Int

    enum CodingKeys: String, CodingKey {
        case dynamicResolution = "DynamicResolution"
        case heightPixels = "HeightPixels"
        case pixelsPerInch = "PixelsPerInch"
        case widthPixels = "WidthPixels"
    }
}

struct UtmDriveConfig: Codable {
    var identifier: String
    var imageName: String?
    var isNvme: Bool
    var isReadOnly: Bool

    enum CodingKeys: String, CodingKey {
        case identifier = "Identifier"
        case imageName = "ImageName"
        case isNvme = "Nvme"
        case isReadOnly = "ReadOnly"
    }
}

struct UtmInformationConfig: Codable {
    var icon: String
    var isIconCustom: Bool
    var name: String
    var uuid: String

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case isIconCustom = "IconCustom"
        case name = "Name"
        case uuid = "UUID"
    }
}

struct UtmNetworkConfig: Codable {
    var macAddress: String
    var mode: String
    var bridgeInterface: String?

    enum CodingKeys: String, CodingKey {
        case macAddress = "MacAddress"
        case mode = "Mode"
        case bridgeInterface = "BridgeInterface"
    }
}

struct UtmSerialPortConfig: Codable {
    var mode: String
    var terminal: UtmTerminalSettings?

    enum CodingKeys: String, CodingKey {
        case mode = "Mode"
        case terminal = "Terminal"
    }
}

struct UtmTerminalSettings: Codable {
    var backgroundColor: String
    var cursorBlink: Bool
    var font: String
    var fontSize: Int
    var foregroundColor: String

    enum CodingKeys: String, CodingKey {
        case backgroundColor = "BackgroundColor"
        case cursorBlink = "CursorBlink"
        case font = "Font"
        case fontSize = "FontSize"
        case foregroundColor = "ForegroundColor"
    }
}

struct UtmSystemConfig: Codable {
    var architecture: String
    var boot: UtmBootSettings
    var cpuCount: Int
    var genericPlatform: UtmGenericPlatform?
    var macPlatform: UtmMacPlatform?
    var memorySize: Int

    enum CodingKeys: String, CodingKey {
        case architecture = "Architecture"
        case boot = "Boot"
        case cpuCount = "CPUCount"
        case genericPlatform = "GenericPlatform"
        case macPlatform = "MacPlatform"
        case memorySize = "MemorySize"
    }
}

struct UtmBootSettings: Codable {
    var efiVariableStoragePath: String? = ""
    var operatingSystem: String
    var uefiBoot: Bool

    enum CodingKeys: String, CodingKey {
        case efiVariableStoragePath = "EfiVariableStoragePath"
        case operatingSystem = "OperatingSystem"
        case uefiBoot = "UEFIBoot"
    }
}

struct UtmGenericPlatform: Codable {
    var machineIdentifier: Data

    enum CodingKeys: String, CodingKey {
        case machineIdentifier
    }
}

struct UtmMacPlatform: Codable {
    var auxiliaryStoragePath: String
    var hardwareModel: Data
    var machineIdentifier: Data

    enum CodingKeys: String, CodingKey {
        case auxiliaryStoragePath = "AuxiliaryStoragePath"
        case hardwareModel = "HardwareModel"
        case machineIdentifier = "MachineIdentifier"
    }
}

struct UtmVirtualizationConfig: Codable {
    var audioEnabled: Bool
    var balloonEnabled: Bool
    var clipboardSharingEnabled: Bool
    var entropyEnabled: Bool
    var keyboard: String
    var pointer: String
    var rosettaEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case audioEnabled = "Audio"
        case balloonEnabled = "Balloon"
        case clipboardSharingEnabled = "ClipboardSharing"
        case entropyEnabled = "Entropy"
        case keyboard = "Keyboard"
        case pointer = "Pointer"
        case rosettaEnabled = "Rosetta"
    }
}
