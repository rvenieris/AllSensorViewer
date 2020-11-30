//
//  LocationView.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject var lm:LocationManager
    
    var latitude: String  {
     return lm.location?.latitude.formatted ?? "- - -"
    }
    
    var longitude: String  {
     return lm.location?.longitude.formatted ?? "- - -"
    }
    
    var altitude: String  {
     return lm.location?.altitude.formatted ?? "- - -"
    }
    
    var placemarkName: String {
        
        return (lm.placemark?.name).orEmpty
    }
    
    
    var body: some View {
        VStack {
            Text("GPS")
                .font(.title2)
                .fontWeight(.bold)
            Row(label: "Latitude", value: latitude)
            Row(label: "Longitude", value: longitude)
            Row(label: "Altitude", value: altitude)
            Row(label: "Placemark", value: placemarkName)
        }.padding(.vertical, 20)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var lm:LocationManager = LocationManager()
    static var previews: some View {
        LocationView(lm:lm)
    }
}
