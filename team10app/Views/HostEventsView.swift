//
//  HostEventsView.swift
//  team10app
//
//  Created by Sara Song on 10/28/21.
//

import SwiftUI

struct HostEventsView: View {
  
  var viewModel: ViewModel
  
  //CITATION: The following code for changing top nav bar color comes from here:
  //https://levelup.gitconnected.com/cracking-the-navigation-bar-secrets-with-swiftui-30e9b019502c
  init(viewModel: ViewModel) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0, blue: 1, alpha: 1)
    coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    
    UINavigationBar.appearance().tintColor = .white
    
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          Text("Upcoming Events")
            .bold()
            .font(.system(size: 22))
            .padding([.top, .horizontal])
          //Use loop here to create a card for each item in Events list
  //        ForEach(0..<viewModel.hostEvents.count, id: \.self) { index in
  //          HostEventCard(event: viewModel.hostEvents[index])
  //        }
          HostEventCard()
          HostEventCard()
          HostEventCard()
          HostEventCard()
          HostEventCard()
          HostEventCard()
          
          Spacer()
        }
      }
        .navigationTitle("Your Events")
    }
  }
}
