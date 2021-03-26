import Aimybox

final
class ExchangeRateReply: Decodable, Reply {

    struct Value {

        let exchangeRate: Float

        let name: String

    }

    private
    enum CodingKeys: String, CodingKey {
        case valuteList = "valute_list"
    }

    let values: [Value]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        values = try container.decode(.valuteList)
    }

}

extension ExchangeRateReply.Value: Decodable {

    private
    enum CodingKeys: String, CodingKey {
        case exchangeRate = "exchange_rate"
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        exchangeRate = try container.decode(.exchangeRate)
        name = try container.decode(.name)
    }

}
