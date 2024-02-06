//
//  ContentView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//


import Foundation
import SwiftUI
import Alamofire

struct MainView: View {
    @ObservedObject var you: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    
    @State var selectedUser = false
    @State var selectedYCategories: String = ""
    @State var selectedYBCategories: String = ""
    @State var selectedJCategories: String = ""
    @State var selectedJBCategories: String = ""
    @State var showDetails = true
    @State var transition = false
    @State var alertShowing = false
    @State var is_yb_loaded = false
    @State var is_jb_loaded = false
    @State var ybcategories: [String] = []
    @State var jbcategories: [String] = []
    @State var is_yb_loading = true
    @State var is_jb_loading = true
    
    init() {
        you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
            
        })
        
        jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
            
            
        })
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if selectedUser == false {
                            you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
                                DispatchQueue.main.async { [self] in
                                    self.ybcategories = Array(Set(you.lcategories.map { value in
                                        
                                        value.components(separatedBy: "-").first!
                                    })).sorted()
                                    
                                    self.is_yb_loading = false
                                    self.selectedYBCategories = self.ybcategories.first!
                                    self.selectedYCategories = you.lcategories.filter { $0.contains(self.selectedYBCategories) }.first!
                                }
                            })
                        } else {
                            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                                DispatchQueue.main.async { [self] in
                                    self.jbcategories = Array(Set(jong.lcategories.map { value in
                                        
                                        value.components(separatedBy: "-").first!
                                    })).sorted()
                                    
                                    self.is_jb_loading = false
                                    self.selectedJBCategories = self.jbcategories.first!
                                    self.selectedJCategories = jong.lcategories.filter { $0.contains(self.selectedJBCategories) }.first!
                                }
                            })
                        }
                    }, label: {
                        if selectedUser == false {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                        } else {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                                .colorInvert()
                        }
                            
                    })
                }.padding(15.0)
                
                Spacer()
            }
            
            VStack {
                Button(action: { if selectedUser == false {
                    selectedUser = true
                    showDetails = false
                    
                    transition = true
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        transition = false
                    }
                } else {
                    selectedUser = false
                    showDetails = true
                    
                    transition = true
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        transition = false
                    }
                }}, label: {
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
                .disabled(transition)
                
                if showDetails {
                    HStack {
                        Picker("", selection: $selectedYBCategories) {
                            ForEach(ybcategories, id: \.self) { category in
                                Text(category).tag(category) }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: selectedYBCategories, perform: { value in
                            
                            self.selectedYCategories = you.lcategories.filter { $0.contains(value) }.first!
                        })
                        .padding(5)
                        
                        Picker("", selection: $selectedYCategories) {
                            ForEach(you.lcategories.indices, id: \.self) { index in
                                if !is_yb_loading {
                                    if you.lcategories[index].contains(selectedYBCategories) {
                                        Text(you.lcategories[index]).tag(you.lcategories[index])
                                    }
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .padding(5)
                    }
                    
                } else {
                    HStack {
                        Picker("", selection: $selectedJBCategories) {
                            ForEach(jbcategories, id: \.self) { category in
                                Text(category).tag(category) }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: selectedJBCategories, perform: { value in
                            
                            self.selectedJCategories = jong.lcategories.filter { $0.contains(value) }.first!
                        })
                        .padding(5)
                        
                        Picker("", selection: $selectedJCategories) {
                            ForEach(jong.lcategories.indices, id: \.self) { index in
                                if !is_jb_loading {
                                    if jong.lcategories[index].contains(selectedJBCategories) {
                                        Text(jong.lcategories[index]).tag(jong.lcategories[index])
                                    }
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .padding(5)
                    }
                }
                
                Button(action: {
                    alertShowing = false
                    
                    if selectedUser == false {
                        you.triggerGIT(url: "http://221.159.102.58:8000/api/trigger/upload/git", bodyl: ["user": "You", "category": selectedYCategories], completion: { (results) in
                            
                            alertShowing = true
                            
                        })
                    } else {
                        jong.triggerGIT(url: "http://221.159.102.58:8000/api/trigger/upload/git", bodyl: ["user": "Jong", "category": selectedJCategories], completion: { (results) in
                            
                            alertShowing = true
                            
                        })
                    }
                    
                })
                {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send")
                    }.padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                }
                .alert("Success", isPresented: $alertShowing) {
                    Button("OK", role: .cancel) {  }
                        .padding()
                }
            }
            
        }
        .onAppear {
            you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
                DispatchQueue.main.async { [self] in
                    self.ybcategories = Array(Set(you.lcategories.map { value in
                        
                        value.components(separatedBy: "-").first!
                    })).sorted()
                    
                    self.is_yb_loading = false
                    self.selectedYBCategories = self.ybcategories.first!
                    self.selectedYCategories = you.lcategories.filter { $0.contains(self.selectedYBCategories) }.first!
                }
            })
            
            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                DispatchQueue.main.async { [self] in
                    self.jbcategories = Array(Set(jong.lcategories.map { value in
                        
                        value.components(separatedBy: "-").first!
                    })).sorted()
                    
                    self.is_jb_loading = false
                    self.selectedJBCategories = self.jbcategories.first!
                    self.selectedJCategories = jong.lcategories.filter { $0.contains(self.selectedJBCategories) }.first!
                }
            })
        }
    }
}
    

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
