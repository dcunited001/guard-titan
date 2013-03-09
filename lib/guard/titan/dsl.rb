module Guard
  class Dsl

    def set_watcher_for(key, cmd, opts = {}, &block)
      to_run = (opts[:call] ? opts[:call].to_s : false)
      key = key.gsub!(/^.*\.t\//, ".t/")
      puts key
      puts cmd
      watch Regexp.new("^#{key}$") do
        put_and_notify "Running: ", key
        put_and_notify "Command: ", cmd

        `#{cmd}`

        #case
          #when block_given? then block.call(opts[:run_opts]) #need proc
        #when to_run then send(to_run, opts[:run_opts])
        #else run(key, opts[:run_opts])
        #end
      end
    end

    def set_titan_watchers(root, opts = {})
      puts "GODDAMIT_WHAT_THE_FUCK"

      ::Guard::Titan.get_scripts(root).each do |k,v|
        set_watcher_for(k, v, opts)
      end
    end

    private

    def put_and_notify(*msg)
      p *msg
      n *msg
    end

  end
end
