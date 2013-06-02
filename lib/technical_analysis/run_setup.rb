#
module TechnicalAnalysis
  class RunSetup
    attr_accessor :cash, :symbol, :candle_array, :setup, :portfolio, :entry_point, :risk_management, :start_date, :finish_date

    def risk_management_list
      TechnicalAnalysis::RiskManagement.list
    end

    def risk_management_option_list(setup)
      return {} if not setup.is_a?(Hash) or setup.empty?
      first, *rest = setup.values
      first.product(*rest).map { |i| Hash[*setup.keys.zip(i).flatten] }
    end

    def risk_managements
      risk_management_list.flat_map do |rm|
        risk_management_option_list(rm.setup).map do |opts|
          rm.new(opts)
        end
      end
    end

    def setup_list
      TechnicalAnalysis::Setup.list
    end

    def where_clause(symbol)
      opts = [symbol]
      str  = 'symbol = ?'
      if start_date.is_a?(Time)
        str += ' and date >= ?'
        opts << start_date
      end
      if finish_date.is_a?(Time)
        str += ' and date <= ?'
        opts << finish_date
      end
      [str, *opts]
    end

    def entry_point_to_trade
      {
        price:    entry_point[:price_in],
        quantity: risk_management.quantity,
        date: entry_point[:candle].date,
        symbol: symbol,
        brokerage: brokerage
      }
    end

    # TODO where this came from???
    def brokerage
      0
    end

    def process_stops
    end

    def trade?
      # TODO: change trade? to accept all opts in hash
      risk_management.trade?(portfolio.cash, entry_point[:price_in], entry_point)
    end

    def create_portfolio
      @portfolio = Portfolio.create(cash: cash, risk_management_type: risk_management.class.to_s, options: risk_management.options)
    end

    def find_candle_array
      @candle_array = HistoricalQuote.where(where_clause(symbol))
    end

    def run(cash, list, opts = {})
      return false unless cash.kind_of?(Numeric) and list.is_a?(Array)
      self.cash = cash
      self.start_date  = opts[:start]
      self.finish_date = opts[:finish]

      list.each do |symbol|
        self.symbol = symbol
        find_candle_array
        setup_list.each do |setup_class|
          self.setup = setup_class.new(candle_array: candle_array)
          entry_points = setup.run_setup
          risk_managements.each do |mr|
            self.risk_management = mr
            create_portfolio
            entry_points.each do |entry_point|
              self.entry_point = entry_point
              if trade?
                portfolio.buy(entry_point_to_trade)
                register_stops
                # TODO: process_stops
              end
            end
            # TODO: finish_positions
          end
        end
      end
    end
  end
end