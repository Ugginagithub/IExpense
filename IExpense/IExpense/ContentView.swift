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

struct ContentView: View {
    @State private var user = User() //if this variable chanegs the view will be reloaded.
    
    @State private var showingSheet = false
    
    var body: some View {
//        VStack {
//            Text("Hello, \(user.firstName) \(user.lastName)")
//            
//            TextField("First Name", text: $user.firstName)
//            TextField("Last Name", text: $user.lastName)
//        }
//        .padding()
        
        //MARK: we will get a bottomSheet here wow...
        Button("Show sheet"){
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet){
            SecondView(name: "Tarun")
        }
    }
}

#Preview {
    ContentView()
}
