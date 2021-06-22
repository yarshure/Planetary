//
//  SwiftUIView.swift
//  spaceUI
//
//  Created by Apple on 21/6/2021.
//

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
   // var bigImage:Image
    var body: some View {
        Button("Dismiss Modal") {
            presentationMode.wrappedValue.dismiss()
        }
       // bigImage
    }
}
