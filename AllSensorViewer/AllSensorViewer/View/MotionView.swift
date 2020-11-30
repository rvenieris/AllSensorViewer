//
//  MotionView.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import SwiftUI

struct MotionView: View {
    var title:String
    @ObservedObject var motionData:MotionData
    var vector:Vector3 { motionData.vector}
    
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Row(label: "Status", value: motionData.status)
            Row(label: "Update Interval", value: motionData.updateInterval.formatted)
            Row(label: "x", value: vector.x.formatted)
            Row(label: "y", value: vector.y.formatted)
            Row(label: "z", value: vector.z.formatted)
        }.padding(.vertical, 20)

    }
}

struct MotionView_Previews: PreviewProvider {
    static var motionData = MotionData()
    static var previews: some View {
        MotionView(title: "Teste", motionData: motionData)
    }
}
