desc "deploy it call with [true/false] to actually deploy"
task :deploy, :doit, :needs => ["site:build"] do |t, args|
  args.with_defaults(:doit => false)
  site_config = YAML.load_file("./config.yaml")
  output_dir = site_config["output_dir"].sub(/\/$/, "")
  config = YAML.load_file("./deploy.yaml")
  user = config["user"]
  host = config["host"]
  root = config["root"]
  dry = args.doit ? "" : "--dry-run"
  cmd = "rsync -av --delete --exclude drafts #{dry} #{output_dir}/ #{user}@#{host}:#{root}"
  system "#{cmd}"
  msg = args.doit ? "sync complete" : "DRY RUN finished, rerun with rake deploy[true]"
  puts msg
end
