module ZongApi
  class Request
    class Item
      attr_reader :item_ref, :price, :min_price, :max_price

      def initialize(attrs)
        attrs.each{ |attr, value| instance_variable_set("@#{attr}", value) }
        @price = @price.to_d unless @price.nil? || @price.is_a?(BigDecimal)
        @min_price = @min_price.to_d unless @min_price.nil? || @min_price.is_a?(BigDecimal)
        @max_price = @max_price.to_d unless @max_price.nil? || @max_price.is_a?(BigDecimal)
      end
    end
  end
end
