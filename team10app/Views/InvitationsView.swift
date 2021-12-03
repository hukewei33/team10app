//
//  InvitationsView.swift
//  team10app
//
//  Created by Grace Joseph on 10/29/21.
//

import Foundation
import SwiftUI

struct InvitationsView: View {
  
//  @ObservedObject var viewModel = ViewModel()
  @ObservedObject var viewModel: ViewModel
  @State var move = false
  @State var scroll = false
  
  @State var center = 0
  @State var cardID = 0
  @State var invitationArray = []
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel;
  }
  
  
    var body: some View {
      
      let personalInvites = self.viewModel.pendingInvites.filter{$0.userKey == self.viewModel.thisUser?.key}
      
      NavigationView {
        
        ScrollViewReader { scrollProxy in
          
        ScrollView(.vertical, showsIndicators: false) {
            
            if (!move){
              
              // RSVP Cards
              VStack(alignment: .leading) {
                  
                
                if (self.viewModel.thisUser != nil && personalInvites.count > 0){ // debugging
                  
                  Text("Incoming Invites")
                    .bold()
                    .font(.system(size: 22))
                    .padding([.trailing, .leading], 20)
                    .padding(.top, 15)
                  
                  List {
                    
                    ForEach(0..<personalInvites.count, id: \.self) { index in
                        
                      if #available(iOS 15.0, *) {
                        PendingInviteCard(viewModel: self.viewModel, invite: personalInvites[index])
                          .swipeActions(edge: .trailing) {
                            Button(action: {
                              print("accepted")
                              self.viewModel.acceptInvite(invite: personalInvites[index])
                            }){
                              HStack{
                                Text("Accept")
                                Image(systemName: "checkmark.circle.fill")
                                  .foregroundColor(.white)
                              }
                            }
                            .tint(.green)
                          }
                          .swipeActions(edge: .leading) {
                            Button(action: {
                              print("declined")
                              viewModel.inviteInterface.delete(key: personalInvites[index].key)
                            }){
                              HStack{
                                Text("Decline")
                                Image(systemName: "x.circle")
                                  .foregroundColor(.white)
                              }
                            }
                            .tint(.red)
                          }
                      } else {
                        // Fallback on earlier versions
                      }
                    }
                    
                  }
                  .listStyle(GroupedListStyle())
                  .frame(width: 400, height: CGFloat((self.viewModel.pendingInvites.filter{$0.userKey == "Tom"}.count)*72), alignment: .leading)
                    .onAppear {
                        UITableView.appearance().isScrollEnabled = false
                    }
                    .onAppear(perform: {
                            UITableView.appearance().contentInset.top = -35
                        })
                  
                  Text("Current Invites")
                    .bold()
                    .font(.system(size: 22))
                    .padding([.trailing, .leading], 20)
                    .padding(.top, 15)
                    .padding(.bottom, -5)
                  
                }
                
                
              }.padding(.top, (personalInvites.count > 0) ? 0 : 20)
              
              VStack {

                ForEach(0..<self.viewModel.indexGuestEvents().count, id: \.self) { index in

                  InviteCard(event: viewModel.indexGuestEvents()[index])
                     .offset(y: CGFloat(-100*index))
                     .frame(height: 200)
                     .onTapGesture {
                        self.move.toggle()
                        self.scroll.toggle()
                        self.center = index
                        self.cardID = index
                        self.invitationArray = viewModel.indexGuestEvents()
//                       withAnimation {
//                         scrollProxy.scrollTo(cardID)
//                       }
                       
                      }


                }

              }.animation(.spring())
                .padding(.top, 150)
              
            
            }
            else {
              
              HStack(alignment: .center) {
                
                
                Button(action: {
                  if (cardID > 0){
                    cardID -= 1
                  }
                }){
                  Image(systemName: "chevron.left")
                    .foregroundColor((cardID == 0) ? (.white) : Color(red: 66/255, green: 0, blue: 1.0, opacity: 1.0))
                    .font(.largeTitle)
                }
                
                
                VStack(alignment: .leading) {
                  
                  InviteCard(event: self.viewModel.indexGuestEvents()[cardID])
                  .frame(width: 300)
                  .padding(.top, 50)
                  .onTapGesture {
                    self.move.toggle()
                    self.scroll.toggle()
                  }
                 
                  
                }
                
                
                Button(action: {
                  if (cardID < self.viewModel.indexGuestEvents().count - 1){
                    cardID += 1
                  }
                }){
                  Image(systemName: "chevron.right")
                    .foregroundColor((cardID == self.viewModel.indexGuestEvents().count - 1) ? (.white) : Color(red: 66/255, green: 0, blue: 1.0, opacity: 1.0))
                    .font(.largeTitle)
                }
                
                
              }.padding([.leading, .trailing], 20)
              

            }
            
          }
          .animation(.spring())
          .navigationBarTitle("Invitations")
          
        }
        
          
      }
      .edgesIgnoringSafeArea([.top])
      .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
