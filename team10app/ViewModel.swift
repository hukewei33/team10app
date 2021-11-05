//
//  ViewModel.swift
//  team10app
//
//  Created by Sara Song on 10/28/21.
//

import Foundation
import Combine
import Firebase

class ViewModel: ObservableObject {
    
    let userInterface: UserInterface
    let eventInterface: EventInterface
    let hostInterface: HostInterface
    let inviteInterface: InviteInterface
    
    let hostsReference = Database.database().reference(withPath: "hosts")
    let eventsReference = Database.database().reference(withPath: "events")
    let usersReference = Database.database().reference(withPath: "users")
    let invitesReference = Database.database().reference(withPath: "invites")
    
    //  let appDelegate: AppDelegate = AppDelegate()
    
    @Published var hosts: [Host] = [Host]()
    @Published var events: [Event] = [Event]()
    @Published var users: [User] = [User]()
    @Published var invites: [Invite] = [Invite]()
  
    //For use in the inviteGuestsModal; build a list of users to send an invite to an event
    @Published var toBeInvited: [User] = [User]()
  
    //@Published var thisUser: User = nil
    
    //  func createEvent(name: String, startTime: Date, street1: String, street2: String?, city : String, zip: String , state:String, description : String?)->String?{
    //      if let newEventID = self.eventInterface.create(name: name, startTime: startTime,street1:  street1, street2: street2,city: city,zip:zip,state: state, description: description ),
    //         let userID = self.userInterface.CurrentUser?.key {
    //          return self.hostInterface.create(userKey: userID, eventKey: newEventID)
    //      }
    //      else{
    //          print("failed create new event hosting")
    //          return nil
    //      }
    //  }
    
    init() {
        //lets keep the interfaces for CUD so we dont blow up this file :)
        
        //we also need to think about a login process for v2
        
        userInterface = UserInterface(userKey: "Tom")
        eventInterface = EventInterface()
        hostInterface = HostInterface(userKey: "Tom")
        inviteInterface = InviteInterface()
        getHosts(userKey: "Tom")
        getEvents()
        getUsers(userKey:"Tom")
        getInvites()
    }
    
    //For use in the inviteGuestsModal; add someone to the potential list
    func addPotentialInvite(user: User) {
      self.toBeInvited.append(user)
    }
  
    //For use in the inviteGuestsModal; remove someone from the potential list
    func removePotentialInvite(user: User) {
      self.toBeInvited = self.toBeInvited.filter {$0.key != user.key}
    }
  
    //For use in the inviteGuestsModal; use the toBeInvited list to send invites to ppl
    func sendInvites(event: Event) {
      for user in self.toBeInvited {
        self.inviteInterface.create(userKey: user.key, eventKey: event.key)
      }
      self.clearToBeInvited()
    }
  
    func clearToBeInvited() {
      toBeInvited.removeAll()
    }
    
    func indexHostEvents() -> [Event] {
        print("indexHostEvents!!!")
        //getHosts(userKey: "Tom")
        let eventIDs: [String] = self.hosts.map {$0.eventKey}
        let myEvents = self.events.filter {eventIDs.contains($0.key)}
        //    self.events = myEvents
        return myEvents
    }
    
    func getHosts(userKey: String) {
        hostsReference.queryOrdered(byChild: "userKey").observe(.value, with: { snapshot in
            self.hosts.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let host = Host(snapshot: snapshot) {
                    if host.userKey == userKey{
                        self.hosts.append(host)
                    }
                }
            }
            print("newHosts ", self.hosts)
            print("COUNT", self.hosts.count)
        })
        
    }
    
    func getEvents() {
        self.eventsReference.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            self.events.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let event = Event(snapshot: snapshot) {
                    //print(event.name)
                    self.events.append(event)
                }
            }
        })
    }
    
    func getUsers(userKey: String){
        self.usersReference.queryOrdered(byChild: "firstName").observe(.value, with: { snapshot in
          self.users.removeAll()
          for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
               let user = User(snapshot: snapshot) {
                  self.users.append(user)
                  print("SELF.USERS: ", self.users)
//                    if user.key == userKey{
//                        self.thisUser = user
//                    }
              }
          }
        })
    }
    
    func getInvites(){
        self.invitesReference.queryOrdered(byChild: "userKey").observe(.value, with: { snapshot in
          self.invites.removeAll()
          for child in snapshot.children {
              if let snapshot = child as? DataSnapshot,
                 let invite = Invite(snapshot: snapshot) {
                  self.invites.append(invite)
                  //print(invite.userKey)
              }
          }
        })
    }
    
    func eventsForHosts() -> [Event] {
        let eventIDs: [String] = self.hosts.map {$0.eventKey}
        let myEvents = self.events.filter {eventIDs.contains($0.key)}
        return myEvents
    }
    
    func viewEvent(key:String) -> Event?{
        let myEvents = self.events.filter {$0.key == key}
        if myEvents.count == 1{
            return myEvents[0]
        }
        else{
            print("event not found")
            return nil
        }
    }
    
    func indexGuestEvents()->[Event]{
        let eventIDs = self.invites.filter{$0.userKey == self.userInterface.CurrentUser?.key}.map {$0.eventKey}
        let myEvents = self.events.filter {eventIDs.contains($0.key)}
        return myEvents
    }
    
    //creates an event and host relationship, returns key of host (intermediate table)
    func createEvent(name: String, startTime: Date, endTime: Date, street1: String, street2: String?, city : String, zip: String , state:String, description : String?)->String? {
        if let newEventID = self.eventInterface.create(name: name, startTime: startTime, endTime:endTime, street1: street1, street2: street2, city: city, zip: zip, state: state, description: description),
           //we need a way to get login and store the user info of this user
           let userID = self.userInterface.CurrentUser?.key {
           return self.hostInterface.create(userKey: userID, eventKey: newEventID)
        }
        else{
            print("failed to create new event hosting")
            return nil
        }
    }
    
    func checkin(inviteKey:String)->Bool{
        //use invitekey to get invite
        let thisInvite = self.invites.filter{$0.key == inviteKey}.map{$0.eventKey}
        //use eventid of invite to get hosts
        let hostIDs = self.hosts.filter{thisInvite.contains($0.eventKey)}.map{$0.key}
        //check myid is one of the hosts
        if hostIDs.contains("hostID"){
            //update
            self.inviteInterface.update(key: inviteKey, updateVals: ["checkinStatus" : true,"checkinTime":Date().timeIntervalSinceReferenceDate])
            return true
        }
        else {

            return false
        }
    }
  
    func cascadeEventDelete(eventKey:String) {
        let relatedHostIDs = self.hosts.filter {$0.eventKey == eventKey} .map {$0.key }
        relatedHostIDs.forEach {self.hostInterface.delete(key: $0)}
        let relatedInviteIDs = self.invites.filter {$0.eventKey == eventKey} .map {$0.key }
        relatedInviteIDs.forEach {self.inviteInterface.delete(key: $0)}
        self.eventInterface.delete(key: eventKey)
    }
    

    
}
