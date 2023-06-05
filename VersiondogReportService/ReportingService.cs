using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace VersiondogReportService
{
    public partial class ReportingService : ServiceBase
    {
        List<BackgroundWorker> backgroundWorkers = new List<BackgroundWorker>();

        public ReportingService()
        {
            InitializeComponent();
            Log.Logging();

        }

        protected override void OnStart(string[] args)
        {
            Log.Information($"Service starting. {DateTime.Now}");


            //Create a Background Worker for each Export Path listed in the Settings
            //Start it and add it to the List of Workers
            try
            {
                foreach (var item in Properties.Settings.Default.Export_Ordnerpfade.Split(';'))
                {
                    BackgroundWorker worker = new BackgroundWorker()
                    {
                        WorkerSupportsCancellation = true
                    };
                    worker.DoWork += Worker_DoWork;
                    worker.RunWorkerAsync(item);
                    backgroundWorkers.Add(worker);
                }
                foreach (var item in Properties.Settings.Default.Export_Componenten_Ordnerpfad.Split(';'))
                {
                    BackgroundWorker worker = new BackgroundWorker()
                    {
                        WorkerSupportsCancellation = true
                    };
                    worker.DoWork += Worker_Component;
                    worker.RunWorkerAsync(item);
                    backgroundWorkers.Add(worker);
                    Console.WriteLine($"Starting Watcher {worker}");
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                Console.WriteLine();
            }

            Log.Information($"Service started. {DateTime.Now}");
        }

        protected override void OnStop()
        {

            try
            {
                foreach (var worker in backgroundWorkers)
                {
                    worker.CancelAsync();
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            finally
            {

            }
            Log.Information($"Service stopped. {DateTime.Now}");
        }

        private void Worker_DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker bw = (BackgroundWorker)sender;
            Log.Information($"Background Worker for Directory: { e.Argument} started.");

            try
            {
                FileWatcher watcher = new FileWatcher(e.Argument.ToString(),false);
                watcher.WatchSystem();
                string Test = e.Argument.ToString();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }

            if (bw.CancellationPending == true)
            {
                e.Cancel = true;
                Log.Information($"Cancelling Worker. {DateTime.Now}  {e.Argument}");
                return;
            }

        }

        private void Worker_Component(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker bw = (BackgroundWorker)sender;
            Log.Information($"Background Worker for Directory: { e.Argument} started.");

            try
            {
                FileWatcher watcher = new FileWatcher(e.Argument.ToString(), true);
                watcher.WatchComponents();
                string Test = e.Argument.ToString();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }

            while (!bw.CancellationPending)
            {
            }

            if (bw.CancellationPending == true)
            {
                e.Cancel = true;
                Log.Information($"Cancelling Worker. {DateTime.Now}  {e.Argument}");
                return;
            }


        }
    }
}
