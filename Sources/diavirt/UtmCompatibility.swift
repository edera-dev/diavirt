//
//  UtmCompatibility.swift
//  diavirt
//
//  Created by Alex Zenla on 6/22/25.
//

import Foundation

enum UtmCompatibility {
    static func url(path: String) -> URL? {
        if path.contains("/") || path.hasSuffix(".utm") {
            return URL(string: path)
        }

        let home = FileManager.default.homeDirectoryForCurrentUser.path()
        return URL(filePath: "\(home)/Library/Containers/com.utmapp.UTM/Data/Documents/\(path).utm")
    }

    static func dataPath(for input: String, vm: URL) -> String {
        vm.appendingPathComponent("Data").appendingPathComponent(input).path()
    }

    static func configuration(for vm: URL) throws -> DAVirtualMachineConfiguration? {
        let configURL = vm.appendingPathComponent("config.plist")
        guard let configData = try? Data(contentsOf: configURL) else {
            return nil
        }
        let config = try PropertyListDecoder().decode(UtmConfig.self, from: configData)

        var cpuCoreCount = config.system.cpuCount
        if cpuCoreCount == 0 {
            cpuCoreCount = ProcessInfo.processInfo.activeProcessorCount
        }

        let bootLoader: DABootLoader
        let platform: DAPlatform
        var graphic: DAGraphicsDevice?
        if let genericPlatform = config.system.genericPlatform {
            platform = DAPlatform(genericPlatform: DAGenericPlatform(enableNestedVirtualization: nil, machineIdentifierPath: nil, machineIdentifierData: genericPlatform.machineIdentifier), macPlatform: nil)

            if config.system.boot.uefiBoot {
                let efiPath = Self.dataPath(for: config.system.boot.efiVariableStoragePath ?? "efi_vars.fd", vm: vm)
                let efiBootLoader = DAEFIBootLoader(efiVariableStore: DAEFIVariableStore(variableStorePath: efiPath))
                bootLoader = DABootLoader(linuxBootLoader: nil, macOSBootLoader: nil, efiBootLoader: efiBootLoader)
            } else {
                fatalError("diavirt does not support linux boot currently")
            }

            graphic = DAGraphicsDevice(macGraphicsDevice: nil, virtioGraphicsDevice: DAVirtioGraphicsDevice(scanouts: config.displays.map {
                DAVirtioGraphicsScanout(widthInPixels: $0.widthPixels, heightInPixels: $0.heightPixels)
            }))
        } else if let macPlatform = config.system.macPlatform {
            let auxiliaryStoragePath = Self.dataPath(for: macPlatform.auxiliaryStoragePath, vm: vm)
            platform = DAPlatform(genericPlatform: nil, macPlatform: DAMacPlatform(auxiliaryStoragePath: auxiliaryStoragePath, hardwareModelData: macPlatform.hardwareModel))
            bootLoader = DABootLoader(linuxBootLoader: nil, macOSBootLoader: DAMacOSBootLoader(), efiBootLoader: nil)

            graphic = DAGraphicsDevice(macGraphicsDevice: DAMacGraphicsDevice(displays: config.displays.map {
                DAMacGraphicsDisplay(widthInPixels: $0.widthPixels, heightInPixels: $0.heightPixels, pixelsPerInch: $0.pixelsPerInch)
            }), virtioGraphicsDevice: nil)
        } else {
            fatalError("unknown platform")
        }

        var storage: [DAStorageDevice] = []
        var serial: [DASerialPort] = []
        var entropy: [DAEntropyDevice] = []
        var memoryBalloon: [DAMemoryBalloonDevice] = []
        var networks: [DANetworkDevice] = []
        let directorySharing: [DADirectorySharingDevice] = []
        let sockets: [DASocketDevice] = []
        var keyboards: [DAKeyboardDevice] = []
        var pointing: [DAPointingDevice] = []

        for drive in config.drives {
            let path = Self.dataPath(for: drive.imageName, vm: vm)
            if drive.isNvme {
                storage.append(DAStorageDevice(
                    virtioBlockDevice: nil,
                    usbMassStorageDevice: nil,
                    diskImageAttachment: DADiskImageAttachment(
                        imageFilePath: path,
                        isReadOnly: drive.isReadOnly,
                        autoCreateSizeInBytes: nil
                    ),
                    networkBlockDeviceAttachment: nil,
                ))
            } else {
                storage.append(DAStorageDevice(
                    virtioBlockDevice: DAVirtioBlockDevice(),
                    usbMassStorageDevice: nil,
                    diskImageAttachment: DADiskImageAttachment(
                        imageFilePath: path,
                        isReadOnly: drive.isReadOnly,
                        autoCreateSizeInBytes: nil
                    ),
                    networkBlockDeviceAttachment: nil,
                ))
            }
        }

        for i in config.serialPorts.indices {
            serial.append(DASerialPort(
                stdioSerialAttachment: i == 0 ? DAStdioSerialAttachment() : nil,
                wireSerialAttachment: i != 0 ? DAWireSerialAttachment(tag: "serial\(i)") : nil,
                virtioConsoleDevice: DAVirtioConsoleDevice(),
                pl011SerialDevice: nil,
                p16550SerialDevice: nil
            ))
        }

        if config.virtualization.entropyEnabled {
            entropy.append(DAEntropyDevice(virtioEntropyDevice: DAVirtioEntropyDevice()))
        }

        if config.virtualization.balloonEnabled {
            memoryBalloon.append(DAMemoryBalloonDevice(virtioTraditionalMemoryBalloonDevice: DAVirtioTraditionalMemoryBalloonDevice()))
        }

        switch config.virtualization.keyboard {
        default:
            keyboards.append(DAKeyboardDevice(usbKeyboardDevice: DAUSBKeyboardDevice()))
        }

        switch config.virtualization.pointer {
        default:
            pointing.append(DAPointingDevice(usbScreenCoordinatePointingDevice: DAUSBScreenCoordinatePointingDevice()))
        }

        for net in config.networks {
            let device: DANetworkDevice
            switch net.mode {
            case "Shared":
                device = DANetworkDevice(virtioNetworkDevice: DAVirtioNetworkDevice(macAddress: net.macAddress), natNetworkAttachment: DANATNetworkAttachment())

            default:
                fatalError("invalid utm network mode: \(net.mode)")
            }
            networks.append(device)
        }

        let configuration = DAVirtualMachineConfiguration(
            cpuCoreCount: cpuCoreCount,
            memorySizeInBytes: UInt64(config.system.memorySize) * 1024 * 1024,
            bootLoader: bootLoader,
            platform: platform,
            storageDevices: storage,
            serialPorts: serial,
            entropyDevices: entropy,
            memoryBalloonDevices: memoryBalloon,
            networkDevices: networks,
            graphicsDevices: graphic != nil ? [graphic!] : [],
            directorySharingDevices: directorySharing,
            socketDevices: sockets,
            keyboardDevices: keyboards,
            pointingDevices: pointing,
            macRestoreImage: nil,
            startOptions: nil
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes, .prettyPrinted]
        print(String(data: try! encoder.encode(configuration), encoding: .utf8)!)
        return configuration
    }
}
