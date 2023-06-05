using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.IO;
using System.Globalization;

namespace VersiondogReportService
{
    class CsvData
    {
        public CsvData()
        {
        }

        public DataTable CsvContent(string path, string filename)
        {
            DataTable table = new DataTable(filename);
            string[] dateTimeColumns = Properties.Settings.Default.Csv_DateTime_Columns.Split(';');

            try
            {
                FileStream file = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
                using (StreamReader sr = new StreamReader(file, Encoding.Default))
                {
                    string line = sr.ReadLine();
                    string[] lineData = line.Contains(";") ? line.Split(';') : line.Split(',');
                    foreach (string item in lineData)
                    {
                        table.Columns.Add(item.Replace("\"", string.Empty).ToUpper().Replace(" (LOCAL)", string.Empty));

                    }

                    DataRow row = table.NewRow();
                    while (sr.Peek() > -1)
                    {
                        line = sr.ReadLine();
                        lineData = line.Contains(";") ? line.Replace("\"", string.Empty).Split(';') : line.Replace("\"", string.Empty).Split(',');
                        table.Rows.Add(lineData);
                    }

                }

                foreach (var column in dateTimeColumns)
                {
                    for (int i = 0; i < table.Rows.Count; i++)
                    {
                        if (table.Rows[i][column].ToString().Equals(""))
                        {
                            table.Rows[i][column] = DateTime.MinValue.ToString("dd.MM.yyyy HH:mm:ss");
                        }
                        else if (table.Rows[i][column].ToString().Contains("AM") || table.Rows[i][column].ToString().Contains("PM"))
                        {
                            DateTime usDateTime = DateTime.TryParse(table.Rows[i][column].ToString(), new CultureInfo("en-US"), DateTimeStyles.None, out DateTime dateTime) == false ? DateTime.MinValue : dateTime;
                            table.Rows[i][column] = usDateTime.To24HDateTime();
                        }
                    }
                    table.ConvertColumnType(column, typeof(DateTime));
                }

                foreach (DataColumn column in table.Columns)
                {
                    for (int i = 0; i < table.Rows.Count; i++)
                    {
                        if (table.Rows[i][column].ToString().Equals(""))
                        {
                            table.Rows[i][column] = "-";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            return table;
        }

    }

    public static class DataTableExt
    {
        public static void ConvertColumnType(this DataTable dt, string columnName, Type newType)
        {
            using (DataColumn column = new DataColumn(columnName + "_", newType))
            {
                int ordinal = dt.Columns[columnName].Ordinal;
                dt.Columns.Add(column);
                column.SetOrdinal(ordinal);

                foreach (DataRow row in dt.Rows)
                {
                    row[column.ColumnName] = row[columnName] == DBNull.Value ? DBNull.Value : Convert.ChangeType(row[columnName], newType);
                }

                dt.Columns.Remove(columnName);
                column.ColumnName = columnName;
            }
        }

        public static string To24HDateTime(this DateTime dateTime)
        {
            return dateTime.ToString("dd.MM.yyyy HH:mm:ss");
        }
    }
}
