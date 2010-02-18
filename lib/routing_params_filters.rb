# RoutingParamsFilters
#require 'routing_params_filters/route'

module ActionController::Routing
  class Route
    private
    # Write the code to extract the parameters from a matched route.
    def recognition_extraction
      next_capture = 1
      extraction = segments.collect do |segment|
        if segment.to_s[0] == ?:
          x = segment.match_extraction(next_capture, @conditions[segment.to_s[1..-1].to_sym])
        else
          x = segment.match_extraction(next_capture)
        end
        next_capture += segment.number_of_captures
        x
      end
      extraction.compact
    end
  end
  
  class DynamicSegment
    def match_extraction(next_capture, block)
      # All non code-related keys (such as :id, :slug) are URI-unescaped as
      # path parameters.
      default_value = default ? default.inspect : nil
      %[
        value = if (m = match[#{next_capture}])
          URI.unescape(m)
        else
          #{default_value}
        end
        params[:#{key}] = value#{'.' + block.to_s if block} if value
      ]
    end    
  end
end