//
//  Settings.swift
//  HomeTasks
//
//  Created by Donny Wals on 05/07/2020.
//

import SwiftUI

struct SettingsView: View {
  @Namespace var namespace
  @State var flag = true
  
  var body: some View {
    HStack {
      if flag {
        Rectangle()
          .fill(Color.pink)
          .matchedGeometryEffect(id: "blockToCircle", in: namespace)
          .frame(width: 100, height: 100)
      }
      
      Spacer()
      
      Button("Text in the middle") {
        withAnimation(.easeInOut(duration: 2)) {
          flag.toggle()
        }
      }
      
      Spacer()

      VStack {
        Rectangle()
          .fill(Color.pink)
          .frame(width: 50, height: 50)
        
        if flag {
          Circle()
            .fill(Color.orange)
            .matchedGeometryEffect(id: "blockToCircle", in: namespace)
            .frame(width: 50, height: 50)
        }
        
        Rectangle()
          .fill(Color.pink)
          .frame(width: 50, height: 50)
      }
    }
  }
}
