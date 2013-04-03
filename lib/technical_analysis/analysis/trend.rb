module TechnicalAnalysis::Analysis
  module Trend
#    def support_resistence(delta = 0.03)
#      top    = []
#      bottom = []
#      last_top    = first.close
#      last_bottom = first.close
#      each_index do |idx|
#        next if idx == 0
#        next if count == idx + 1
#
#        # just to clear the reading
#        today_price     = self[idx    ].close
#        yesterday_price = self[idx - 1].close
#        tomorow_price   = self[idx + 1].close
#
#        # if today is greather than yesterday and greather than tomorow, is a top
#        if today_price > yesterday_price and tomorow_price < today_price
#          smooth = delta * today_price
#          top << ((today_price - smooth) * 100).to_i..((today_price + smooth) * 100).to_i
#        # if today is less than yesterday and less than tomorow , is a bottom
#        elsif
#          today_price < yesterday_price and tomorow_price > today_price
#          smooth = delta * today_price
#          bottom << ((today_price - smooth) * 100).to_i..((today_price + smooth) * 100).to_i          
#        end
#      end
#
#      support = Hash.new { |hash, key| hash[key] = Array.new }
#      bottom.each_index do |idx|
#        test = bottom[idx]
#        next if test.nil?
#        bottom.each_index do |nidx|
#          test2 = bottom[nidx]
#          next if test2.nil?
#          if not (test.to_a & test2.to_a).empty?
#            support[test] << test2
#            bottom[idx] = nil
#          end
#        end
#      end
#
#      max   = nil
#      min   = nil
#      intersect = nil
#      support.each_index do |idx|
#        arr = k.to_a + v.flat_map { |i| i.to_a }.uniq
#        max = arr.max if max.nil? or max < arr.max
#        min = arr.min if min.nil? or min > arr.min
#        intersect = intersect.nil? ? arr : intersect & arr
#      end
#
#      if intersect.empty?
#        support
#
#      resistence = Hash.new { |hash, key| hash[key] = Array.new }
#      top.each_index do |idx|
#        test = top[idx]
#        next if test.nil?
#        top.each_index do |nidx|
#          test2 = bottom[nidx]
#          next if test2.nil?
#          if not (test.to_a & test2.to_a).empty?
#            resistence[test] << test2
#            top[idx] = nil
#          end
#        end
#      end
#    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'trend/*.rb' )].each { |file| require file }