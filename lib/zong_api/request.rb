module ZongApi
  class RequestError < StandardError; end
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config.yml'))


  class Request
    CUSTOMER_KEY = CONFIG['customer_key']

    PRICE_POINTS_URL = 'https://pay01.zong.com/zongpay/actions/default'
    XMLNS = 'http://apps.zong.com/zongpay'
    XMLNS_XSI = 'http://www.w3.org/2001/XMLSchema-instance'
    XSI_SCHEMA_LOCATION = 'https://pay01.zong.com/zongpay/zongpay.xsd'

    def self.logger
      @logger ||= RAILS_DEFAULT_LOGGER
    end

    def self.request_price_points(country_code, items = [])
      xml_request = build_xml_body(country_code, items)

      url = URI.parse(PRICE_POINTS_URL)
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data('method' => 'lookup', 'request' => xml_request)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      logger.info("\nZongApi: Requesting price points with this XML - \n#{xml_request}\n")
      response_body = Timeout::timeout(5){ response_body = http.start{ |h| h.request(req) }.body rescue nil }
      logger.info("\nZongApi: Reponse XML - \n#{response_body}\n\n")

      response_body.blank? ? raise(RequestError) : Response.new(response_body)
    end


    private

    def self.build_xml_body(country_code, items = [])
      xml = Builder::XmlMarkup.new :indent => 2

      xml.tag!('requestMobilePaymentProcessEntrypoints', 'xmlns' => XMLNS, 'xmlns:xsi' => XMLNS_XSI, 'xsi:schemaLocation' => XSI_SCHEMA_LOCATION) do
        xml.tag!('customerKey', CUSTOMER_KEY)
        xml.tag!('countryCode', country_code)
        xml.tag!('maxNumberMT', 1)
        xml.tag!('items', 'currency' => 'USD') do
          items.each do |item|
            xml.tag!('item', 'refItem' => item.item_ref, 'refMinPrice' => item.min_price, 'refStdPrice' => item.price, 'refMaxPrice' => item.max_price )
          end
        end
      end

      xml.target!
    end
  end

end