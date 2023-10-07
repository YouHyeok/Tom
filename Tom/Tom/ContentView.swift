//
//  ContentView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//

import SwiftUI

struct ContentView: View {
    var categories = ["Java", "React", "Vue"]
    @State var selectedUser = false
    @State var selectedCategories = false
    
    var body: some View {
        VStack {
            Button(action: { if selectedUser == false { selectedUser = true } else { selectedUser = false }}, label: { 
                    if selectedUser == false {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    } else {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .colorInvert()
                    }
                }
            )
            
            Picker("", selection: $selectedCategories) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send")
                }.padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
