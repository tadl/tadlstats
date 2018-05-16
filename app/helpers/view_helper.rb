module ViewHelper

    def percent_of(n)
        self.to_f / n.to_f * 100.0
    end

    def item_type_map(val)
        @item_types = Settings.item_types
        response = nil
        @item_types.each do |option|
            if val.to_s == option[0].to_s
                response = option[1]
            end

        end

        return response
    end

end
