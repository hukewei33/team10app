//
//  InterfaceTest.swift
//  team10appTests
//
//  Created by Kenny Hu on 10/30/21.
//
import Foundation
import XCTest
import Firebase
@testable import team10app




class RepoParsingTests: XCTestCase {
    let expired: TimeInterval = 10
    var expectation: XCTestExpectation!
    
    override func setUp() {
        expectation = expectation(description: "Able to perform interface calls")
    }
    
    //model tests
    
    
    func testcreateUser() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = UserInterface()
        if let newID = interface.create(firstName: "testval1", lastName : "testval2", email: "testval", password: "testval" , username: "abcedfg"){
            
            // When...
            testViewModel.getUsers { (elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.firstName, "testval1")
                XCTAssertEqual(newArray.first?.lastName, "testval2")
                XCTAssertEqual(newArray.first?.username, "abcedfg")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func test_UpdateUser() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = UserInterface()
        if let newID = interface.create(firstName: "testval1", lastName : "testval2", email: "testval", password: "testval" , username: "abcedfg"){
            interface.update(key: newID,updateVals: ["firstName": "testchanged"] )
            // When...
            testViewModel.getUsers { (elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.firstName, "testchanged")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
        }
        waitForExpectations(timeout: expired)
    }
    
    
    
    func testcreateEvent() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = EventInterface()
        if let newID = interface.create(name: "testevent1", startTime: Date() + (25 * 60),endTime: Date() + (45 * 60), street1: "testval", city: "testval2", zip: "testval", state: "testval",attendenceVisible: true , friendsAttendingVisible: false){
            
            // When...
            testViewModel.getEvents { (_,_,elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.name, "testevent1")
                XCTAssertEqual(newArray.first?.attendenceVisible, true)
                XCTAssertEqual(newArray.first?.city, "testval2")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func test_UpdateEvent() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = EventInterface()
        if let newID = interface.create(name: "testevent1", startTime: Date() + (25 * 60),endTime: Date() + (45 * 60), street1: "testval", city: "testval2", zip: "testval", state: "testval",attendenceVisible: true , friendsAttendingVisible: false){
            interface.update(key: newID,updateVals: ["name": "testchanged"] )
            
            // When...
            testViewModel.getEvents { (_,_,elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.name, "testchanged")
                XCTAssertEqual(newArray.first?.attendenceVisible, true)
                XCTAssertEqual(newArray.first?.city, "testval2")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
        
    }
    

    
    func testcreateInvite() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = InviteInterface()
        if let newID = interface.create(userKey: "testuserKey",eventKey: "testeventKey")
        {
            
            // When...
            testViewModel.getInvites(){ (_,elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey, "testuserKey")
                XCTAssertEqual(newArray.first?.checkinStatus, false)
                XCTAssertEqual(newArray.first?.checkinTime, nil)
                XCTAssertEqual(newArray.first?.eventKey, "testeventKey")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func test_UpdateInvite() {
        
        
        // Given...
        let testViewModel = ViewModel()
        let interface = InviteInterface()
        if let newID = interface.create(userKey: "testuserKey",eventKey: "testeventKey")
        {
            
            interface.update(key: newID,updateVals: ["userKey": "testchanged"] )
            testViewModel.getInvites(){ (_,elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey, "testchanged")
                XCTAssertEqual(newArray.first?.checkinStatus, false)
                XCTAssertEqual(newArray.first?.checkinTime, nil)
                XCTAssertEqual(newArray.first?.eventKey, "testeventKey")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func testcreateHost() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = HostInterface()
        if let newID = interface.create(userKey: "testuserKey",eventKey: "testeventKey")
        {
            
            // When...
            testViewModel.getHosts(){ (elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey, "testuserKey")
                XCTAssertEqual(newArray.first?.eventKey, "testeventKey")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func test_UpdateHost() {
        
        
        // Given...
        let testViewModel = ViewModel()
        let interface = HostInterface()
        if let newID = interface.create(userKey: "testuserKey",eventKey: "testeventKey")
        {
            
            interface.update(key: newID,updateVals: ["userKey": "testchanged"] )
            testViewModel.getHosts(){ (elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey, "testchanged")
                XCTAssertEqual(newArray.first?.eventKey, "testeventKey")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func testcreateFriend() {
        
        // Given...
        let testViewModel = ViewModel()
        let interface = FriendInterface()
        if let newID = interface.create(userKey1: "testUserKey1",userKey2: "testUserKey2",originUserId: "testuserKey1")
        {
            
            // When...
            testViewModel.getFriends{ (a,elems) in
                print(a)
                print(elems)
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey1, "testUserKey1")
                XCTAssertEqual(newArray.first?.userKey2, "testUserKey2")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    func test_UpdateFriend() {
        
        
        // Given...
        let testViewModel = ViewModel()
        let interface = FriendInterface()
        if let newID = interface.create(userKey1: "testUserKey1",userKey2: "testUserKey2", originUserId: "testuserKey1")
        {
            
            interface.update(key: newID,updateVals: ["userKey1": "testchanged"] )
            testViewModel.getFriends(){ (_,elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.userKey1, "testchanged")
                XCTAssertEqual(newArray.first?.userKey2, "testUserKey2")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
            
        }
        
        waitForExpectations(timeout: expired)
        
    }
    
    
    
    //viewmodel tests with async
    
    func test_sendInvites(){
        let testViewModel = ViewModel()
        let interface = InviteInterface()
        let newUser1 = User(firstName: "testfirstName",
                            lastName: "testlastName",
                            email:"testemail",
                            username:  "testusername",
                            profilePicURL: nil ,
                            passwordHash: "1",
                            key: "testinguserId1"
        )
        let newUser2 = User(firstName: "testfirstName",
                            lastName: "testlastName",
                            email:"testemail",
                            username:  "testusername",
                            profilePicURL: nil ,
                            passwordHash: "1",
                            key: "testinguserId2"
        )
        let newEvent1 = Event(name: "event1", startTime: Date() + (25 * 60), endTime: Date() + (45 * 60), street1: "teststreet1", street2: "teststreet2", city: "testcity", state: "pa", zip: "12345", description: "testdescription", key: "sendinvitetest",attendenceVisible:true,friendsAttendingVisible:false)
        testViewModel.addPotentialInvite(user: newUser1)
        testViewModel.addPotentialInvite(user: newUser2)
        if let newIDs = testViewModel.sendInvites(event: newEvent1){
            testViewModel.getInvites(){ (_,elems) in
                let newArray = elems.filter {$0.eventKey == "sendinvitetest"}
                XCTAssertEqual(newArray.first?.userKey, "testinguserId1")
                XCTAssertEqual(newArray.last?.userKey, "testinguserId2")
                self.expectation.fulfill()
                newIDs.forEach() {id in interface.delete(key: id)}
            }
        }
        waitForExpectations(timeout: expired)
        
        
    }
    
    func test_createEvent(){
        let testViewModel = ViewModel()
        let eventInterface = EventInterface()
        let hostInterface = HostInterface()
        if let (eventID,hostID) = testViewModel.createEvent(name: "testCreateEvent", startTime: Date() + (25 * 60), endTime: Date() + (55 * 60), street1: "random", street2: "random2", city: "random", zip: "random", state: "random", description: "random", attendenceVisible: true, friendsAttendingVisible: false, testing: true){
            testViewModel.getEvents(){ (_,_,elems) in
                let newArray = elems.filter {$0.key == eventID}
                XCTAssertEqual(newArray.first?.name, "testCreateEvent")
                //self.expectation.fulfill()
                eventInterface.delete(key: eventID)
            }
            testViewModel.getHosts(){ (elems) in
                let newArray = elems.filter {$0.key == hostID}
                XCTAssertEqual(newArray.first?.userKey, "testingID")
                XCTAssertEqual(newArray.first?.eventKey, eventID)
                self.expectation.fulfill()
                hostInterface.delete(key: hostID)
            }
            
        }
        waitForExpectations(timeout: expired)
    }
    
    func test_checkin(){
        let testViewModel = ViewModel()
        let interface = InviteInterface()
        let newUser1 = User(firstName: "testfirstName",
                            lastName: "testlastName",
                            email:"testemail",
                            username:  "testusername",
                            profilePicURL: nil ,
                            passwordHash: "1",
                            key: "Tom"
        )
        testViewModel.thisUser = newUser1
        if let newID = interface.create(userKey: "checkinTest",eventKey: "checkinTestEvent"){
            testViewModel.invites.append(Invite(userKey: "checkinTest",eventKey: "checkinTestEvent",key: newID))
            testViewModel.hosts.append(Host(userKey: "Tom", eventKey: "checkinTestEvent"))
            
//            let a = testViewModel.invites
//            let b = testViewModel.hosts
            let flag = testViewModel.checkin(inviteKey: newID)
                        if flag{
            testViewModel.getInvites(){ (_,elems) in
                let newArray = elems.filter {$0.key == newID}

                XCTAssertEqual(newArray.first?.checkinStatus, true)
                XCTAssertEqual(newArray.first?.checkinTime == nil, false)
                //XCTAssertEqual(newArray.first?.eventKey, "testeventKey")
                self.expectation.fulfill()
                interface.delete(key: newID)
                }
            }
            
        }
        
        waitForExpectations(timeout: expired)
    }
    
    func test_cascadeDelete(){
        let eventInterface = EventInterface()
        let hostInterface = HostInterface()
        let inviteInterface = InviteInterface()
        let testViewModel = ViewModel()
        if let eventID = eventInterface.create(name: "cascadeTest", startTime: Date() + (25 * 60),endTime: Date() + (45 * 60), street1: "testval", city: "testval2", zip: "testval", state: "testval",attendenceVisible: true , friendsAttendingVisible: false){
            if let inviteID1 = inviteInterface.create(userKey: "cascadeTest",eventKey: eventID),
               let inviteID2 = inviteInterface.create(userKey: "cascadeTest",eventKey: eventID){
                let inviteLocal1 = Invite(userKey: "cascadeTest", eventKey: eventID, key: inviteID1)
                let inviteLocal2 = Invite(userKey: "cascadeTest", eventKey: eventID, key: inviteID2)
                testViewModel.pendingInvites.append(inviteLocal1)
                testViewModel.pendingInvites.append(inviteLocal2)
                if let hostID1 = hostInterface.create(userKey: "cascadeTest",eventKey: eventID),
                   let hostID2 = hostInterface.create(userKey: "cascadeTest",eventKey: eventID){
                    let hostLocal1 = Host(userKey: "cascadeTest", eventKey: eventID, key: hostID1)
                    let hostLocal2 = Host(userKey: "cascadeTest", eventKey: eventID, key: hostID2)
                    testViewModel.hosts.append(hostLocal1)
                    testViewModel.hosts.append(hostLocal2)
                    testViewModel.cascadeEventDelete(eventKey: eventID)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        testViewModel.getEvents(){ (_,_,elems) in
                            let newArray = elems.filter {$0.key == eventID}
                            XCTAssertEqual(newArray.count,0)
                            //eventInterface.delete(key: eventID)
                            
                        }
                        testViewModel.getInvites(){ (elems,_) in
                            let newArray = elems.filter {$0.eventKey == eventID}
                            XCTAssertEqual(newArray.count,0)
                            //                        inviteInterface.delete(key: inviteID1)
                            //                        inviteInterface.delete(key: inviteID2)
                        }
                        testViewModel.getHosts(){ (elems) in
                            let newArray = elems.filter {$0.eventKey == eventID}
                            XCTAssertEqual(newArray.count,0)
                            //                        hostInterface.delete(key: hostID1)
                            //                        hostInterface.delete(key: hostID2)
                            self.expectation.fulfill()
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        waitForExpectations(timeout: expired)
    }
    
    func test_addFriend(){
        let testViewModel = ViewModel()
        let interface = FriendInterface()
        if let (id1,id2)=testViewModel.addFriend(userKey1: "testfriend1", userKey2: "testfriend2"){
            // When...
            testViewModel.getFriends{ (a,elems) in
                //print(a)
                //print(elems)
                let newArray = elems.filter {$0.key == id1 || $0.key == id2 }
                XCTAssertEqual(newArray.first?.userKey1, "testfriend1")
                XCTAssertEqual(newArray.first?.userKey2, "testfriend2")
                XCTAssertEqual(newArray.first?.twinKey, id2)
                XCTAssertEqual(newArray.last?.userKey1, "testfriend2")
                XCTAssertEqual(newArray.last?.userKey2, "testfriend1")
                XCTAssertEqual(newArray.last?.twinKey, id1)
                self.expectation.fulfill()
                interface.delete(key: id1)
                interface.delete(key: id2)
            }
            
        }
        waitForExpectations(timeout: expired)
        
    }
    
    func test_acceptFriend(){
        let testViewModel = ViewModel()
        let interface = FriendInterface()
        //hacky instance of friend
        
        if let (id1,id2)=testViewModel.addFriend(userKey1: "testfriend1", userKey2: "testfriend2"){
            // When...
            var newFriend = Friend(userKey1: "testfriend1", userKey2: "testfriend2", key: id1, originUserId: "testuserKey1")
            newFriend.twinKey = id2
            testViewModel.acceptFriendInvite(acceptedInvite: newFriend)
            testViewModel.getFriends{ (a,elems) in
                //print(a)
                //print(elems)
                let newArray = a.filter {$0.key == id1 || $0.key == id2 }
                XCTAssertEqual(newArray.first?.accepted, true)
                
                XCTAssertEqual(newArray.last?.accepted, true)
                self.expectation.fulfill()
                interface.delete(key: id1)
                interface.delete(key: id2)
            }
            
        }
        waitForExpectations(timeout: expired)
    }
    
    func test_rejectFriend(){
        let testViewModel = ViewModel()
        //hacky instance of friend
        
        if let (id1,id2)=testViewModel.addFriend(userKey1: "testfriend1", userKey2: "testfriend2"){
            // When...
            var newFriend = Friend(userKey1: "testfriend1", userKey2: "testfriend2", key: id1, originUserId: "testuserKey1")
            newFriend.twinKey = id2
            testViewModel.rejectFriend(rejectedInvite: newFriend)
            testViewModel.getFriends{ (a,elems) in
                //print(a)
                //print(elems)
                let newArray = elems.filter {$0.key == id1 || $0.key == id2 }
                XCTAssertEqual(newArray.count, 0)
                
                
                self.expectation.fulfill()
                
            }
            
        }
        waitForExpectations(timeout: expired)
        
    }
    
    func test_editProfile(){
        let testViewModel = ViewModel()
        let interface = UserInterface()
        
        if let newID = interface.create(firstName: "testval1", lastName : "testval2", email: "testval", password: "testval" , username: "abcedfg"){
            let newUser1 = User(firstName: "testval1",
                                lastName: "testval2",
                                email:"testval",
                                username:  "abcedfg",
                                profilePicURL: nil ,
                                passwordHash: "1",
                                key: newID
            )
            testViewModel.thisUser = newUser1
            testViewModel.editProfile(updateVals: ["firstName": "testchanged"] )
            // When...
            testViewModel.getUsers { (elems) in
                let newArray = elems.filter {$0.key == newID}
                XCTAssertEqual(newArray.first?.firstName, "testchanged")
                self.expectation.fulfill()
                interface.delete(key: newID)
            }
        }
        waitForExpectations(timeout: expired)
    }
   
    
    
}
