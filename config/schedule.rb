set :output, "tmp/cron.log"

every 1.minute do
  runner "DailyDigestJob.perform_now"
end