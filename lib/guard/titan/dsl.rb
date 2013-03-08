module Guard
  class Dsl

    def set_watcher_for(key, cmd, opts = {}, &block)
      to_run = (opts[:call] ? opts[:call].to_s : false)
      file = ".t/#{key}"
      watch Regexp.new("^#{file}$") do
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

    def set_titan_watchers(opts = {})
      ::Guard::Titan.all_cmd_keys.each do |k|
        set_watcher_for(k, opts)
      end
    end

    private

    def put_and_notify(*msg)
      p *msg
      n *msg
    end

  end
end
