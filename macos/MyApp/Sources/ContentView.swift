import SwiftUI
import MylibKit

public struct ContentView: View {
    @State var a: Int = 0
    @State var b: Int = 0
    
    public var body: some View {
        VStack {
            Picker("A: ", selection: $a) {
                ForEach(-10...10, id: \.self) {
                    Text("\($0)")
                }
            }
            .fixedSize()
            Picker("B: ", selection: $b) {
                ForEach(-10...10, id: \.self) {
                    Text("\($0)")
                }
            }
            .fixedSize()
            
            // We have to cast back and forth between Int and Int32
            var result = Int(add(Int32(a), Int32(b)))
            Text("Result: \(result)")
        }.padding()
    }
}

#Preview {
    ContentView()
}
