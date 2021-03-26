import Aimybox

final
class StockMarketReply: Decodable, Reply {

    struct Market {

        let changePerDay: Float

        let changePercents: Float

        let currentPrice: Float

        let name: String

    }

    let markets: [Market]

    private
    enum CodingKeys: String, CodingKey {
        case marketList = "market_list"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        markets = try container.decode(.marketList)
    }

}

extension StockMarketReply.Market: Decodable {

    private
    enum CodingKeys: String, CodingKey {
        case changePerDay = "change_per_day"
        case changePercents = "change_percents"
        case currentPrice = "current_price"
        case name = "short_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        changePerDay = try container.decode(.changePerDay)
        changePercents = try container.decode(.changePercents)
        currentPrice = try container.decode(.currentPrice)
        name = try container.decode(.name)
    }

}
