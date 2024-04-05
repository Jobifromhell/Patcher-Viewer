import SwiftUI

struct PreferenceView: View {
    @Binding var project: Project
    @Binding var categorySelections: [String: Bool]

    var body: some View {
        VStack {
            Section(header: Text("Display Options")) {
                Toggle("Risers", isOn: Binding(
                    get: { self.categorySelections["Riser"] ?? true },
                    set: { self.categorySelections["Riser"] = $0 }
                ))
                Toggle("Source", isOn: Binding(
                    get: { self.categorySelections["Source"] ?? true },
                    set: { self.categorySelections["Source"] = $0 }
                ))                
                Toggle("Patch", isOn: Binding(
                    get: { self.categorySelections["Patch"] ?? true },
                    set: { self.categorySelections["Patch"] = $0 }
                ))
                Toggle("Power", isOn: Binding(
                    get: { self.categorySelections["Power"] ?? true },
                    set: { self.categorySelections["Power"] = $0 }
                ))
                Toggle("Musician", isOn: Binding(
                    get: { self.categorySelections["Musician"] ?? true },
                    set: { self.categorySelections["Musician"] = $0 }
                ))
                Toggle("Monitor", isOn: Binding(
                    get: { self.categorySelections["Monitor"] ?? true },
                    set: { self.categorySelections["Monitor"] = $0 }
                ))
            }
        }
        .padding()
        .navigationBarTitle("Preferences")
        .background(Color.clear)

    }
}
