# encoding: utf-8
module Faker
  class Internet < Base
    class << self
      def email(name = nil)
        [ user_name(name), domain_name ].join('@')
      end
      
      def free_email(name = nil)
        [ user_name(name), fetch('internet.free_email') ].join('@')
      end
      
      def safe_email(name = nil)
        [user_name(name), 'example.'+ %w[org com net].shuffle.first].join('@')
      end
      
      def user_name(name = nil)
        return name.scan(/\w+/).shuffle.join(%w(. _).sample).downcase if name
        
        [ 
          Proc.new { fix_funny_characters Name.first_name.downcase },
          Proc.new { 
            [ Name.first_name, Name.last_name ].map {|n| 
              fix_funny_characters(n)
            }.join(%w(. _).sample).downcase }
        ].sample.call
      end
      
      def domain_name
        [ fix_funny_characters(domain_word), domain_suffix ].join('.')
      end
      
      def fix_funny_characters(string)
        string.gsub(/[^a-zA-Z0-9\-]/, '')
      end
      
      def domain_word
        fix_funny_characters Company.name.split(' ').first.downcase
      end
      
      def domain_suffix
        fetch('internet.domain_suffix')
      end
      
      def ip_v4_address
        ary = (2..254).to_a
        [ary.sample,
        ary.sample,
        ary.sample,
        ary.sample].join('.')
      end

      def ip_v6_address
        @@ip_v6_space ||= (0..65535).to_a
        container = (1..8).map{ |_| @@ip_v6_space.sample }
        container.map{ |n| n.to_s(16) }.join(':')
      end
      
      def url
        "http://#{domain_name}/#{user_name}"
      end
    end
  end
end
