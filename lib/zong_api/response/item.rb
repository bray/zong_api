module ZongApi
  class Response
    class Item
      attr_reader :item_ref, :exchange_rate, :currency, :price_matched, :exact_price, :working_price, :out_payment, :num_mt, :entrypoint_url

      def initialize(attrs)
        attrs.each{ |attr, value| instance_variable_set("@#{attr}", value) }
        @exchange_rate = @exchange_rate.to_d unless @exchange_rate.nil? || @exchange_rate.is_a?(BigDecimal)
        @exact_price = @exact_price.to_d unless @exact_price.nil? || @exact_price.is_a?(BigDecimal)
        @working_price = @working_price.to_d unless @working_price.nil? || @working_price.is_a?(BigDecimal)
        @out_payment = @out_payment.to_d unless @out_payment.nil? || @out_payment.is_a?(BigDecimal)
      end
    end
  end
end
