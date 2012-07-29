def load_configuration(configfile)
  $consumerKey = configfile["consumer.key"]
  $consumerSecret= configfile["consumer.secret"]
  $accessToken= configfile["access.token"]
  $accessTokenSecret=configfile["access.tokenSecret"]
  $db_name = configfile["database"]
  $follow_target = configfile["follow_target"]
  $unfollow_limit=199
end

def load_parameters(args)
  $unfollow=true
  $follow=true
  $follow_third=true
  $development_mode=false

  # parsing parameters
  if args.length > 0  then
    opts = OptionParser.new
    opts.on("--no-unfollow", "disable unfollow") do |d|
      $unfollow = false
    end
    opts.on("--no-follow", "disable follow of followers") do |d|
      $follow = false
    end
    opts.on("--no-follow-third", "disable follow of third party followers") do |d|
      $follow_third = false
    end
    opts.on("-d", "--development-mode", "enable development mode (verbose log)") do |d|
      $development_mode = true
    end
    opts.on("-c [CONFIGFILE]", "set configuration file") do |c|
      $configfile = c
    end
    opts.on_tail("-h", "--help", "Show this usage statement") do |h|
      puts opts
      exit
    end
  opts.parse!(args)
  end
end

def init_logger() 
  configurator = YamlConfigurator    # handy shorthand
  configurator.load_yaml_file 'log4r_configuration.yaml'
  logger_name = $development_mode ? 'development' : 'production'
  $log = Logger[logger_name]
end
