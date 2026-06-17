//
//  ContentView.swift
//  IExpense
//
//  Created by Tarun on 16/06/26.
//

import SwiftUI
//struct User{
//    var firstName = "Tarun"
//    var lastName = "Kumar"
//}

//with class
@Observable //the values will update only when this keyword is given, else the values will not update with classes
class User{
    var firstName = "Tarun"
    var lastName = "Kumar"
}

//MARK: Showing and hiding views
struct SecondView: View{
    @Environment(\.dismiss) var dismiss
    let name : String
    
    var body: some View{
//        Text("Hello, \(name)")
        Button("Dismiss"){
            dismiss()
        }
    }
}

//Archiving
struct UserA : Codable{
    let firstName: String
    let lastName: String
}

//Actual app's usage
struct ExpenseItem: Identifiable,Codable { //if we keep as Identifiable protocol, swift can find elements automatically by id, UUID is mandatory for elements which are inside "Identifiable", now we can remove "id", in forEach loop.
    var id = UUID() //this can be used in forEach so that we find elements with uniqueID
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var item = [ExpenseItem](){
        didSet {
            if let encoded = try? JSONEncoder().encode(item){
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                item = decodedItems
                return
            }
        }
        
        item = []
    }
}

struct ContentView: View {
    @State private var user = User() //if this variable chanegs the view will be reloaded.
    
    @State private var showingSheet = false
    
    //deleting varaibles
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    //Working with userDefaults
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "tap")//0
    
    //MARK: Instead of using userdefaults, we can use the AppStorage it faster than userdefaults in retriveing the data store in app
    @AppStorage("tapCount") private var tapCount = 0
    
    //Archiving varaibles
    @State private var userA = UserA(firstName: "Tarun", lastName: "Kumar")
    
    //Actual app
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    
    var body: some View {
//        VStack {
//            Text("Hello, \(user.firstName) \(user.lastName)")
//            
//            TextField("First Name", text: $user.firstName)
//            TextField("Last Name", text: $user.lastName)
//        }
//        .padding()
        
        //MARK: we will get a bottomSheet here wow...
//        Button("Show sheet"){
//            showingSheet.toggle()
//        }
//        .sheet(isPresented: $showingSheet){
//            SecondView(name: "Tarun")
//        }
        
        //MARK: Deleting items using onDelete()
//        NavigationStack{ //without naviagtionStack also can achive delete, but with this we can add a edit button to delete
//            VStack{
//                List {
//                    ForEach(numbers, id: \.self){
//                        Text("Row \($0)")
//                    }.onDelete(perform: removeRows) //swipe the row from right to left to delete.can work without naviagtionStack
//                }
//                
//                Button("Add number"){
//                    numbers.append(currentNumber)
//                    currentNumber += 1
//                }
//            }
//            .toolbar {
//                EditButton()
//            }
//        }
        
        //MARK: Storing user setting with userDefaults
//        Button("Tap count: \(tapCount)"){
//            tapCount += 1
//            
//            UserDefaults.standard.set(tapCount, forKey: "tap")
//        }
        
        //MARK: Archiving swift objects with codable
//        Button("Save user"){
//            let encoder = JSONEncoder()
//            
//            if let data = try? encoder.encode(userA){
//                UserDefaults.standard.set(data, forKey: "userA")
//            }
//        }
        
        
        //MARK: Bulding actual project.
        NavigationStack{
            List {
                ForEach(expenses.item){ item in
//                    Text(item.name)
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.type)
                        }
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add expense", systemImage: "plus"){
//                    let expense = ExpenseItem(name: "Tarun", type: "Personal", amount: 50)
//                    expenses.item.append(expense)
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeRows(at offsets: IndexSet){
        numbers.remove(atOffsets: offsets)
    }
    
    //for actual items
    func removeItems(at offsets: IndexSet){
        expenses.item.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
