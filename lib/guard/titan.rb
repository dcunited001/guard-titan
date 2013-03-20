require 'guard'
require 'guard/guard'

module Guard
  class Titan < Guard

    VERSION = '0.0.1'

    attr_accessor :cmds, :root, :using
    attr_accessor :on_run_all, :all_cmd
    attr_accessor :exclude_from_all

    def initialize(watchers = [], opts = {})
      super
      @using = opts[:using] || :minitest
      @exclude_from_all = opts[:exclude_from_all] || []
      @on_run_all = opts[:on_run_all] || :recent # || :all || :all_keys
      @root = File.dirname(opts[:root])
      @cmds = get_scripts
      @all_cmd = cmds.delete(:all)
      @all_cmd = zeus_test_all_default if (all_cmd.nil? || all_cmd.empty?)
    end

    def run_all
      case on_run_all
      when :all
        put_and_notify("All:", all_cmd)
        run(all_cmd)
      when :all_keys
        put_and_notify("All_Keys:", all_cmd_keys.join(','))
        commands = all_cmd_keys.map {|k| cmds[k] }
        commands.each do |c|
          run(c)
        end
      when :recent
        put_and_notify("All Recent:", zeus_recent_cmd)
        run(zeus_recent_cmd)
      else
        put_and_notify("All Recent:", zeus_recent_cmd)
        run(zeus_recent_cmd)
      end
    end

    def zeus_test(file)
      "zeus #{zeus_test_cmd} #{root}/#{file}"
    end

    def zeus_test_all_default
      zeus_test("#{zeus_test_root}**/*_test.rb")
    end

    def zeus_test_cmd
      case using
        when :minitest then "test"
        when :rspec then "spec"
        when :testunit then "test"
        else "test/"
      end
    end

    def zeus_test_root
      case using
        when :minitest then "test/"
        when :rspec then "spec/"
        when :testunit then "test/"
        else "test/"
      end
    end

    def run(cmd, opts = {})
      puts '='*40
      puts "Running: #{cmd}"
      output = `#{cmd}`
      puts output
    end

    def all_cmd_keys(opts = {})
      cmds.keys - (['all'] + exclude_from_all.map(&:to_s))
    end

    # TODO: run at guard command prompt
    def zeus_recent_cmd(opts = {})
      # run tests that have changed since last commit
      "zeus test #{since_last_commit.join(' ')}"
    end

    def run_on_changes(paths)
      put_and_notify("Changed:", paths.join(', '))

      test_all = false
      dot_tee = []
      normal_tests = paths.inject(Array.new) do |memo, p|
        if (p =~ /\.t\/(.*)$/)
          test_all = true if ($1=='all')
          dot_tee.push($1)
        else
          memo.push(p)
        end
        memo
      end

      if test_all
        run_all
      else
        run(zeus_test(normal_tests.join(' '))) if normal_tests.any?
        run(dot_tee.map { |k| cmds[k] }.join(' ; ')) if dot_tee.any?
      end
    end

    private

    def since_last_commit
      `git status --porcelain |
      grep 'test' | grep -v 'factories' |
      cut -c4- | sort | uniq`.split("\n")
    end

    def self.get_scripts(root)
      Dir.glob(File.join(root, ".t/*")).inject(Hash.new) do |memo,f|
        key = f.gsub(/^(.*)\/.t\//, '')
        command = File.read(f)
        memo[key] = command
        memo
      end
    end

    def get_scripts
      self.class.get_scripts(root)
    end

    def put_and_notify(a,b)
      puts "#{a} #{b}"
#      p a, b
#      n a, b
# hmm getting problems with notify here
#      puts(*args)
#      notify(*args)
    end
  end
end
