//
//  ContentView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]) var trip: FetchedResults<Trip>
    
    @State private var showingAddView = false
    @State private var showingSettingsView = false
    
    var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        ForEach(trip) { trip in
                            NavigationLink(destination: TripPeopleView(trip: trip)) {
                                VStack(alignment: .leading, spacing: 10) { // Increased vertical spacing
                                    Text(trip.name!)
                                        .bold()
                                    HStack {
                                        Text(trip.startDate != nil ? formatDate(trip.startDate!) : "No Date")
                                        Text(" - ")
                                        Text(trip.endDate != nil ? formatDate(trip.endDate!) : "No Date")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }
                                .padding() // Padding for the rounded border
                                 // White background for list item
                                .cornerRadius(10) // Rounded corners
                            }
                        }
                        .onDelete(perform: deleteTrip)
                    }
                    .cornerRadius(10)
                    .background(Color.white)
                    .listStyle(.plain)
                }
                .navigationTitle("Trips")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Label("Add Trip", systemImage: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showingSettingsView.toggle()
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddTripView()
                }
                .sheet(isPresented: $showingSettingsView){
                    SettingsView()
                }
            }
            .navigationViewStyle(.stack)
            .background(Color.gray) // Grey background for the main view
        }

    private func deleteTrip(offsets: IndexSet) {
        withAnimation {
            offsets.map { trip[$0] }.forEach(managedObjContext.delete)
            do {
                try managedObjContext.save()
            } catch {
                print("Error deleting trip: \(error.localizedDescription)")
            }
        }
    }

}

#Preview {
    ContentView()
}
