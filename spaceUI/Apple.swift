//
//  Apple.swift
//  spaceUI
//
//  Created by Apple on 17/6/2021.
//

import SwiftUI



import SwiftUI
struct Apple: View {
    var body: some View{
        HStack (spacing: 0){
            Color.green
            Color.green
            Color.green
            Color.yellow
            Color.orange
            Color.red
            Color.purple
            Color.blue
        }
        .mask(
            Image (systemName:
                    "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
               
        ) .frame (width: 128, height: 128)
    }
    
}
extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
struct DayGraph: View {
    var body: some View{
        HStack (spacing: 25){
            Color.green
            
            Color.green
           
            Color.green
          
            Color.yellow
            
            Color.orange
            
            Color.red

            Color.purple

            Color.random
        }
//        .mask(
//            Image (systemName:
//                    "sun.max.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//
//        )
  //      .frame (width: 128, height: 128)
        
    }
    
}
struct Apple_Previews: PreviewProvider {
    static var previews: some View {
        DayGraph()
    }
}
