import Aimybox

final
class SuggestionReply: ButtonReply {

    let text: String

    let url: URL?

    init(text: String) {
        self.text = text
        self.url = nil
    }

}
