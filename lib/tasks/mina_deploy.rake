namespace :minadeploy do
  desc "it git pulls and calls mina:deploy"
  # commit: for logging and display purposes, the latest commit of the branch is deployed
  # branch: 'master' gets deployed to production environment, 'dev' to staging
  # event_type: set by Travis CI to indicate 'push' or 'pull_request'
  # source: use the current OS user name if not set
  # simulate: don't make any changes, tell mina to simulate only
  # path: directory in which 'mina <env> deploy' is called
  task :start, [:commit, :branch, :event_type, :source, :simulate, :path] => :environment do |task, args|
    begin
      args = args.to_hash
      user = `id -u -n`.chomp
      d = Deployment.new(commit: args[:commit], branch: args[:branch], event_type: args[:event_type], source: args[:source] || user)
      d.log = "Arguments: #{args}\n\n"
      # Only deploy master and dev branches on new pushes, don't deploy other branches or pull_requests
      if ['master', 'dev'].include? d.branch and d.event_type == 'push'
        env = case d.branch; when 'master' then 'production'; when 'dev' then 'staging'; else 'not_set' end
        simulate = args.delete(:simulate) ? ' -s' : ''
        path = args.delete(:path){ "/home/#{user}/vm-portal" }
        command = "(cd #{path} && "\
                  "pwd && git --version && #{path}/bin/rails --version && git -C #{path} ls-remote --get-url && "\
                  "git -C #{path} pull && "\
                  "BUNDLE_GEMFILE=#{path}/Gemfile #{path}/bin/bundle install && "\
                  "BUNDLE_GEMFILE=#{path}/Gemfile #{path}/bin/bundle exec mina #{env} deploy#{simulate}"\
                  ") 2>&1"
        d.log += "$ #{command}\n\n"
        # Execute command (Ruby backticks syntax) and save the output
        d.log += `#{command}`
        d.success=$?.success?
      else
        d.success = false
        d.log += "Skipping deployment of #{d.event_type} on #{d.branch}"
      end
    rescue StandardError => e
      d.log += "\n\n#{e}:\n#{e.message}\n\nStack trace:\n#{e.backtrace}"
      raise
    ensure
      puts d.log
      d.save
    end
  end

  desc "it shows information on the last deploy attempt"
  task :latest => :environment do
    d = Deployment.last
    abort('ERROR: No deployments found!') if not d
    puts "#{d.success ? 'DEPLOYED' : 'NOT DEPLOYED'} #{d.created_at} #{d.branch}@#{d.commit} via #{d.source} #{d.event_type}"
  end
end
