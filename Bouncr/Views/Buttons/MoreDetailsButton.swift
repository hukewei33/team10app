//
//  MoreDetailsButton.swift
//  Bouncr
//
//  Created by Sara Song on 7/6/22.
//

import SwiftUI

struct MoreDetailsButton: View {
  
  //Add some fields here for event id, will determine action of button
  var event: Event
  var ongoing: Bool
  
  init(event: Event, ongoing: Bool){
    self.event = event
    self.ongoing = ongoing
  }
  
  var body: some View {
    
    NavigationLink("More Details", destination: HostEventDetailsView(event: event, ongoing: ongoing))
      .font(.system(size: 15))
      .padding(10)
      .frame(width: 300)
      .background(Color.white)
      .cornerRadius(10)
      .overlay(
          RoundedRectangle(cornerRadius: 10)
              .stroke(Color(#colorLiteral(red: 0.2588235294, green: 0, blue: 1, alpha: 1)), lineWidth: 1)
      )
      .padding(.bottom)
  }
}
