module ZongApi
  class Response
    attr_reader :items

    def initialize(response_body)
      @raw = response_body
      parse
    end

    def parse
      @items = []
      doc = Hpricot::XML(@raw)
      exchange_rate = doc.at(:exchangeRate).innerHTML rescue nil
      currency = doc.at(:localCurrency).innerHTML rescue nil
      return unless exchange_rate && currency
      
      (doc/:item).each do |item|
        next unless item[:priceMatched] && item[:priceMatched] == 'true'
        item_attrs = {:exchange_rate => exchange_rate, :currency => currency, :item_ref => item[:itemRef], :price_matched => item[:priceMatched], :exact_price => item[:exactPrice],
          :working_price => item[:workingPrice], :out_payment => item[:outPayment], :num_mt => item[:numMt], :entrypoint_url => (item/:entrypointUrl).first.innerHTML}

        @items << Item.new(item_attrs)
      end
    end
  end
end