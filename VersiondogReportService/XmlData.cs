using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VersiondogReportService
{
    class XmlData
    {

        public XmlData()
        {
        }

        public DataTable XmlContentComponents(DataSet components, string filename)
        {
            DataTable table = new DataTable(filename);
            table.Columns.Add("COMPONENTTYPE_NAME_COMPL");
            table.Columns.Add("COMPONENTTYPEID");

            DataRow dataRow;

            foreach (DataTable dataTable in components.Tables)
            {
                if (dataTable.TableName.ToLower().Equals("componenttype"))
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        try
                        {
                            dataRow = table.NewRow();
                            dataRow["COMPONENTTYPE_NAME_COMPL"] = row["Name"];
                            dataRow["COMPONENTTYPEID"] = row["ID"];
                            table.Rows.Add(dataRow);
                        }
                        catch (Exception ex)
                        {
                            Log.Error(ex);
                        }
                    }
                }
            }

            return table;
        }

        public DataTable XmlContent(DataSet xmlfilecontent, string fileName, int layers)
        {
            DataTable table = new DataTable(fileName);
            table.Columns.Add("ID");
            table.Columns.Add("PLANT");
            table.Columns.Add("VALUESTREAM");
            table.Columns.Add("COMPONENTID");
            table.Columns.Add("COMPONENTTYPEID");
            table.Columns.Add("COMPONENT");
            table.Columns.Add("COMPONENTTYPE");
            table.Columns.Add("LASTIMPORTINDB", Type.GetType("System.DateTime"));
            table.Columns.Add("VERSIONNUMBER");
            table.Columns.Add("VERSION");
            table.Columns.Add("SECTION");
            table.Columns.Add("SUBSECTION");
            table.Columns.Add("STATION");
            table.Columns.Add("LASTCHANGE", Type.GetType("System.DateTime"));

            DataRow dataRow;


            foreach (DataTable dataTable in xmlfilecontent.Tables)
            {
                if (dataTable.TableName.ToLower().Equals("component"))
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        try
                        {
                            dataRow = table.NewRow();
                            dataRow["ID"] = row["component_Id"];
                            string[] hierachy = row["Path"].ToString().Split('\\');
                            dataRow["PLANT"] = 1 < hierachy.Length ? row["Path"].ToString().Split('\\')[1] : "-";
                            dataRow["VALUESTREAM"] = 2 < hierachy.Length ? row["Path"].ToString().Split('\\')[2] : "-";
                            dataRow["SECTION"] = 3 < hierachy.Length ? row["Path"].ToString().Split('\\')[3] : "-";
                            dataRow["SUBSECTION"] = 4 < hierachy.Length ? row["Path"].ToString().Split('\\')[4] : "-";
                            dataRow["STATION"] = 5 < hierachy.Length ? row["Path"].ToString().Split('\\')[5] : "-";
                            dataRow["COMPONENTID"] = row["Id"];
                            dataRow["COMPONENTTYPEID"] = row["TypeId"];
                            int startIndex = layers + 1;
                            int count = hierachy.Length - startIndex;
                            dataRow["COMPONENT"] = hierachy.Length > startIndex ? string.Join("\\", hierachy, startIndex, count) + "\\" + row["name"] : row["name"];
                            dataRow["LASTIMPORTINDB"] = DateTime.Now;
                            dataRow["VERSIONNUMBER"] = "0";
                            dataRow["VERSION"] = "-";
                            dataRow["LASTCHANGE"] = DateTime.MinValue;
                            table.Rows.Add(dataRow);
                        }
                        catch (Exception ex)
                        {
                            Log.Warning(ex);
                        }
                    }
                }
                if (dataTable.TableName.Equals("Version"))
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        try
                        {
                            dataRow = table.Select("ID='" + row["Versions_Id"] + "'").FirstOrDefault();
                            if (dataRow != null)
                            {
                                dataRow["VERSIONNUMBER"] = row["Number"];
                                if (row["UserDefined"].Equals(""))
                                {
                                    dataRow["VERSION"] = "-";
                                    dataRow["LASTCHANGE"] = DateTime.MinValue;
                                }
                                else
                                {
                                    dataRow["LASTCHANGE"] = DateTime.TryParse(row["TimestampLocal"].ToString(), CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dt) == false ? DateTime.MinValue : row["TimestampLocal"].ToString().Contains("AM") || row["TimestampLocal"].ToString().Contains("PM") ? DateTime.Parse(row["TimestampLocal"].ToString(), CultureInfo.InvariantCulture) : DateTime.Parse(row["TimestampLocal"].ToString());
                                    dataRow["VERSION"] = row["UserDefined"];
                                }
                                table.AcceptChanges();
                            }
                        }
                        catch (Exception ex)
                        {
                            Log.Warning(ex);
                        }
                    }
                }
            }
            table.Columns.Remove("ID");

            return table;
        }

        public DataTable XmlContent(DataSet xmlfilecontent, string fileName, int layers, string plant, bool newstruct)
        {
            DataTable table = new DataTable(fileName);
            table.Columns.Add("ID");
            table.Columns.Add("PLANT");
            table.Columns.Add("VALUESTREAM");
            table.Columns.Add("COMPONENTID");
            table.Columns.Add("COMPONENTTYPEID");
            table.Columns.Add("COMPONENT");
            table.Columns.Add("COMPONENTTYPE");
            table.Columns.Add("LASTIMPORTINDB", Type.GetType("System.DateTime"));
            table.Columns.Add("VERSIONNUMBER");
            table.Columns.Add("VERSION");
            table.Columns.Add("SECTION");
            table.Columns.Add("SUBSECTION");
            table.Columns.Add("STATION");
            table.Columns.Add("LASTCHANGE", Type.GetType("System.DateTime"));

            DataRow dataRow;

            if (newstruct)
            {
                foreach (DataTable dataTable in xmlfilecontent.Tables)
                {
                    if (dataTable.TableName.ToLower().Equals("component"))
                    {
                        foreach (DataRow row in dataTable.Rows)
                        {
                            try
                            {
                                dataRow = table.NewRow();
                                dataRow["ID"] = row["component_Id"];
                                string[] hierachy = row["Path"].ToString().Split('\\');
                                dataRow["PLANT"] = plant;
                                dataRow["VALUESTREAM"] = 1 < hierachy.Length ? row["Path"].ToString().Split('\\')[1] : "-";
                                dataRow["SECTION"] = 2 < hierachy.Length ? row["Path"].ToString().Split('\\')[2] : "-";
                                dataRow["SUBSECTION"] = 3 < hierachy.Length ? row["Path"].ToString().Split('\\')[3] : "-";
                                dataRow["STATION"] = 4 < hierachy.Length ? row["Path"].ToString().Split('\\')[4] : "-";
                                dataRow["COMPONENTID"] = row["Id"];
                                dataRow["COMPONENTTYPEID"] = row["TypeId"];
                                int startIndex = layers + 1;
                                int count = hierachy.Length - startIndex;
                                dataRow["COMPONENT"] = hierachy.Length > startIndex ? string.Join("\\", hierachy, startIndex, count) + "\\" + row["name"] : row["name"];
                                dataRow["LASTIMPORTINDB"] = DateTime.Now;
                                dataRow["VERSIONNUMBER"] = "0";
                                dataRow["VERSION"] = "-";
                                dataRow["LASTCHANGE"] = DateTime.MinValue;
                                table.Rows.Add(dataRow);
                            }
                            catch (Exception ex)
                            {
                                Log.Warning(ex);
                            }
                        }
                    }
                    if (dataTable.TableName.Equals("Version"))
                    {
                        foreach (DataRow row in dataTable.Rows)
                        {
                            try
                            {
                                dataRow = table.Select("ID='" + row["Versions_Id"] + "'").FirstOrDefault();
                                if (dataRow != null)
                                {
                                    dataRow["VERSIONNUMBER"] = row["Number"];
                                    if (row["UserDefined"].Equals(""))
                                    {
                                        dataRow["VERSION"] = "-";
                                        dataRow["LASTCHANGE"] = DateTime.MinValue;
                                    }
                                    else
                                    {
                                        dataRow["LASTCHANGE"] = DateTime.TryParse(row["TimestampLocal"].ToString(), CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dt) == false ? DateTime.MinValue : row["TimestampLocal"].ToString().Contains("AM") || row["TimestampLocal"].ToString().Contains("PM") ? DateTime.Parse(row["TimestampLocal"].ToString(), CultureInfo.InvariantCulture) : DateTime.Parse(row["TimestampLocal"].ToString());
                                        dataRow["VERSION"] = row["UserDefined"];
                                    }
                                    table.AcceptChanges();
                                }
                            }
                            catch (Exception ex)
                            {
                                Log.Warning(ex);
                            }
                        }
                    }
                }
            }
            else
            {
                foreach (DataTable dataTable in xmlfilecontent.Tables)
                {
                    if (dataTable.TableName.Equals("component"))
                    {
                        foreach (DataRow row in dataTable.Rows)
                        {
                            try
                            {
                                dataRow = table.NewRow();
                                dataRow["ID"] = row["component_Id"];
                                string[] hierachy = row["Path"].ToString().Split('\\');
                                dataRow["PLANT"] = plant;
                                dataRow["VALUESTREAM"] = 1 < hierachy.Length ? row["Path"].ToString().Split('\\')[1] : "-";
                                dataRow["SECTION"] = 2 < hierachy.Length ? row["Path"].ToString().Split('\\')[2] : "-";
                                dataRow["SUBSECTION"] = 3 < hierachy.Length ? row["Path"].ToString().Split('\\')[3] : "-";
                                dataRow["STATION"] = 4 < hierachy.Length ? row["Path"].ToString().Split('\\')[4] : "-";
                                dataRow["COMPONENTID"] = row["Id"];
                                dataRow["COMPONENTTYPEID"] = row["TypeId"];
                                int startIndex = layers + 1;
                                int count = hierachy.Length - startIndex;
                                dataRow["COMPONENT"] = hierachy.Length > startIndex ? string.Join("\\", hierachy, startIndex, count) + "\\" + row["name"] : row["name"];
                                dataRow["LASTIMPORTINDB"] = DateTime.Now;
                                dataRow["VERSIONNUMBER"] = "0";
                                dataRow["VERSION"] = "-";
                                dataRow["LASTCHANGE"] = DateTime.MinValue;
                                table.Rows.Add(dataRow);
                            }
                            catch (Exception ex)
                            {
                                Log.Warning(ex);
                            }
                        }
                    }
                    if (dataTable.TableName.Equals("Version"))
                    {
                        foreach (DataRow row in dataTable.Rows)
                        {
                            try
                            {
                                dataRow = table.Select("ID='" + row["Versions_Id"] + "'").FirstOrDefault();
                                if (dataRow != null)
                                {
                                    dataRow["VERSIONNUMBER"] = row["Number"];
                                    if (row["UserDefined"].Equals(""))
                                    {
                                        dataRow["VERSION"] = "-";
                                        dataRow["LASTCHANGE"] = DateTime.MinValue;
                                    }
                                    else
                                    {
                                        dataRow["LASTCHANGE"] = DateTime.TryParse(row["TimeStamp"].ToString(), CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dt) == false ? DateTime.MinValue : row["TimeStamp"].ToString().Contains("AM") || row["TimeStamp"].ToString().Contains("PM") ? DateTime.Parse(row["TimeStamp"].ToString(), CultureInfo.InvariantCulture) : DateTime.Parse(row["TimeStamp"].ToString());
                                        dataRow["VERSION"] = row["UserDefined"];
                                    }
                                    table.AcceptChanges();
                                }
                            }
                            catch (Exception ex)
                            {
                                Log.Warning(ex);
                            }
                        }
                    }
                }
            }
            table.Columns.Remove("ID");

            return table;
        }


    }
}
