using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VersiondogReportService
{
    class ReadCsvInformation
    {

        public string Pfadtoproject { get; set; }
        public string Bereich { get; set; }
        public string Line { get; set; }
        public bool First_line { get; set; }
        public string[] Componentinfo { get; set; }
        public string Datum { get; set; }
        public string Datum1 { get; set; }
        public string Datum2 { get; set; }
        public string Datum3 { get; set; }
        public string Datum4 { get; set; }
        public string Datum5 { get; set; }
        public string[] DatumSplit { get; set; }
        public int Zeile { get; set; }
        public string Pfad { get; set; }

        public ReadCsvInformation()
        {
            string empty = string.Empty;
            Pfadtoproject = empty;
            Bereich = null;
            Line = empty;
            First_line = false;
            Datum = empty;
            Datum1 = empty;
            Datum2 = empty;
            Datum3 = empty;
            Datum4 = empty;
            Datum5 = empty;
            Zeile = 0;
        }

        public DataTable ReadData(string pfad, string filename)
        {
            Pfad = pfad;
            string empty = string.Empty;
            Pfadtoproject = empty;
            Bereich = null;
            Line = empty;
            First_line = false;
            Datum = empty;
            Datum1 = empty;
            Datum2 = empty;
            Datum3 = empty;
            Datum4 = empty;
            Datum5 = empty;
            Zeile = 0;

            DataTable table = new DataTable(filename);
            table.Columns.Add("COMPONENTID");
            table.Columns.Add("RESULTVERSIONVSBACKUP");
            table.Columns.Add("RESULTBACKUPVSPREBACKUP");
            table.Columns.Add("LASTCHECK", Type.GetType("System.DateTime"));
            table.Columns.Add("COMPONENTTREE");
            table.Columns.Add("EXECUTION");
            table.Columns.Add("IP_NAME");
            table.Columns.Add("UPLOADAGENT");
            table.Columns.Add("NEXTSTART", Type.GetType("System.DateTime"));
            table.Columns.Add("JOBSTART", Type.GetType("System.DateTime"));
            table.Columns.Add("JOBFINISH", Type.GetType("System.DateTime"));
            table.Columns.Add("TIMESTAMPBACKUP", Type.GetType("System.DateTime"));
            table.Columns.Add("TIMESTAMPPREBACKUP", Type.GetType("System.DateTime"));
            table.Columns.Add("DEACTIVATEDCOMMENT");
            table.Columns.Add("JOBID");
            table.Columns.Add("JOBNAME");

            DataRow row;


            //Initialize new StreamReader to Read CSV File
            try
            {
                StreamReader sr = new StreamReader(Pfad);


                try
                {
                    //while reading cycle trough Data
                    while ((Line = sr.ReadLine()) != null)
                    {
                        if (First_line == true)
                        {
                            Zeile++;
                            //Check for Delimiter Type
                            if (Line.Contains(";"))
                            { Componentinfo = Line.Split(';'); }
                            else
                            { Componentinfo = Line.Split(','); }

                            //Remove / from Data
                            for (int i = 0; i < Componentinfo.Length; i++)
                            {
                                Componentinfo[i] = Componentinfo[i].Replace("\"", string.Empty);
                            }

                            try
                            {
                                try
                                {
                                    //Convert Time to 24h format and Date
                                    if (Componentinfo[12].Contains("AM") || Componentinfo[12].Contains("PM"))
                                    {
                                        Datum = Componentinfo[12].Remove(Componentinfo[12].Length - 11);
                                        DatumSplit = Datum.Split('/');
                                        Datum = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[12].Length > 7 && !Componentinfo[12].Contains("AM") && !Componentinfo[12].Contains("PM"))
                                    {
                                        Datum = Componentinfo[12].Remove(Componentinfo[12].Length - 9);
                                    }
                                    else
                                    {
                                        Datum = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                try
                                {
                                    if (Componentinfo[13].Contains("AM") || Componentinfo[13].Contains("PM"))
                                    {
                                        Datum1 = Componentinfo[13].Remove(Componentinfo[13].Length - 11);
                                        DatumSplit = Datum1.Split('/');
                                        Datum1 = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[13].Length > 7 && !Componentinfo[13].Contains("AM") && !Componentinfo[13].Contains("PM"))
                                    {
                                        Datum1 = Componentinfo[13].Remove(Componentinfo[13].Length - 9);
                                    }
                                    else
                                    {
                                        Datum1 = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                try
                                {
                                    if (Componentinfo[14].Contains("AM") || Componentinfo[14].Contains("PM"))
                                    {
                                        Datum2 = Componentinfo[14].Remove(Componentinfo[14].Length - 11);
                                        DatumSplit = Datum2.Split('/');
                                        Datum2 = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[14].Length > 7 && !Componentinfo[14].Contains("AM") && !Componentinfo[14].Contains("PM"))
                                    {
                                        Datum2 = Componentinfo[14].Remove(Componentinfo[14].Length - 9);
                                    }
                                    else
                                    {
                                        Datum2 = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                try
                                {
                                    if (Componentinfo[15].Contains("AM") || Componentinfo[15].Contains("PM"))
                                    {
                                        Datum3 = Componentinfo[15].Remove(Componentinfo[15].Length - 11);
                                        DatumSplit = Datum3.Split('/');
                                        Datum3 = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[15].Length > 7 && !Componentinfo[15].Contains("AM") && !Componentinfo[15].Contains("PM"))
                                    {
                                        Datum3 = Componentinfo[15].Remove(Componentinfo[15].Length - 9);
                                    }
                                    else
                                    {
                                        Datum3 = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                try
                                {
                                    if (Componentinfo[19].Contains("AM") || Componentinfo[19].Contains("PM"))
                                    {
                                        Datum4 = Componentinfo[19].Remove(Componentinfo[19].Length - 11);
                                        DatumSplit = Datum4.Split('/');
                                        Datum4 = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[19].Length > 7 && !Componentinfo[19].Contains("AM") && !Componentinfo[19].Contains("PM"))
                                    {
                                        Datum4 = Componentinfo[19].Remove(Componentinfo[19].Length - 9);
                                    }
                                    else
                                    {
                                        Datum4 = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                try
                                {
                                    if (Componentinfo[21].Contains("AM") || Componentinfo[21].Contains("PM"))
                                    {
                                        Datum5 = Componentinfo[21].Remove(Componentinfo[21].Length - 11);
                                        DatumSplit = Datum5.Split('/');
                                        Datum5 = $"{DatumSplit[1]}.{DatumSplit[0]}.{DatumSplit[2]}";
                                    }
                                    else if (Componentinfo[21].Length > 7 && !Componentinfo[21].Contains("AM") && !Componentinfo[21].Contains("PM"))
                                    {
                                        Datum5 = Componentinfo[21].Remove(Componentinfo[21].Length - 9);
                                    }
                                    else
                                    {
                                        Datum5 = DateTime.MinValue.ToShortDateString();
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Log.Warning(ex);
                                }

                                //Add data to List

                                row = table.NewRow();
                                row["COMPONENTID"] = Componentinfo[1] == string.Empty ? "-" : Componentinfo[1];
                                row["RESULTVERSIONVSBACKUP"] = int.TryParse((Componentinfo[16] == string.Empty ? "0" : Componentinfo[16]), out int verback) == false ? -1 : verback;
                                row["RESULTBACKUPVSPREBACKUP"] = int.TryParse((Componentinfo[17] == string.Empty ? "0" : Componentinfo[17]), out int backpre) == false ? -1 : backpre;
                                row["LASTCHECK"] = DateTime.TryParse(Datum, out DateTime date) == false ? DateTime.MinValue : date;
                                row["COMPONENTTREE"] = Componentinfo[0] == string.Empty ? "-" : Componentinfo[0];
                                row["EXECUTION"] = int.TryParse((Componentinfo[8] == string.Empty ? "0" : Componentinfo[8]), out int exec) == false ? -1 : exec;
                                row["IP_NAME"] = Componentinfo[9] == string.Empty ? "-" : Componentinfo[9];
                                row["UPLOADAGENT"] = Componentinfo[10] == string.Empty ? "-" : Componentinfo[10];
                                row["NEXTSTART"] = DateTime.TryParse(Datum1, out DateTime date1) == false ? DateTime.MinValue : date1;
                                row["JOBSTART"] = DateTime.TryParse(Datum2, out DateTime date2) == false ? DateTime.MinValue : date2;
                                row["JOBFINISH"] = DateTime.TryParse(Datum3, out DateTime date3) == false ? DateTime.MinValue : date3;
                                row["TIMESTAMPBACKUP"] = DateTime.TryParse(Datum4, out DateTime date4) == false ? DateTime.MinValue : date4;
                                row["TIMESTAMPPREBACKUP"] = DateTime.TryParse(Datum5, out DateTime date5) == false ? DateTime.MinValue : date5;
                                row["DEACTIVATEDCOMMENT"] = Componentinfo[24] == string.Empty ? "-" : Componentinfo[24];
                                row["JOBID"] = Componentinfo[4] == string.Empty ? "-" : Componentinfo[4];
                                row["JOBNAME"] = Componentinfo[5] == string.Empty ? "-" : Componentinfo[5];
                                table.Rows.Add(row);
                            }
                            catch (Exception ex)
                            { Log.Warning(ex); }

                        }


                        First_line = true;
                    }
                }
                catch (Exception ex)
                {
                    Log.Error(ex);
                }

            }
            catch (Exception e)
            {
                Log.Error($"Fehler beim Öffnen oder Auslesen der Datei ({Pfad})");
                Log.Error(e);
            }

            return table;
        }
    }
}
