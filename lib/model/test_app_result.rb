module Theotokos
  module Model

    class TestAppResult
    
      def initialize
        @success = false
        @broken_suites = []
        yield self if block_given?
      end
      
      attr_accessor :suites, :date_report
      attr_reader :total_failures, :total_success, :broken_suites
      
      def calculate_totals
        @total_failures = @total_success = 0
        @broken_suites.clear
        return if @suites.nil?
        
        @suites.each do |suite|
          suite.calculate_totals
          if suite.error?
            @total_failures += 1
            @broken_suites << suite
          end
          @total_success += 1 if suite.success?
        end
        
        @success = @total_failures == 0
      end
      
      def success?
        @success
      end
      
      def error?
        !success?
      end
      
      def total_suites
        (@suites.nil?) ? 0 : @suites.size
      end
      
      def total_test_cases
        return 0 if @suites.nil?
        
        total = 0
        @suites.each {|suite| total += suite.test_results.size }
        total
      end
      
      def success_failures_stats
        {
          :success => { :total => @total_success, :stat => ((@total_success * 100 / @suites.size).to_f.round 2) },
          :failures => { :total => @total_failures, :stat => ((@total_failures * 100 / @suites.size).to_f.round 2) }
        }
      end
      
      def tags_stats
        tags = {}
        @suites.each do |suite|
          suite.test_results.each do |test|
            test_tags = suite.model.tags | test.tags
            if test_tags.empty?
              tags[:none] = tags[:none].to_i + 1
              next
            end
            
            test_tags.each {|tag| tags[tag.to_sym] = tags[tag.to_sym].to_i + 1 }
          end
        end
        
        total = self.total_test_cases.to_f
        tags.each do |k, v|
          stat = (v * 100 / total).to_f.round 2
          tags[k] = { :total => v, :stat => stat }
        end
        
        tags
      end
      
      def to_hash
        { :total_failures => @total_failures, :total_success => @total_success, :date_report => @date_report,
          :broken_suites => ((@broken_suites) ? @broken_suites.map {|s| s.to_hash } : @broken_suites),
          :suites => ((@suites) ? @suites.map {|s| s.to_hash } : @suites) }
      end
      
     end
      
  end
end
