//
//  ScheduleView.swift
//  Tom
//
//  Created by 김종혁 on 2/1/24.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var you: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    
    @State var selectedUser = false
    @State var selectedYCategories: Int = 0
    @State var selectedJCategories: Int = 0
    @State var selectedYTimes: Int = 0
    @State var selectedJTimes: Int = 0
    @State var showDetails = true
    @State var transition = false
    @State var alertShowing = false
    
    init() {
        you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
            
            
        })
        
        you.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "You"], completion: { (scheduled_tasks) in
            
        })
        
        jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
            
            
        })
        
        jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
            
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
                                
                            })
                            
                            you.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "You"], completion: { (scheduled_tasks) in
                                
                            })
                        } else {
                            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                                
                            })
                            
                            jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
                                
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
                        Picker("", selection: $selectedYCategories) {
                            ForEach(you.lcategories.indices, id: \.self) { index in Text(you.lcategories[index]) }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: selectedYCategories, perform: { newValue in print("Selected Unit: \(you.lcategories[newValue])", "Selected Index: \(newValue)")
                        
                            if let scheduledTask = you.lscheduledTasks.last(where: {$0.task == you.lcategories[newValue]}) {
                                you.selectedLtimesid = Int(scheduledTask.scheduled_time!)
                            } else {
                                you.selectedLtimesid = 0
                            }
                        })
                        .padding(5)
                        
                        Picker("", selection: $you.selectedLtimesid) {
                            ForEach(you.ltimes.indices, id: \.self) { index in Text(you.ltimes[index]) }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: you.selectedLtimesid, perform: { newValue in
                            print(newValue)
                        })
                        .padding(5)
                    }
                } else {
                    HStack {
                        Picker("", selection: $selectedJCategories) {
                            ForEach(jong.lcategories.indices, id: \.self) { index in Text(jong.lcategories[index]) }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: selectedJCategories, perform: { newValue in print("Selected Unit: \(jong.lcategories[newValue])", "Selected Index: \(newValue)")
                            
                            if let scheduledTask = jong.lscheduledTasks.last(where: {$0.task == jong.lcategories[newValue]}) {
                                jong.selectedLtimesid = Int(scheduledTask.scheduled_time!)
                            } else {
                                jong.selectedLtimesid = 0
                            }
                        })
                        .padding(5)
                        
                        Picker("", selection: $jong.selectedLtimesid) {
                            ForEach(jong.ltimes.indices, id: \.self) { index in Text(jong.ltimes[index]) }
                        }
                        .onChange(of: jong.selectedLtimesid, perform: { newValue in
                            print(newValue)
                        })
                        .pickerStyle(.wheel)
                        .padding(5)
                    }
                }
                
                Button(action: {
                    alertShowing = false
                    
                
                    if selectedUser == false {
                        let registerScheduleRequest = RegisterScheduleRequest(user: "You", task: you.lcategories[selectedYCategories], scheduled_time: you.selectedLtimesid)
                        
                        you.registerSchedule(url: "http://221.159.102.58:8000/api/register/schedule", bodyl: registerScheduleRequest.toDictionary, completion: { (results) in
                            
                            alertShowing = true
                            
                        })
                    } else {
                        let registerScheduleRequest = RegisterScheduleRequest(user: "Jong", task: jong.lcategories[selectedJCategories], scheduled_time: jong.selectedLtimesid)
                        
                        jong.registerSchedule(url: "http://221.159.102.58:8000/api/register/schedule", bodyl: registerScheduleRequest.toDictionary, completion: { (results) in
                            
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
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
