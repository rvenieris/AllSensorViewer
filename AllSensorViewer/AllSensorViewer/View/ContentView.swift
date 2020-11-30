//
//  ContentView.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import SwiftUI

struct ContentView: View {
    @State var precision:Int = 10 {
        didSet  {
            defaultDoubleFormatDigits = precision
        }
    }
    var locationManager = LocationManager()
    var motionManager:MotionManager = MotionManager()
    
    var body: some View {
        VStack {
            Text("All Sensor View")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            List {
                LocationView(lm: locationManager) .background(Color("LightGray"))
                MotionView(title: "Device Motion", motionData: motionManager.deviceMotion)
                MotionView(title: "Acceleration", motionData: motionManager.accelerometerMotion)
                MotionView(title: "Gyroscope", motionData: motionManager.gyroMotion)
                MotionView(title: "Magnetometer", motionData: motionManager.magnetometerMotion)
                Stepper(
                    onIncrement: {
                        precision.stepUp(limit: 20)
                },
                    onDecrement: {
                        precision.stepDown(limit: 1)
                    }) {
                    Text("Precision: \(precision)")
                }
              
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
