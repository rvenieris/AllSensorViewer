//
//  MotionManager.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import Foundation
import CoreMotion

class MotionManager:NSObject, ObservableObject {
    var mm:CMMotionManager
    
//    var attitudeReferenceFrame: CMAttitudeReferenceFrame // Not used here
    
    @Published var deviceMotion: DeviceMotionData {
        willSet { objectWillChange.send() }
    }
    
    @Published var accelerometerMotion: AccelerometerData {
        willSet { objectWillChange.send() }
    }
    
    @Published var gyroMotion: GyroData {
        willSet { objectWillChange.send() }
    }
    
    @Published var magnetometerMotion: MagnetometerData {
        willSet { objectWillChange.send() }
    }
    
    
    init(updateIntervale: TimeInterval = 0.5) {
        mm = CMMotionManager()
        deviceMotion = DeviceMotionData()
        accelerometerMotion = AccelerometerData()
        gyroMotion = GyroData()
        magnetometerMotion = MagnetometerData()
        super.init()
        
        mm.deviceMotionUpdateInterval = updateIntervale
        mm.accelerometerUpdateInterval = updateIntervale
        mm.gyroUpdateInterval = updateIntervale
        mm.magnetometerUpdateInterval = updateIntervale
        
        
        mm.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {motion, error in
            guard self.no(error) else {return}
            self.deviceMotion.update(from: self.mm)
        })
        mm.startAccelerometerUpdates(to: OperationQueue.main, withHandler: {motion, error in
            guard self.no(error) else {return}
            self.accelerometerMotion.update(from: self.mm)
        })
        mm.startGyroUpdates(to: OperationQueue.main, withHandler: {motion, error in
            guard self.no(error) else {return}
            self.gyroMotion.update(from: self.mm)
        })
        mm.startMagnetometerUpdates(to: OperationQueue.main, withHandler: {motion, error in
            guard self.no(error) else {return}
            self.magnetometerMotion.update(from: self.mm)
        })


    }
    
    func no(_ error:Error?)->Bool {
        if let error = error {
            debugPrint("Error updating Device Motion")
            debugPrint(error)
            return false
        } // else
        return true
    }
}

protocol Vector3Protocol {
    var x: Double {get}
    var y: Double {get}
    var z: Double {get}
}

class Vector3:Vector3Protocol, ObservableObject {
    @Published var x: Double = 0
    @Published var y: Double = 0
    @Published var z: Double = 0
    func update(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    func update<T:Vector3Protocol>(from vector: T) {
        self.update(x: vector.x, y: vector.y, z: vector.z)
    }
}

class MotionData:NSObject, ObservableObject {
    
    @Published var status = "unnavailabe, not showing" {
        willSet { objectWillChange.send() }
    }
    
    @Published var vector = Vector3() {
        willSet { objectWillChange.send() }
        didSet { print(vector) }
    }
    
    @Published var updateInterval: TimeInterval = TimeInterval.greatestFiniteMagnitude {
        willSet { objectWillChange.send() }
    }
    
    func activityStatus(_ isAvailable:Bool, _ isActive:Bool)->String {
        return !isAvailable ? "unavailable" :
               !isActive ? "inactive" : "active"

    }
}


class DeviceMotionData:MotionData {
    
    @Published private(set) var data: CMDeviceMotion = CMDeviceMotion() {
        willSet { objectWillChange.send() }
    }
    
    
    
    func update(from mm: CMMotionManager) {

        let showing = mm.showsDeviceMovementDisplay ? "showing" : "not showing"
        self.status = activityStatus(mm.isDeviceMotionAvailable, mm.isDeviceMotionActive) +
                      ", \(showing)"
        
        self.updateInterval = mm.deviceMotionUpdateInterval

        guard let deviceMotion = mm.deviceMotion else { return }
        data = deviceMotion
    }
}

extension CMAcceleration: Vector3Protocol {}
class AccelerometerData:MotionData {
    
    @Published private(set) var data: CMAccelerometerData = CMAccelerometerData() {
        willSet { objectWillChange.send() }
    }
    
    func update(from mm: CMMotionManager) {
        self.status = activityStatus(mm.isAccelerometerAvailable, mm.isAccelerometerActive)

        guard let accelerometerData = mm.accelerometerData else { return }
        data = accelerometerData
        
        self.updateInterval = mm.accelerometerUpdateInterval
        self.vector.update(from: data.acceleration)

    }
}

extension CMRotationRate: Vector3Protocol {}
class GyroData:MotionData {
    
    @Published private(set) var data: CMGyroData = CMGyroData() {
        willSet { objectWillChange.send() }
    }
    
    func update(from mm: CMMotionManager) {
        self.status = activityStatus(mm.isGyroAvailable, mm.isGyroActive)

        guard let gyroData = mm.gyroData else { return }
        data = gyroData
        
        self.updateInterval = mm.gyroUpdateInterval
        
        self.vector.update(from: data.rotationRate)


    }
}

extension CMMagneticField: Vector3Protocol {}
class MagnetometerData:MotionData {
    
    @Published private(set) var data: CMMagnetometerData = CMMagnetometerData() {
        willSet { objectWillChange.send() }
    }
    
    func update(from mm: CMMotionManager) {
        self.status = activityStatus(mm.isMagnetometerAvailable, mm.isMagnetometerActive)

        guard let magnetometerData = mm.magnetometerData else { return }
        data = magnetometerData
        
        self.updateInterval = mm.magnetometerUpdateInterval
        self.vector.update(from: data.magneticField)

    }
}


