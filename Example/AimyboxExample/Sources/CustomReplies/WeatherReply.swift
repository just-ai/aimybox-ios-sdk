import Aimybox

final
class WeatherReply: Decodable, Reply {

    private
    enum CodingKeys: String, CodingKey {
        case city
        case date
        case temperature
        case weatherDescription = "weather_description"
        case weatherImageURL = "image_url"
    }

    let city: String

    let date: String

    let temperature: Float

    let weatherDescription: String

    let weatherImageURL: URL?

    required
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(.city)
        self.date = try container.decode(.date)
        self.temperature = try container.decode(.temperature)
        self.weatherDescription = try container.decode(.weatherDescription)
        self.weatherImageURL = try container.decodeIfPresent(.weatherImageURL)
    }

}

extension WeatherReply {

    var temperatureString: String {
        "\(temperature)"
    }

}
