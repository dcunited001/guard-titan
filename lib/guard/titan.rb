require 'guard'
require 'guard/guard'
require 'zeus/rails'

require "guard/titan/version"
require "guard/titan/dsl"

module Guard

  class Titan < Guard
    # @raise [:task_has_failed] when a method has failed
    attr_accessor :scripts
    attr_accessor :exclude_from_all
    attr_accessor :cmd

    def initialize(watchers = [], opts = {})
      super
    #  @scripts = self.class.get_scripts
    #  @exclude_from_all = opts[:exclude_from_all]
    end

    # run all tests
    def run_all
      all_cmd_keys.each do |k|
        `#{cmd[k]}`
      end
    end

    #def all_cmd_keys
    #  @scripts.keys - (['all'] + exclude_from_all.map(&:to_s))
    #end

    # run a list of test
    # TODO: run at guard command prompt
    #def run_list(*args)
    #  opts = args.pop if args.last.is_a? Hash
    #  `zeus test #{args.join(' ')}`
    #end

    # run tests that have changed since last commit
    # TODO: run at guard command prompt
    def run_recent(opts = {})
      `zeus test #{since_last_commit.join(' ')}`
    end

    private

    #def run(key, opts = {})
    #  `#{cmd[key]}`
    #end

    def since_last_commit
      `git status --porcelain |
      grep 'test' | grep -v 'factories' |
      cut -c4- | sort | uniq |
      xargs zeus test`.split("\n")
    end

    def self.get_scripts
      Dir.glob(File.join(__FILE__, ".t/*")).inject(Hash.new) do |f, memo|
        memo[f] = File.read(f)
        memo
      end
    end

    def self.all_cmd_keys(opts = {})
      exclude = (opts[:exclude_from_all] || [])
      @scripts.keys - (['all'] + exclude).map(&:to_s)
    end
  end
end
