using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Timers;
using System.Xml;

namespace VersiondogReportService
{
    class FileWatcher
    {
        FileSystemWatcher systemWatcher;
        ObservableCollection<string> listOfEvents;
        ObservableCollection<string> listOfEventscomp;
        Timer timer;
        DirectoryInfo directoryInfo;
        XmlData xmlData;
        CsvData csvData;


        public string Path { get; set; }
        public int Layers { get; set; }
        public string Plant { get; set; }
        public Boolean Structure { get; set; }

        //Constructor for FileWatcher Class
        public FileWatcher(string pfad, bool comp)
        {
            //Assign Variables for later use
            if (!comp)
            {
                Path = pfad.Split(':')[0];
                Layers = Convert.ToInt32(pfad.Split(':')[1]);
                Plant = pfad.Split(':')[2];
                Structure = Convert.ToBoolean(pfad.Split(':')[3]);
            }
            else
            {
                Path = pfad;
            }
        }

        //Initialize FileSystemWatcher for the Path delivered from BackgroundWorker
        public void WatchSystem()
        {
            try
            {
                systemWatcher = new FileSystemWatcher
                {
                    Path = Path
                };
                systemWatcher.Created += new FileSystemEventHandler(SystemWatcher_Action);
                systemWatcher.Changed += new FileSystemEventHandler(SystemWatcher_Action);
                systemWatcher.IncludeSubdirectories = true;
                systemWatcher.EnableRaisingEvents = true;
                listOfEvents = new ObservableCollection<string>();
                listOfEvents.CollectionChanged += ListOfEvents_CollectionChanged;
                SetTimer();
                Log.Information($"Started Monitoring Files in: {Path}");
                Console.WriteLine("Watcher Started");
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
        }

        //Initialize FileSystemWatcher to watch Component file for the Path delivered from BackgroundWorker 
        public void WatchComponents()
        {
            try
            {
                systemWatcher = new FileSystemWatcher
                {
                    Path = Path
                };
                systemWatcher.Created += new FileSystemEventHandler(ComponentWatcher_Action);
                systemWatcher.Changed += new FileSystemEventHandler(ComponentWatcher_Action);
                systemWatcher.IncludeSubdirectories = false;
                systemWatcher.EnableRaisingEvents = true;
                listOfEventscomp = new ObservableCollection<string>();
                listOfEventscomp.CollectionChanged += ListOfEventscomp_CollectionChanged;
                Log.Information($"Started Monitoring Files in: {Path}");
                Console.WriteLine("Watcher Started");
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
        }

        //Define what happens when ComponentWatcher_Action Event is called
        public void ComponentWatcher_Action(object sender, FileSystemEventArgs e)
        {
            switch (e.ChangeType)
            {
                case WatcherChangeTypes.Created:
                    listOfEventscomp.Add("Created");
                    Console.WriteLine("File Created");
                    break;
                case WatcherChangeTypes.Changed:
                    listOfEventscomp.Add("Changed");
                    Console.WriteLine($"File Changed: {e.Name}");
                    break;
            }
        }

        //Define what happens when SystemWatcher_Action Event is called
        public void SystemWatcher_Action(object sender, FileSystemEventArgs e)
        {
            switch (e.ChangeType)
            {
                case WatcherChangeTypes.Created:
                    listOfEvents.Add("Created");
                    Console.WriteLine("File Created");
                    break;
                case WatcherChangeTypes.Changed:
                    listOfEvents.Add("Changed");
                    Console.WriteLine($"File Changed: {e.Name}");
                    break;
            }
        }

        //Define Timer Variable for Wait time between file Changes and Importing
        private void SetTimer()
        {
            timer = new Timer(120000);
            timer.Elapsed += new ElapsedEventHandler(OnTimedEvent);
            timer.AutoReset = false;
        }

        //Start and Restart Time if an item is Added to the Event Collection
        private void ListOfEvents_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            try
            {
                if (!timer.Enabled)
                {
                    timer.Start();
                    Console.WriteLine("Starting Timer");
                }
                else if (timer.Enabled)
                {
                    timer.Stop();
                    timer.Start();
                    Console.WriteLine("Restarting Timer");
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
        }

        //Start Collecting File Data when the Timer has run out
        private void OnTimedEvent(object sender, ElapsedEventArgs e)
        {
            try
            {
                timer.Enabled = false;
                Console.WriteLine("Timer Elapsed");
                CollectandStoreData();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
        }

        //Start Reading the files in the Watched Directory and write the Content into the respective Dictionarys
        private void CollectandStoreData()
        {
            Log.Information($"Started Reading Files in: {Path}");
            xmlData = new XmlData();
            csvData = new CsvData();
            DataSet data;
            Dictionary<string, DataTable> xmlInformation = new Dictionary<string, DataTable>();
            Dictionary<string, DataTable> csvInformation = new Dictionary<string, DataTable>();

            directoryInfo = new DirectoryInfo(Path);
            foreach (var fi in directoryInfo.GetFiles())
            {
                if (fi.Extension == ".xml")
                {
                    try
                    {
                        RemoveXmlInvalidChars(fi.FullName);
                        Console.WriteLine($"Current File:  {fi.Name}");
                        data = new DataSet();
                        if (Layers == 4)
                        {
                            if(Structure)
                            {
                                data.ReadXmlSchema(Properties.Settings.Default.XmlSchemaFile_UpperCase);
                                data.ReadXml(fi.FullName);
                                xmlInformation.Add(Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), xmlData.XmlContent(data, Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), Layers, Plant, Structure));
                            }
                            else
                            {
                                data.ReadXmlSchema(Properties.Settings.Default.XmlSchemaFile);
                                data.ReadXml(fi.FullName);
                                xmlInformation.Add(Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), xmlData.XmlContent(data, Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), Layers, Plant, Structure));

                            }
                        }
                        else
                        {
                            data.ReadXmlSchema(Properties.Settings.Default.XmlSchemaFile_UpperCase);
                            data.ReadXml(fi.FullName);
                            xmlInformation.Add(Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), xmlData.XmlContent(data, Regex.Replace(fi.Name, "(_ComponentTree.xml)", ""), Layers));
                        }
                    }
                    catch (Exception ex)
                    { Log.Error(ex); Log.Error($"Fehler beim Lesen der Datei: {fi.Name}"); Console.WriteLine($"Fehler beim Lesen der Datei: {fi.Name}"); }
                }
                else if (fi.Extension == ".csv")
                {
                    csvInformation.Add(Regex.Replace(fi.Name, "(_Jobs.csv)", ""), csvData.CsvContent(fi.FullName, Regex.Replace(fi.Name, "(_Jobs.csv)", "")));
                }
            }
            CombineTables(xmlInformation, csvInformation);
        }

        //Combine the two DataTables from xml and csv file into one DataSet
        private void CombineTables(Dictionary<string, DataTable> xmlinfo, Dictionary<string, DataTable> csvinfo)
        {
            DataSet set = new DataSet();

            foreach (var xmlInfo in xmlinfo)
            {
                foreach (var csvInfo in csvinfo)
                {
                    try
                    {

                        if (xmlInfo.Key.Equals(csvInfo.Key))
                        {
                            DataTable dt1 = xmlInfo.Value;
                            DataTable dt2 = csvInfo.Value;

                            DataTable fulldata = new DataTable($"{xmlInfo.Key}_Merged");
                            fulldata.Columns.Add("PLANT");
                            fulldata.Columns.Add("VALUESTREAM");
                            fulldata.Columns.Add("COMPONENTID");
                            fulldata.Columns.Add("COMPONENTTYPEID");
                            fulldata.Columns.Add("COMPONENT");
                            fulldata.Columns.Add("COMPONENTTYPE");
                            fulldata.Columns.Add("LASTIMPORTINDB", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("VERSIONNUMBER");
                            fulldata.Columns.Add("VERSION");
                            fulldata.Columns.Add("SECTION");
                            fulldata.Columns.Add("SUBSECTION");
                            fulldata.Columns.Add("STATION");
                            fulldata.Columns.Add("LASTCHANGE", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("RESULTVERSIONVSBACKUP");
                            fulldata.Columns.Add("RESULTBACKUPVSPREBACKUP");
                            fulldata.Columns.Add("LASTCHECK", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("COMPONENTTREE");
                            fulldata.Columns.Add("EXECUTION");
                            fulldata.Columns.Add("IP_NAME");
                            fulldata.Columns.Add("UPLOADAGENT");
                            fulldata.Columns.Add("NEXTSTART", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("JOBSTART", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("JOBFINISH", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("TIMESTAMPBACKUP", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("TIMESTAMPPREBACKUP", Type.GetType("System.DateTime"));
                            fulldata.Columns.Add("DEACTIVATEDCOMMENT");
                            fulldata.Columns.Add("JOBID");
                            fulldata.Columns.Add("JOBNAME");
                            Console.WriteLine($"Combining Tables");
                            dt1.DefaultView.Sort = "COMPONENTID ASC";
                            dt1 = dt1.DefaultView.ToTable();
                            dt2.DefaultView.Sort = "COMPONENTID ASC";
                            dt2 = dt2.DefaultView.ToTable();

                            var results = (from dataRows1 in dt1.AsEnumerable()
                                           join dataRows2 in dt2.AsEnumerable()
                                           on dataRows1.Field<string>("COMPONENTID") equals dataRows2.Field<string>("COMPONENTID") into lj
                                           from r in lj.DefaultIfEmpty()
                                           select new
                                           {
                                               PLANT = dataRows1.Field<string>("PLANT"),
                                               VALUESTREAM = dataRows1.Field<string>("VALUESTREAM"),
                                               COMPONENTID = dataRows1.Field<string>("COMPONENTID"),
                                               COMPONENTTYPEID = dataRows1.Field<string>("COMPONENTTYPEID"),
                                               COMPONENT = dataRows1.Field<string>("COMPONENT"),
                                               COMPONENTTYPE = dataRows1.Field<string>("COMPONENTTYPE"),
                                               LASTIMPORTINDB = dataRows1.Field<DateTime>("LASTIMPORTINDB"),
                                               VERSIONNUMBER = dataRows1.Field<string>("VERSIONNUMBER"),
                                               VERSION = dataRows1.Field<string>("VERSION"),
                                               SECTION = dataRows1.Field<string>("SECTION"),
                                               SUBSECTION = dataRows1.Field<string>("SUBSECTION"),
                                               STATION = dataRows1.Field<string>("STATION"),
                                               LASTCHANGE = dataRows1.Field<DateTime>("LASTCHANGE"),
                                               RESULTVERSIONVSBACKUP = r == null ? "-" : r.Field<string>("RESULTVERSIONVSBACKUP"),
                                               RESULTBACKUPVSPREBACKUP = r == null ? "-" : r.Field<string>("RESULTBACKUPVSPREBACKUPS"),
                                               LASTCHECK = r == null ? DateTime.MinValue : r.Field<DateTime>("LASTCHECK"),
                                               COMPONENTTREE = r == null ? "-" : r.Field<string>("COMPONENT"),
                                               EXECUTION = r == null ? "-" : r.Field<string>("EXECUTION"),
                                               IP_NAME = r == null ? "-" : r.Field<string>("IPORCOMPUTERNAME"),
                                               UPLOADAGENT = r == null ? "-" : r.Field<string>("UPLOADAGENT"),
                                               NEXTSTART = r == null ? DateTime.MinValue : r.Field<DateTime>("NEXTSTART"),
                                               JOBSTART = r == null ? DateTime.MinValue : r.Field<DateTime>("JOBSTART"),
                                               JOBFINISH = r == null ? DateTime.MinValue : r.Field<DateTime>("JOBFINISH"),
                                               TIMESTAMPBACKUP = r == null ? DateTime.MinValue : r.Field<DateTime>("TIMESTAMPBACKUP"),
                                               TIMESTAMPPREBACKUP = r == null ? DateTime.MinValue : r.Field<DateTime>("TIMESTAMPPREBACKUP"),
                                               DEACTIVATEDCOMMENT = r == null ? "-" : r.Field<string>("DEACTIVATEDCOMMENT"),
                                               JOBID = r == null ? "-" : r.Field<string>("JOBID"),
                                               JOBNAME = r == null ? "-" : r.Field<string>("JOBNAME")
                                           }).ToList();
                            fulldata.Merge(ConvertToTable(results));
                            set.Tables.Add(fulldata);
                        }
                    }
                    catch (Exception ex)
                    {
                        Log.Warning("Fehler beim Merge, Tabellen konnten nicht verlinkt werden!");
                        Log.Warning(ex);
                    }
                }
            }

            StoreData(set);
        }

        //Method for converting the Merged data to a table
        private DataTable ConvertToTable<T>(IEnumerable<T> result)
        {
            DataTable dt = new DataTable();
            PropertyInfo[] columns = null;
            if (result == null) return dt;
            foreach (T item in result)
            {
                if (columns == null)
                {
                    columns = item.GetType().GetProperties();
                    foreach (PropertyInfo propertyInfo in columns)
                    {
                        Type type = propertyInfo.PropertyType;
                        if (type.IsGenericType && (type.GetGenericTypeDefinition() == typeof(Nullable<>)))
                        {
                            type = type.GetGenericArguments()[0];
                        }
                        dt.Columns.Add(new DataColumn(propertyInfo.Name.ToUpper(), type));
                    }
                }
                DataRow dr = dt.NewRow();
                foreach (PropertyInfo info in columns)
                {
                    dr[info.Name] = info.GetValue(item, null) ?? DBNull.Value;
                }
                dt.Rows.Add(dr);
            }
            return dt;
        }

        //Call Store Method for the combined DataSet
        private void StoreData(DataSet data)
        {
            Console.WriteLine("StoringData");
            Database.DatabaseConnection();
            foreach (DataTable table in data.Tables)
            {
                Database.SqlBulkInsert(table);
            }
            Console.WriteLine("Finished");
        }

        //Start reading Components file if an item is Added to the Event Collection
        private void ListOfEventscomp_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            try
            {
                CollectandStoreComponents();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
        }

        //Collect the Data from Components File and Store it into DataBase
        private void CollectandStoreComponents()
        {
            Log.Information($"Started Reading Files in: {Path}");
            xmlData = new XmlData();
            DataSet data;
            DataTable dataTable;
            Database.DatabaseConnection();

            directoryInfo = new DirectoryInfo(Path);
            foreach (var fi in directoryInfo.GetFiles())
            {
                if (fi.Extension == ".xml")
                {
                    try
                    {
                        Console.WriteLine($"Current File:  {fi.Name}");
                        data = new DataSet();
                        data.ReadXmlSchema(fi.FullName);
                        data.ReadXml(fi.FullName);
                        dataTable = xmlData.XmlContentComponents(data, fi.FullName);
                        Database.SqlBulkInsertAssignment(dataTable);
                    }
                    catch (Exception ex)
                    { Log.Error(ex); Log.Error($"Fehler beim Lesen der Datei: {fi.Name}"); Console.WriteLine($"Fehler beim Lesen der Datei: {fi.Name}"); }
                }
            }
        }

        private void RemoveXmlInvalidChars(string path)
        {
            string content = File.ReadAllText(path, Encoding.UTF8);
            File.WriteAllText(path, Regex.Replace(content, @"\p{C}+", string.Empty));
        }
    }
}
