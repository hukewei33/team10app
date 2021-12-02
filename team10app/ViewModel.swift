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
    let friendInterface: FriendInterface
    
    let hostsReference = Database.database().reference(withPath: "hosts")
    let eventsReference = Database.database().reference(withPath: "events")
    let usersReference = Database.database().reference(withPath: "users")
    let invitesReference = Database.database().reference(withPath: "invites")
    let friendReference = Database.database().reference(withPath: "friends")
    
    //  let appDelegate: AppDelegate = AppDelegate()
    
    @Published var hosts: [Host] = [Host]()
    @Published var events: [Event] = [Event]() //Upcoming events that just look like normal events on your Host index pg
    @Published var pastEvents: [Event] = [Event]() //Past events don't show up on Host index pg
    @Published var currentEvents: [Event] = [Event]() //Current events = ongoing events you can scan tickets for
    @Published var users: [User] = [User]()
    @Published var invites: [Invite] = [Invite]()
    @Published var pendingInvites: [Invite] = [Invite]()
    @Published var friends: [Friend] = [Friend]()
    @Published var pendingFriends: [Friend] = [Friend]()
    
    
    //For use in the inviteGuestsModal; build a list of users to send an invite to an event
    @Published var toBeInvited: [User] = [User]()
    
    @Published var searchResults: [User] = [User]()
    
    @Published var thisUser: User? = nil
    
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
        
        userInterface = UserInterface()
        eventInterface = EventInterface()
        hostInterface = HostInterface()
        inviteInterface = InviteInterface()
        friendInterface = FriendInterface()
        
        //why is this here??
        //indexEventHosts(eventKey: "JohnParty")
        
        getHosts()
        getEvents()
        getUsers()
        getInvites()
    }
    
    func login(username: String, pword: String) -> Bool {
        var hasher = Hasher()
        hasher.combine(pword)
        let passwordHash = hasher.finalize()
        
        for user in self.users {
            if (user.username == username && user.passwordHash == passwordHash) {
                self.thisUser = user
                getFriends(userKey:user.key)
                return true // login was successful
            }
        }
        return false // login failed
    }
    
    func logout() {
        self.thisUser = nil;
    }
    
    func loggedin()->String?{
        if let user = self.thisUser{
            return user.key
        }
        return nil
    }
    
    func indexEventGuests(eventKey: String) -> [User] {
        let guestIDList = self.invites.filter {$0.eventKey == eventKey}.map{$0.userKey}
        return self.users.filter {guestIDList.contains($0.key)}
    }
    
    //return an array where the first number is the first number is the number of current attendess and the second number is the size of the guest list
    func getEventAttendence(eventKey: String) -> [Int]{
        let eventInvites = self.invites.filter {$0.eventKey == eventKey}
        return [eventInvites.filter {$0.checkinStatus}.count,eventInvites.count]
    }
    
    func getAttendingFriends(eventKey: String)->[User]{
        let friendIDs = self.friends.map {$0.userKey2}
        
        var result = indexEventGuests(eventKey: eventKey).filter {friendIDs.contains($0.key)}
        result.sort {
            if $0.lastName != $1.lastName { // first, compare by last names
                return $0.lastName < $1.lastName
            }
            else { // All other fields are tied, break ties by first name
                return $0.firstName < $1.firstName
            }
        }
        return result
    }
    
    func indexEventHosts(eventKey:String) -> [User] {
      print("hullabaloo")
        print(eventKey)
//      print(self.hosts)
        let hostIDList = self.hosts.filter {$0.eventKey == eventKey}.map{$0.userKey}
        print(hostIDList)
      print(self.users)
        print(self.users.filter {hostIDList.contains($0.key)})
        return self.users.filter {hostIDList.contains($0.key)}
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
            if self.inviteInterface.create(userKey: user.key, eventKey: event.key) == nil{print("error in invite creation")}
        }
        self.clearToBeInvited()
    }
    
    func clearToBeInvited() {
        toBeInvited.removeAll()
    }
    
    func indexHostEvents() -> [Event] {
//         if let userKey = loggedin(){
//             let eventIDs: [String] = self.hosts.filter{$0.userKey == userKey }.map {$0.eventKey}
//             let myEvents = self.events.filter {eventIDs.contains($0.key)}
//             return myEvents
//         }
//         else{
//             print("not logged in")
//             return []
//         }
        let eventIDs: [String] = self.hosts.map {$0.eventKey}
        let myEvents = self.events.filter {eventIDs.contains($0.key)}
        //    self.events = myEvents
        return myEvents
    }
  
    func getHosts() {
        hostsReference.queryOrdered(byChild: "userKey").observe(.value, with: { snapshot in
            self.hosts.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let host = Host(snapshot: snapshot) {
                    self.hosts.append(host)
                }
            }
        })
    }
    
//    old getEvents
//    func getEvents() {
//        self.eventsReference.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
//            self.events.removeAll()
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                   let event = Event(snapshot: snapshot) {
//                    //print(event.name)
//                    self.events.append(event)
//                }
//            }
//        })
//    }
  
    func getEvents() {
        self.eventsReference.queryOrdered(byChild: "endTime").observe(.value, with: { snapshot in
            let curTime = Date().timeIntervalSinceReferenceDate
            self.events.removeAll()
            self.pastEvents.removeAll()
            self.currentEvents.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let event = Event(snapshot: snapshot) {
                    //past event
                    if event.endTime < curTime {self.pastEvents.append(event)}
                    //future event
                    else if event.startTime > curTime {self.events.append(event)}
                    //ongoing event
                    else {self.currentEvents.append(event)}
                }
            }
            self.pastEvents.sort(by: {$0.startTime < $1.startTime})
            self.events.sort(by: {$0.startTime < $1.startTime})
            self.currentEvents.sort(by: {$0.startTime < $1.startTime})
            
        })
    }
  
    
    func getUsers(){
        self.usersReference.queryOrdered(byChild: "firstName").observe(.value, with: { snapshot in
            self.users.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let user = User(snapshot: snapshot) {
                  print("user incoming")
                  print(user)
                    self.users.append(user)
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
                  print(invite)
                    if invite.inviteStatus{
                        self.invites.append(invite)
                    }
                    else{
                        self.pendingInvites.append(invite)
                    }
                    print(self.invites)
                    print(self.pendingInvites)
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
        print(events)
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
        print("index1")
//        if let userId = loggedin(){
        if true {
          print("index2")
//        let eventIDs = self.invites.filter{$0.userKey == userId}.map {$0.eventKey}
          let eventIDs = self.invites.filter{$0.userKey == "Tom" && $0.inviteStatus}.map {$0.eventKey}
          print("index3")
          let myEvents = self.events.filter {eventIDs.contains($0.key)}
            print("index4")
          return myEvents
        }
        else{
            print("not logged in")
            return []
        }
        
    }
  
    // Get all the users who are not invited to an event, display in InviteGuestsModal
    func getNotInvitedUsers(eventKey: String) -> [User] {
      let guestIDList = self.invites.filter {$0.eventKey == eventKey}.map{$0.userKey}
      return self.users.filter {!guestIDList.contains($0.key)}
    }
    
    //creates an event and host relationship, returns key of host (intermediate table)
    func createEvent(name: String, startTime: Date, endTime: Date, street1: String, street2: String?, city : String, zip: String , state:String, description : String?,attendenceVisible:Bool, friendsAttendingVisible:Bool)->String? {
        if let newEventID = self.eventInterface.create(name: name, startTime: startTime, endTime:endTime, street1: street1, street2: street2, city: city, zip: zip, state: state, description: description,attendenceVisible:attendenceVisible, friendsAttendingVisible:friendsAttendingVisible),
           //we need a way to get login and store the user info of this user
           let userID = loggedin(){
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
        //check the person scanning the id is one of the hosts
        if let scannerID = loggedin(),
           hostIDs.contains(scannerID){
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
    
    func getFriends(userKey: String){
        self.friendReference.queryOrdered(byChild: "userKey1").observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let friend = Friend(snapshot: snapshot) {
                    if friend.userKey1 == userKey{
                        if friend.accepted{
                            self.friends.append(friend)
                        }
                        else{
                            self.pendingFriends.append(friend)
                        }
                        
                    }
                }
            }
        })
    }
    
                                                                      
    func addFriend(userKey1: String, userKey2 : String){
        if let friendRelation1 = self.friendInterface.create(userKey1: userKey1, userKey2: userKey2)
        {
            if let friendRelation2 = self.friendInterface.create(userKey1: userKey2, userKey2: userKey1){
                self.friendInterface.update(key: friendRelation1, updateVals: ["twinKey" : friendRelation2])
                self.friendInterface.update(key: friendRelation2, updateVals: ["twinKey" : friendRelation1])
            }
            //second entry not created so we delete the first and try again
            self.friendInterface.delete(key: friendRelation1)
            print("unable to create second relationship in twin, failed to create friend request")
        }
        else{
            print("unable to create first relationship in twin, failed to create friend request")
        }
    }
    
                                                                      
    func acceptFriendInvite(acceptedInvite:Friend){
        self.friendInterface.update(key: acceptedInvite.key, updateVals: ["accepted" : true])
        self.friendInterface.update(key: acceptedInvite.twinKey, updateVals: ["accepted" : true])
        
    }
    
                                                                      
    //can be used to remove friend or turn down invite
    func rejectFriend(rejectedInvite:Friend){
        self.friendInterface.delete(key: rejectedInvite.twinKey)
        self.friendInterface.delete(key: rejectedInvite.key)
        
    }
  
                                                                      
    func searchUsers(query: String, eventKey: String) -> [User] {
        if query == "" {
            return []
        }
        let first_name_matches: [User] = self.users.filter{$0.firstName.lowercased().contains(query.lowercased())}
        let last_name_matches:  [User] = self.users.filter{$0.lastName.lowercased().contains(query.lowercased())}
        let userName_matches:  [User] = self.users.filter{$0.username.lowercased().contains(query.lowercased())}
        var result = Array(Set(first_name_matches).union(Set(last_name_matches)).union(Set(userName_matches)))
        result.sort {
            if $0.lastName != $1.lastName { // first, compare by last names
                return $0.lastName < $1.lastName
            }
            else { // All other fields are tied, break ties by first name
                return $0.firstName < $1.firstName
            }
        }
      
        //Get users who are already invited to this event
        let guestIDList = self.invites.filter {$0.eventKey == eventKey}.map{$0.userKey}
        //Filter out users who are already invited to the event, don't include in search results
        result = result.filter {!guestIDList.contains($0.key)}

        //needs to be added back in after login is implemented
        //      if let usr = self.currentUser {
        //        return result.filter{$0.id != usr.id}
        //      }
      
        self.searchResults =  result
        return result
    }
    
}
