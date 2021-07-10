//
//  ContentView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 29/04/2020.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Place.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Place.title, ascending: true),
            NSSortDescriptor(keyPath: \Place.subtitle, ascending: true)
        ]) var places: FetchedResults<Place>
    
    @State private var showingMap = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if showingMap {
                    MapView().environment(\.managedObjectContext, moc)
                } else {
                    List {
                        ForEach(places, id: \.self) { place in
                            NavigationLink(destination: DetailsView(place: place)) {
                                CellView(place: place)
                            }
                        }
                        .onDelete(perform: deletePlaces)
                    }
                }
            }
            .navigationBarItems(
                leading: EditButton().opacity(showingMap ? 0 : 1),
                trailing:  Button(action: {
                    showingMap.toggle()
                }) {
                    Image(systemName: showingMap ? "list.bullet" : "mappin.and.ellipse")
                        .frame(width: 40, height: 40)
                }
            )
            .navigationBarTitle(showingMap ? "" : "Saved places")
        }
       .onAppear(perform: createExampleData)
    }
    
    private func deletePlaces(at offsets: IndexSet) {
        for offset in offsets {
            let place = places[offset]
            moc.delete(place)
        }
        try? moc.save()
    }
    
    // MARK: - Default data for testing
    private func createExampleData() {
        if places.isEmpty {
            let bratislava = Place(context: self.moc)
            bratislava.id = UUID()
            bratislava.title = "Bratislava, city"
            bratislava.subtitle = "Capital of Slovakia."
            bratislava.details = "With a population of about 430,000, it is one of the smaller capitals of Europe but still the country's largest city. The greater metropolitan area is home to more than 650,000 people. Bratislava is in southwestern Slovakia, occupying both banks of the River Danube and the left bank of the River Morava. Bordering Austria and Hungary, it is the only national capital that borders two sovereign states.\n\nThe city's history has been influenced by people of many nations and religions, including Austrians, Bulgarians, Croats, Czechs, Germans, Hungarians, Jews, Serbs[6] and Slovaks. It was the coronation site and legislative center of the Kingdom of Hungary from 1536 to 1783, and has been home to many Slovak, Hungarian and German historical figures."
            bratislava.latitude = 48.148598
            bratislava.longitude = 17.107748
                
            let spisskyhrad = Place(context: self.moc)
            spisskyhrad.id = UUID()
            spisskyhrad.title = "Spiš Castle"
            spisskyhrad.subtitle = "One of the largest castle sites in Central Europe."
            spisskyhrad.details = "The castle is situated above the town of Spišské Podhradie and the village of Žehra, in the region known as Spiš (Hungarian: Szepes, German: Zips, Polish: Spisz, Latin: Scepusium). It was included in the UNESCO list of World Heritage Sites in 1993 (together with the adjacent locations of Spišská Kapitula, Spišské Podhradie and Žehra). This is one of the biggest European castles by area (41 426 m²).\n\nSpiš Castle was built in the 12th century on the site of an earlier castle. It was the political, administrative, economic and cultural center of Szepes County of the Kingdom of Hungary. Before 1464, it was owned by the kings of Hungary, afterward (until 1528) by the Zápolya family, the Thurzó family (1531–1635), the Csáky family (1638–1945), and (since 1945) by the state of Czechoslovakia then Slovakia."
            spisskyhrad.latitude = 49.000556
            spisskyhrad.longitude = 20.768333
            
            let budmerice = Place(context: self.moc)
            budmerice.id = UUID()
            budmerice.title = "Budmerice Manor House"
            budmerice.subtitle = "Built at the end of the 19th century by the Palffy family."
            budmerice.details = "The Palffy family is dominating the village, where people lived since the New Stone Age. The vast English park on the outskirts of Budmerice is lined by a long vista of poplars, at the end of which unprepared visitors are astonished by a breathtaking view of the picturesque manor house that was commissioned to be built by Ján Pálffy, supposedly nicknamed “the last Carpathian romantic”. This wealthy count reportedly fell in love with a charming French noblewoman, to whom he wanted to propose. Therefore, in order to make her feel at home, he had had his residences rebuilt and redecorated in the fashion of the French manor houses. \n\nUnfortunately, by the time the construction works on Budmerice Manor House and other residences (for example the castle in Bojnice) were finished, his beloved countess married someone else. After that, Ján Pálffy never married. Nowadays, the interior of the Budmerice Manor House is closed to the public. The building is waiting for restoration and its further fate has yet to be decided. \n\nIt may once again serve as the Slovak Writers Home, just like it used to be from after the end of World War II until 2011, when it offered a peaceful and quiet environment to Slovak writers such as Margita Figuli, Ivan Krasko, Ján Smrek or Rudolf Dobiáš, just to mention a few."
            budmerice.latitude = 48.363139
            budmerice.longitude = 17.395991
            
            let bojnice = Place(context: self.moc)
            bojnice.id = UUID()
            bojnice.title = "Bojnice Castle"
            bojnice.subtitle = "Romanesque castle, built in the 12th century."
            bojnice.details = "Bojnice Castle was first mentioned in written records in 1113, in a document held at the Zobor Abbey. Originally built as a wooden fort, it was gradually replaced by stone, with the outer walls being shaped according to the uneven rocky terrain. Its first owner was Matthew III Csák, who received it in 1302 from the King Ladislaus V of Hungary. \n\nLater, in the 15th century, it was owned by King Matthias Corvinus, who gave it to his illegitimate son John Corvinus in 1489. Matthias liked to visit Bojnice and it was here that he worked on his royal decrees. He used to dictate them under a linden tree, which is now known as the 'Linden tree of King Matthias'. After his death the castle became the property of the Zápolya family (see John Zápolya). The Thurzós, the richest family in the northern Kingdom of Hungary, acquired the castle in 1528 and undertook its major reconstruction. The former fortress was turned into a Renaissance castle. From 1646 on, the castle's owners were the Pálffys, who continued to rebuild the castle.\n\nFinally, the last famous castle owner from the Pálffy family, Count János Ferenc Pálffy (1829-1908), made a complex romantic reconstruction from 1888 to 1910 and created today's imitation of French castles of the Loire valley. He not only had the castle built, but also was the architect and graphic designer. He utilized his artistic taste and love for collecting pieces of art.[citation needed] He was one of the greatest collectors of antiques, tapestries, drawings, paintings and sculptures of his time. After his death and long quarrels, his heirs sold many precious pieces of art from the castle and then, on 25 February 1939, sold the castle, the health spa, and the surrounding land to Czech entrepreneur Jan Antonín Baťa (owner the shoe company Bata).\n\nAfter 1945, when Baťa's property was confiscated by the Czechoslovak government, the castle became the seat of several state institutions. On 9 May 1950, a fire broke out in the castle, but it was rebuilt at government expense. After this reconstruction, a museum specializing in the documentation and presentation of the era of architectural neo-styles was opened here. Bojnice Museum is now part of the Slovak National Museum today."
            bojnice.latitude = 48.78
            bojnice.longitude = 18.577778
            
            let strbskepleso = Place(context: self.moc)
            strbskepleso.id = UUID()
            strbskepleso.title = "Štrbské pleso, Slovakia"
            strbskepleso.subtitle = "Picturesque mountain lake in the High Tatras."
            strbskepleso.details = "It is the second-largest glacial lake on the Slovak side of the High Tatras, after Veľké Hincovo pleso. Maximum depth is 20 metres (66 ft).\n\nŠtrbské pleso is now part of the neighborhood of Štrbské Pleso (spelled with a capital P). It is on the municipal lands of the village of Štrba, after which Štrbské pleso ('Lake Štrba') is now named. The word pleso ('tarn') is applied only to mountain lakes. The locals used to call it 'the puddle' or 'pond' (mláka) in the past. It is the second-largest glacial lake on the Slovak side of the High Tatras, after Hincovo Pleso, to which it loses by 0.8 acres (3,200 m2). It is fed by underground springs and has no visible outflow stream. Its surface remains frozen for around 155 days per year."
            strbskepleso.latitude = 49.1225
            strbskepleso.longitude = 20.058333
            
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
