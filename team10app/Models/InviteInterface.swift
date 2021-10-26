//
//  InviteInterface.swift
//  team10app
//
//  Created by Kenny Hu on 10/25/21.
//

import Foundation
import Firebase

class InviteInterface{
    var Invites: [Invite] = []
    let invitesReference = Database.database().reference(withPath: "invites")
    
    
    func create(userKey: String, eventKey: String)-> String?{
        let keyResult :String? = self.invitesReference.childByAutoId().key
        if let userId = keyResult{
            let newInvite = Invite(userKey: "Sam",
                            eventKey:  "TomParty")
            self.invitesReference.child(userId).setValue(newInvite.toAnyObject())
            return userId
        }
        else{
            print("failed to add invite")
            return nil
        }
    }
    
    func read(){
        self.invitesReference.queryOrdered(byChild: "userKey").observe(.value, with: { snapshot in
            var newInvites: [Invite] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let invite = Invite(snapshot: snapshot) {
                    newInvites.append(invite)
                    print(invite.userKey)
                }
            }
            self.Invites = newInvites
        })
    }
    
    func update(key:String, updateVals:[String : Any]){
        self.invitesReference.child(key).updateChildValues(updateVals)
    }
    
    func delete(key:String ){
        self.invitesReference.child(key).removeValue()
    }
  
}
