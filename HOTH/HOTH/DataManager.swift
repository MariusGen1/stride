//
//  DataManager.swift
//  HOTH
//
//  Created by Marius Genton on 3/3/24.
//

import Foundation
import SwiftUI
import CryptoKit
import FirebaseCore
import FirebaseFirestore

class DataManager {
    
    static func getWeeklyStats(_ userID: String, activities: [Activity]) async -> ([(String, Double)], [(ActivityType, Int)]) {
        //return ([("M", 5), ("T", 3), ("W", 2), ("R", 5), ("F", 6), ("Sa", 3), ("Su", 1)], [(ActivityType.Ride, 50), (ActivityType.Walk, 30)])
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let currentWk = calendar.component(.weekOfYear, from: Date())
        
        let activitiesThisWk = activities.filter { a in
            let wk = calendar.component(.weekOfYear, from: a.date)
            print(currentWk, wk, a.date)
            return currentWk == wk
        }
        
        var r = [(String, Double)]()
        
        for (dayNr, s) in [(2, "M"), (3, "T"), (4, "W"), (5, "R"), (6, "F"), (7, "Sa"), (1, "Su")] {
            let activitiesForDay = activitiesThisWk.filter { a in
                print(dayNr, calendar.component(.weekday, from: a.date))
                return dayNr == calendar.component(.weekday, from: a.date)
            }
            var sum = 0.0
            print(s, activitiesForDay.count)
            for act in activitiesForDay {
                print(act.date)
                sum += co2saving(distance: act.distance)
            }
            r.append((s, sum))
        }
        
        return (r, [])
    }
    
    static func getFriendActivities(_ user: User) async -> [Activity] {
        var acts = [Activity]()
        
        for follow in user.following {
            let fullUser = await getUserByID(follow)
            let n = await getUserActivities(userID: fullUser!.id)
            acts = acts + n
        }
        
        return acts
    }
    
    static func isLiked(_ activityID: String) -> Bool {
        return UserDefaults.standard.bool(forKey: activityID)
    }

    static func toggleLike(userID: String, activity: Activity) {
        let before = isLiked(activity.id)
        UserDefaults.standard.setValue(before ? activity.likeCount - 1 : activity.likeCount + 1, forKey: activity.id)
        Task { await writeLikeCount(userID ,activityID: activity.id, count: before ? activity.likeCount - 1 : activity.likeCount + 1) }
    }
    
    static func writeLikeCount(_ userID: String, activityID: String, count: Int) async {
        let ref = Firestore.firestore().collection("users").document(userID).collection("activities").document(activityID)
        
        do {
            try await ref.setData(["likeCount": count], merge: true)
        } catch { }
    }
    
    static func getUserActivities(userID: String) async -> [Activity] {
        let ref = Firestore.firestore().collection("users").document(userID).collection("activities")
        
        do {
            let docs = try await ref.getDocuments()
            
            var r = [Activity]()
            
            for doc in docs.documents {
                r.append(Activity(doc.data()))
            }
            
            return r
        } catch {}
        
        return []
    }
    
    static func getAllUsers() async -> [(String, String, String)] {
        let ref = Firestore.firestore().collection("users")
        
        do {
            let docs = try await ref.getDocuments().documents
            
            var r = [(String, String, String)]()
            
            for doc in docs {
                let name = doc["name"] as? String ?? ""
                let username = doc["username"] as? String ?? ""
                let id = doc["id"] as? String ?? ""
                if name != "" && username != "" && id != "" { r.append((name, username, id))}
            }
            
            return r
            
        } catch {}
        
        return []
    }
    
    static func uploadActivity(_ activity: Activity, user: User) async {
        let randID = randomActivityID()
        let ref = Firestore.firestore().collection("users").document(user.id).collection("activities").document(randomActivityID())
        
        do {
            try await ref.setData([
                "name": activity.name,
                "description": activity.description,
                "distance": activity.distance,
                "userName": activity.userName,
                "id": randID,
                "likeCount": 0,
                "activityType": activityTypeToString(activity.activityType),
                "date": activity.date.timeIntervalSince1970
            ])
        } catch { print("Issssueeeee") }
    }
    
    static private func activityTypeToString(_ a: ActivityType) -> String {
        if a == .Ride { return "Ride" }
        return "Walk"
    }
    
    static func setAchievement(_ user: User, achievementID: String) async {
        let ref = Firestore.firestore().collection("users").document(user.id)
    }
    
    static func follow(currentUser: User, accountToFollow: String) async {
        let ref = Firestore.firestore().collection("users").document(currentUser.id)
        
        do {
            try await ref.setData(["following": currentUser.following + [accountToFollow]], merge: true)
        } catch {}
    }

    static func createAccount(username: String, pwd: String, name: String) async -> User {
        let db = Firestore.firestore()
        let uid = userHash(uname: username, pwd: pwd)
        let ref = db.collection("users").document(uid)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let date = dateFormatter.string(from: Date())
        
        do {
            try await ref.setData(["name": name, "id": uid, "username": username, "creationDate": date, "following": [], "achievements": []])
        } catch { print("Failed account creation :/") }
        saveAuthInfo(username: username, pwd: pwd)
        
        return User(name: name, id: uid, username: username, accountCreationDate: date, following: [], achievements: [])
    }
    
    static func attemptAutoAuth() async -> User? {
        
        print("Attempting to auto-authenticate")
        let username = UserDefaults.standard.string(forKey: USERNAME_KEY)
        let pwd = UserDefaults.standard.string(forKey: PASSWORD_KEY)
        if username != nil && pwd != nil { return await auth(username: username!, pwd: pwd!) }
        print("Failed to auto-authenticate")
        return nil
    }
    
    static func auth(username: String, pwd: String) async -> User? {
        
        let uid = userHash(uname: username, pwd: pwd)
        let u = await getUserByID(uid)
        if u != nil { saveAuthInfo(username: username, pwd: pwd) }
        return u
    }
    
    
    static func getUserByID(_ id: String) async -> User? {
        let ref = Firestore.firestore().collection("users").document(id)
        
        do {
            let data = try await ref.getDocument()
            if !data.exists { return nil }

            let acts = data["activities"] as? [[String: Any]] ?? []
            var activities = [Activity]()
            for act in acts {
                activities.append(Activity(act))
            }
            return User(name: data["name"] as! String, id: data["id"] as! String, username: data["username"] as! String, accountCreationDate: data["creationDate"] as! String, following: data["following"] as? [String] ?? [], achievements: data["achievements"] as? [String] ?? [])
        } catch {
            print("Auth failed!")
        }
        
        return nil
    }
    
    static func removeAutoLogin() {
        saveAuthInfo(username: "", pwd: "")
    }
    
    static private func saveAuthInfo(username: String, pwd: String) {
        UserDefaults.standard.setValue(username, forKey: USERNAME_KEY)
        UserDefaults.standard.setValue(pwd, forKey: PASSWORD_KEY)
        print("Saved login credentials for future use")
    }
    
    static private func userHash(uname: String, pwd: String) -> String {
        let s = uname + pwd
        return hash(data: s.data(using: .utf8)!)
    }
    
    static private func hash(data: Data) -> String {
        let digest = SHA256.hash(data: data)
        let hashString = digest
            .compactMap { String(format: "%02x", $0) }
            .joined()
        return hashString
    }
    
    static private func randomActivityID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<20).map{ _ in letters.randomElement()! })
    }
    
    
    
}

struct Achievement {
    let name: String
    let description: String
    let image: Image
}

struct Activity {
    let name: String
    let description: String
    let activityType: ActivityType
    let distance: Int
    let profilePhoto: Image
    let userName: String
    let likeCount: Int
    let id: String
    let date: Date
    
    init(name: String, description: String, activityType: ActivityType, distance: Int, profilePhoto: Image, userName: String, likeCount: Int, id: String, date: Date) {
        self.name = name
        self.description = description
        self.activityType = activityType
        self.distance = distance
        self.profilePhoto = profilePhoto
        self.userName = userName
        self.likeCount = likeCount
        self.id = id
        self.date = date
    }
    
    init(_ dict: [String: Any]) {
        self.name = dict["name"] as! String
        self.description = dict["description"] as! String
        self.activityType = activityTypeFromString(dict["activityType"] as! String)
        self.distance = dict["distance"] as! Int
        self.profilePhoto = Image("")
        self.userName = dict["userName"] as! String
        self.likeCount = dict["likeCount"] as! Int
        self.id = dict["id"] as! String
        self.date = Date(timeIntervalSince1970: (dict["date"] as? Double ?? Date().timeIntervalSince1970))
    }
}

func activityTypeFromString(_ s: String) -> ActivityType {
    if s == "Ride" { return .Ride }
    return .Walk
}

struct WeeklyStats {
    let co2ByDay: [Int]
    let co2ByActivityType: [ActivityType: Int]
}

struct User {
    let name: String
    let id: String
    let username: String
    let accountCreationDate: String
    let following: [String]
    let achievements: [String]
}
