This is a monitoring script. Use 'cron' so it runs every 5 minutes.

To add a job to 'cron', use 'crontab -e' command. Add the following line to the 'crontab' file to run the script every 5 minutes.

```bash
    */5 * * * * /path/to/script.sh
```

If you want to learn more about how it works check out my website: https://cerrah.work/Computer-Science/server-monitor-script
