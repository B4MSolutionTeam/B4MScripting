using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VersiondogReportService
{
    class Log
    {
        static EventLog eventLog;

        public static void Logging()
        {
            eventLog = new EventLog();
            if (!EventLog.SourceExists("VDR.Service"))
            {
                EventLog.CreateEventSource("VDR.Service", "VD Reporting importer");
            }
            eventLog.Source = "VDR.Service";
            eventLog.Log = "VD Reporting importer";
        }


        public static void Error(Exception ex)
        {
            eventLog.Source = "VDR.Service";
            eventLog.WriteEntry($"Message:    {ex.Message} \n" +
                $"Stack Trace:  {ex.StackTrace}", EventLogEntryType.Error);
        }

        public static void Error(string message)
        {
            eventLog.Source = "VDR.Service";
            eventLog.WriteEntry(message, EventLogEntryType.Error);
        }

        public static void Information(string message)
        {
            eventLog.Source = "VDR.Service";
            eventLog.WriteEntry(message, EventLogEntryType.Information);
        }

        public static void Warning(Exception ex)
        {
            eventLog.Source = "VDR.Service";
            eventLog.WriteEntry($"Message:    {ex.Message}", EventLogEntryType.Warning);
        }

        public static void Warning(string message)
        {
            eventLog.Source = "VDR.Service";
            eventLog.WriteEntry(message, EventLogEntryType.Warning);
        }

    }
}
