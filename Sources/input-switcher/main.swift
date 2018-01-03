import Carbon
import Commander

extension TISInputSource {
    
    private func getProperty(key: CFString) -> Any? {
        guard let value = TISGetInputSourceProperty(self, key) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(value).takeUnretainedValue()
    }
    
    var id: String { return getProperty(key: kTISPropertyInputSourceID) as! String }
    var localizedName: String { return getProperty(key: kTISPropertyLocalizedName) as! String }
    var selectCapable: Bool { return getProperty(key: kTISPropertyInputSourceIsSelectCapable) as! Bool }
    var category: String { return getProperty(key: kTISPropertyInputSourceCategory) as! String }
}

func fetchInputSources() -> [TISInputSource] {
    let sourceList = TISCreateInputSourceList(nil, false).takeRetainedValue() as! [TISInputSource]
    return sourceList.filter { $0.category == kTISCategoryKeyboardInputSource as String && $0.selectCapable }
}

Group { group in
    group.command("list", description: "List all input sources", {
        let sources = fetchInputSources()
        guard !sources.isEmpty else {
            print("Whoops, no input sources found")
            return
        }
        
        let maxWidth = sources.max { $0.id.count < $1.id.count }!.id.count
        let alignedPrint: (String, String) -> Void = { col1, col2 in
            print(col1.padding(toLength: maxWidth + 10, withPad: " ", startingAt: 0).appending(col2))
        }
        alignedPrint("ID", "NAME")
        sources.forEach { alignedPrint($0.id, $0.localizedName) }
    })
    group.command("switch", description: "Switch input source") { (id: String) in
        guard let source = (fetchInputSources().filter { $0.id == id }).first else {
            print("No input source \(id) found")
            return
        }
        
        TISSelectInputSource(source)
    }
}.run()
