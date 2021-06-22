//
//  ContentView.swift
//  spaceUI
//
//  Created by Apple on 11/6/2021.
//

import SwiftUI
    /// A SpacePhoto contains information about a single day's photo record
    /// including its date, a title, description, etc.
struct SpacePhoto {
    //var id: String
    
        /// The title of the astronomical photo.
    var title: String
    
        /// A description of the astronomical photo.
    var description: String
    
        /// The date the given entry was added to the catalog.
    var date: Date
    var copyright:String?
    var image:UIImage?
        /// A link to the image contained within the entry.
    var url: URL?
    var hdurl:URL?
    var media_type:String
    //static let  dateFormatter:DateFormatter =  DateFormatter()
    func save() async{
        
    }
    var imageURL:URL {
        get {
            if let hdurl = hdurl {
                return hdurl
            }else {
                return url!
            }
        }
    }
    var smallImage:URL {
        get {
            
            let dateString = SpacePhoto.sDateFormatter.string(from: date)
            return URL(string: "https://apod.nasa.gov/apod/calendar/S_\(dateString).jpg")!
        }
    }

}
extension Animation {
    static let openCard = Animation.spring(response: 0.45, dampingFraction: 0.9)
    static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
    static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}
extension SpacePhoto: Identifiable {
    var id: Date { date }
}

extension SpacePhoto: Codable {
    enum CodingKeys: String, CodingKey {
        //case id = "sid"
        case title
        case description = "explanation"
        case date
        case copyright
        case url = "url"
        case hdurl = "hdurl"
        case media_type
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy =
            .formatted(SpacePhoto.dateFormatter)

        self = try JSONDecoder()
            .decode(SpacePhoto.self, from: data)
    }

}
extension SpacePhoto {
    //https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&start_date=2017-07-08&end_date=2017-07-10
    //https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2017-07-08
    static let urlTemplate = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    static let dateFormat = "yyyy-MM-dd"
    static let sdateFormat = "yyMMdd"
    
    static var sDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.sdateFormat
        return formatter
    }
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.dateFormat
        return formatter
    }
    
    static func requestFor(date: Date) -> URL {
        let dateString = SpacePhoto.dateFormatter.string(from: date)
        return URL(string: "\(SpacePhoto.urlTemplate)&date=\(dateString)")!
    }
    static func requestForLast(date: Date,day:Int) -> URL {
        let dateString = SpacePhoto.dateFormatter.string(from: date)
        let sec:TimeInterval = 3600 *  24 * Double(day)
        let dEnt = date - sec
        let endString = SpacePhoto.dateFormatter.string(from: dEnt)
        return URL(string: "\(SpacePhoto.urlTemplate)&start_date=\(endString)&end_date=\(dateString)")!
    }
    private static func parseDate(
        fromContainer container: KeyedDecodingContainer<CodingKeys>
    ) throws -> Date {
        let dateString = try container.decode(String.self, forKey: .date)
        guard let result = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .date,
                in: container,
                debugDescription: "Invalid date format")
        }
        return result
    }
    
    private var dateString: String {
        Self.dateFormatter.string(from: date)
    }
}
extension SpacePhoto {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: .title)
//        description = try container.decode(String.self, forKey: .description)
//        date = try Self.parseDate(fromContainer: container)
//        url = try container.decode(URL.self, forKey: .url)
//        copyright = try container.decode(String.self, forKey: .copyright)
//    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(dateString, forKey: .date)
    }
}
struct SavePhotoButton: View {
    var photo: SpacePhoto
    @State private var isSaving = false
    
    var body: some View {
        Button {
            async {
                isSaving = true
                await photo.save()
                isSaving = false
            }
        } label: {
            Text("Save")
                .opacity(isSaving ? 0 : 1)
                .overlay {
                    if isSaving {
                        ProgressView()
                    }
                }
        }
        .disabled(isSaving)
        .buttonStyle(.bordered)
    }
}
struct SquishableButtonStyle: ButtonStyle {
    var fadeOnPress = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
struct CardActionButton: View {
    var label: LocalizedStringKey
    var systemImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(Font.title.bold())
                .imageScale(.large)
                .frame(width: 44, height: 44)
                .padding()
                .contentShape(Rectangle())
                .foregroundColor(.mint)
                
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
        .accessibility(label: Text(label))
    }
}
extension SpacePhoto {
    
        /// Defines how the `Ingredient`'s title should be displayed in card mode
    struct CardTitle {
        var color = Color.black
        var rotation = Angle.degrees(0)
        var offset = CGSize.zero
        var blendMode = BlendMode.normal
        var opacity: Double = 1
        var fontSize: Double = 1
    }
    
        /// Defines a state for the `Ingredient` to transition from when changing between card and thumbnail
    struct Crop {
        var xOffset: Double = 0
        var yOffset: Double = 0
        var scale: Double = 1
        
        var offset: CGSize {
            CGSize(width: xOffset, height: yOffset)
        }
    }
    
        /// The `Ingredient`'s image, useful for backgrounds or thumbnails
//    var image: Image {
//        Image("ingredient/\(id)", label: Text(name))
//            .renderingMode(.original)
//    }
}
struct PhotoView: View {
    var photo: SpacePhoto
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel = ViewModel()
    var style: Style
    var closeAction: () -> Void = {}
    var flipAction: () -> Void = {}
    enum Style {
        case cardFront
        case cardBack
        case thumbnail
    }
    var download:ImageDownloader
    var displayingAsCard: Bool {
        style == .cardFront || style == .cardBack
    }
//    var image:Image {
//
//    }
    let saver = ImageSaver()
    @State var bigImage:Image?
    @State private var isPresented = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if photo.media_type == "video" {
               
                WebView(url: photo.url!, viewModel: viewModel).overlay (
                    RoundedRectangle(cornerRadius: 4, style: .circular)
                        .stroke(Color.gray, lineWidth: 0.5)
                ).padding(.leading, 20).padding(.trailing, 20)
            }else {
                if let i = bigImage {
                    i.resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, minHeight: 400)
                }else {
                    ProgressView().frame(minWidth: 0, minHeight: 400)
                }
            }
         
            
            Button("Present!") {
                isPresented.toggle()
                async {
                    if photo.media_type != "video"{
                        do {
                            print("download image\(photo.url!)")
                            let i = try await download.downloadImage(from: photo.imageURL)
                            saver.writeToPhotoAlbum(image: i)
                        }catch {
                            print(error)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresented,onDismiss: didDismiss) {
                VStack {
                    if let i = bigImage {
                        i.resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, minHeight: 400)
                    }else {
                        ProgressView().frame(minWidth: 0, minHeight: 400)
                    }
                }.statusBar(hidden: true)
                .onTapGesture {
                    print("i'm long")
                }
                .onLongPressGesture {
                    isPresented.toggle()
                   
                }
                
            }
//            Button("SAVE!") {
//                print("I don't know")
//                //ImageSaver.init().writeToPhotoAlbum(image: bigImage!.)
//            }
            if style == .cardFront {
                HStack {
                    
                    Spacer()
                    cardControls(for: .front)
                } .padding()
                
            }
            
            if style == .cardBack {
                VStack {
                    
                    Text(photo.description)
                        .font(.system(size: 24))
                        .padding(.all, 50)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .minimumScaleFactor(0.01)  // 2
                        
                    
                    Spacer()
                    HStack {
                        Text(SpacePhoto.dateFormatter.string(from:  photo.date ))
                            .padding()
                        cardControls(for: .back)
                    }
                }
                .background(.thinMaterial)
               // .padding()
              
            }
        }
        .background(.thickMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .padding(.bottom, 8)
        .task {
            if photo.media_type != "video"{
                do {
                    print("download image\(photo.url!)")
                    let i = try await download.downloadImage(from: photo.imageURL)
                    self.bigImage = Image(uiImage:i)
                }catch {
                    print(error)
                }
            }
            
        }
    }
    func didDismiss() {
        
    }
    var title: some View {
        Text(photo.title.uppercased() + " " )//+ photo.copyright
            .padding(.horizontal, 8)

    }
    func cardControls(for side: FlipViewSide) -> some View {
        VStack {
            CardActionButton(
                label: side == .front ? "Open Nutrition Facts" : "Close Nutrition Facts",
                systemImage: side == .front ? "info.circle.fill" : "arrow.left.circle.fill",
                action: flipAction
            )
                .scaleEffect(displayingAsCard ? 1 : 0.5)
                .opacity(displayingAsCard ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
    /// An observable object representing a random list of space photos.
@MainActor
class Photos: ObservableObject {
    @Published private(set) var items: [SpacePhoto] = []
    @Published var date:Date = Date()
        /// Updates `items` to a new, random list of `SpacePhoto`.
    func updateItems() async {
      
        
        let fetched = await fetchPhotos(self.date)
        items = fetched
    }
    
        /// Fetches a new, random list of `SpacePhoto`.
    func fetchPhotos(_ date:Date) async -> [SpacePhoto] {
        
        var downloaded: [SpacePhoto] = []
        let url = SpacePhoto.requestForLast(date: date, day: 10)
        print(url)
        if let photo = await fetchPhoto(from: url) {
            downloaded.removeAll()
            downloaded.append(contentsOf: photo)
        }
        return downloaded
    }
    func randomPhotoDates() -> [Date] {
        let today = Date()
        return [today]
    }
        /// Fetches a `SpacePhoto` from the given `URL`.
    func fetchPhoto(from url: URL) async -> [SpacePhoto]? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //print(response)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy =
                .formatted(SpacePhoto.dateFormatter)
            print(data)
            return try decoder.decode([SpacePhoto].self, from: data)
        } catch let e{
            print(e)
            return nil
        }
    }
 
}

struct PhotoViewCard:View {
    var photo: SpacePhoto
    var presenting: Bool
    var closeAction: () -> Void = {}
    var imageDownloader = ImageDownloader()
    @State private var visibleSide = FlipViewSide.front
    
    var body: some View {
        FlipView(visibleSide: visibleSide) {
            PhotoView(photo: photo, style: presenting ? .cardFront : .thumbnail, closeAction: closeAction, flipAction: flipCard,download:imageDownloader )
        } back: {
            PhotoView(photo: photo, style: .cardBack, closeAction: closeAction, flipAction: flipCard,download: imageDownloader)
        }
        .contentShape(Rectangle())
        .animation(.flipCard, value: visibleSide)
        .navigationTitle(photo.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func flipCard() {
        visibleSide.toggle()
    }
}

struct CatalogView: View {
    

    @ObservedObject private var photos = Photos()
    @State private var selection: SpacePhoto.ID?
    var body: some View {

        NavigationView {
            List {
                Section(header: DatePicker("Date Picker", selection:$photos.date,displayedComponents: .date)
                            .frame(width: 200,height: 40).onTapGesture {
                   
//                    async {
                    print("gogogog")
//                        await photos.updateItems(selectionDate)
//                    }
                    
                }){
                    ForEach(photos.items.reversed()) { item in
                        
                        NavigationLink(tag:item.id,selection: $selection){
                            PhotoViewCard(photo: item, presenting: true)
                               
                        }label: {
                            HStack {
                                AsyncImage(url: item.smallImage) { image in
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Image("default")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.mint, lineWidth: 2))
                                .frame(width: 42, height: 42, alignment: .center)
                                  
                                Text(item.title)
                                    .padding(.leading, 16)
                            }
                            
                        }
                    }
                }
                
            }
            .onReceive(photos.$date) {  date in
                print("onReceive")
                print(date)
                async {
                    await photos.updateItems()
                }
                
                
            }
            .navigationBarTitle("Astronomy Picture of the Day",displayMode: .inline)
            .listStyle(.plain)
            .refreshable {
                await photos.updateItems()
            }
        }
//        .task {
//            await photos.updateItems()
//        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
