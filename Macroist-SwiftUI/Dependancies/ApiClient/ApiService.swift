import ComposableArchitecture
import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ApiServiceProtocol {
    // -- Authentication --
    func createUser(email: String,
                    password: String) async throws
    func login(email: String,
               password: String) async throws
    func logout() async throws ->  Void
    // -- Database --
    func deleteMeal(key: DateEntryKey, id: UUID) async throws -> Void
    func deleteTodaysMeal(id: UUID) async throws -> Void
    func getMonthMeals(key: DateEntryKey) async throws -> [MacroMeal]
    func getDayMeals(key: DateEntryKey) async throws -> [MacroMeal]
    func addMeal(food: MacroMeal) async throws -> Void
    func updateMeal(food: MacroMeal) async throws -> Void
}

@globalActor
final actor ApiService: ApiServiceProtocol, GlobalActor {
    
    public static let shared: ApiService = .init()
    
    public static let mock: ApiServiceMock = .init()
    
    func createUser(email: String, password: String) async throws {
        // TODO: Decide if we need a response for register or if a success response code is enough.
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logout() async throws -> Void {
        // TODO: not sure why this needs to throw
        try Auth.auth().signOut()
    }
    
    func deleteMeal(key: DateEntryKey, id: UUID) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        
        // Get Document Id if exists
        guard let documentId = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .whereField(Keys.ID.ID, isEqualTo: id.uuidString)
            .getDocuments()
            .documents
            .first?
            .documentID else {
            // ID doesnt exist
            throw AppError.technicalError
        }
        
        // Attempt to delete
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .document(documentId)
            .delete()
    }
    
    func deleteTodaysMeal(id: UUID) async throws {
        return try await deleteMeal(key: DateEntryKey(.init()), id: id)
    }
    
    func getMonthMeals(key: DateEntryKey) async throws -> [MacroMeal] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        let documents = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .getDocuments()
            .documents
        
        var meals: [MacroMeal] = .init()
        
        for document in documents {
            meals.append(try document.data(as: MacroMeal.self))
        }
        
        return meals
    }

    func getDayMeals(key: DateEntryKey) async throws -> [MacroMeal] {
        let calender = Calendar(identifier: .iso8601)
        var dayMeals = try await getMonthMeals(key: key).filter {
            calender.isDate(key.date, equalTo: $0.timeStamp.dateValue(), toGranularity: .day)
        }
        dayMeals.sort {
            $0.timeStamp.dateValue() > $1.timeStamp.dateValue()
        }
        return dayMeals
    }
    
    func addMeal(food: MacroMeal) async throws -> Void {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(DateEntryKey(.init()).value)
            .addDocument(data: food.dictionary)
    }
    
    func updateMeal(food: MacroMeal) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        
        // Get Document Id if exists
        guard let documentId = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(food.dateKey.value)
            .whereField(Keys.ID.ID, isEqualTo: food.id.uuidString)
            .getDocuments()
            .documents
            .first?
            .documentID else {
            // ID doesnt exist
            throw AppError.technicalError
        }
        
        // Update the field
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(food.dateKey.value)
            .document(documentId)
            .updateData(food.dictionary)
    }
}

final class ApiServiceMock: ApiServiceProtocol {
    
    var userList: [(email: String, password: String)] = [(email: "admin@gmail.com",
                                                          password: "password")]
    let currnDate = Date()
    var mealList: [MacroMeal] = [.init(id: UUID(),
                                       dateKey: .init(),
                                       mealName: "Rolex Watch",
                                       ingredients: [.init(id: UUID(),
                                                           name: "da whole thang",
                                                           calories: 100,
                                                           carbs: 10,
                                                           fat: 10)])]
        
    func createUser(email: String, password: String) async throws {
        userList.append((email: email, password: password))
    }
    
    func login(email: String, password: String) async throws {
        guard userList.contains(where: {
            $0.email == email && $0.password == password
        }) else {
            throw AppError.authenticationError
        }
    }
    
    func logout() async throws {
        // no needa do nuthin
    }
    
    func deleteMeal(key: DateEntryKey, id: UUID) async throws {
        mealList.removeAll(where: {
            $0.id == id
        })
    }
    
    func deleteTodaysMeal(id: UUID) async throws {
        mealList.removeAll(where: {
            $0.id == id
        })
    }
    
    func getMonthMeals(key: DateEntryKey) async throws -> [MacroMeal] {
        return mealList.filter {
            $0.dateKey.value == key.value
        }
    }
    
    func getDayMeals(key: DateEntryKey) async throws -> [MacroMeal] {
        return mealList.filter {
            Calendar(identifier: .iso8601).isDateInToday($0.dateKey.date)
        }
    }
    
    func addMeal(food: MacroMeal) async throws {
        mealList.append(food)
    }
    
    func updateMeal(food: MacroMeal) async throws {
        guard let index = mealList.firstIndex(where: {
            $0.id == food.id
        }) else {
            return
        }
        mealList[index] = food
    }
    
}
